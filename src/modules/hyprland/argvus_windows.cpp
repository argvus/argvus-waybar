#include "modules/hyprland/argvus_windows.hpp"
#include "util/json.hpp"
#include <chrono>
#include <glibmm/spawn.h>
#include <spdlog/spdlog.h>

namespace waybar::modules::hyprland {
ArgvusWindows::ArgvusWindows(const std::string &id, const Bar &bar,
                             const Json::Value &config)
    : AModule(config, "argvus-windows", id), bar_(bar),
      cancellation_(g_cancellable_new()) {
  box_.set_name("argvus-windows");
  box_.set_homogeneous(true);
  event_box_.add(box_);
  heartbeat_ = Glib::signal_timeout().connect(
      [this] {
        if (bar_.window.get_mapped() && event_box_.get_mapped())
          action("ready", "");
        return true;
      },
      1000);
  worker_ = std::thread([this] { listen(); });
}

ArgvusWindows::~ArgvusWindows() {
  heartbeat_.disconnect();
  running_ = false;
  g_cancellable_cancel(cancellation_);
  {
    std::lock_guard lock(mutex_);
    if (process_)
      g_subprocess_force_exit(process_);
  }
  worker_.join();
  g_object_unref(cancellation_);
}

void ArgvusWindows::listen() {
  while (running_) {
    GError *error = nullptr;
    auto process =
        g_subprocess_new(G_SUBPROCESS_FLAGS_STDOUT_PIPE, &error, "argvus",
                         "windows", "watch", "--json", nullptr);
    if (!process) {
      if (error) {
        spdlog::warn("argvus-windows: {}", error->message);
        g_error_free(error);
      }
      std::this_thread::sleep_for(std::chrono::seconds(1));
      continue;
    }
    {
      std::lock_guard lock(mutex_);
      process_ = process;
    }
    auto input = g_data_input_stream_new(g_subprocess_get_stdout_pipe(process));
    while (running_) {
      gsize length = 0;
      auto line =
          g_data_input_stream_read_line(input, &length, cancellation_, nullptr);
      if (!line)
        break;
      try {
        auto snapshot = util::JsonParser{}.parse(std::string(line, length));
        {
          std::lock_guard lock(mutex_);
          snapshot_ = std::move(snapshot);
        }
        dp.emit();
      } catch (const std::exception &exception) {
        spdlog::warn("argvus-windows: {}", exception.what());
      }
      g_free(line);
    }
    g_object_unref(input);
    g_subprocess_force_exit(process);
    g_subprocess_wait(process, nullptr, nullptr);
    {
      std::lock_guard lock(mutex_);
      process_ = nullptr;
    }
    g_object_unref(process);
    if (running_)
      std::this_thread::sleep_for(std::chrono::seconds(1));
  }
}

void ArgvusWindows::action(const std::string &action,
                           const std::string &address) {
  try {
    std::vector<std::string> arguments{"argvus", "windows", action};
    if (!address.empty())
      arguments.push_back(address);
    Glib::spawn_async("", arguments, Glib::SPAWN_SEARCH_PATH);
  } catch (const std::exception &exception) {
    spdlog::warn("argvus-windows action: {}", exception.what());
  }
}

void ArgvusWindows::update() {
  Json::Value snapshot;
  {
    std::lock_guard lock(mutex_);
    snapshot = snapshot_;
  }
  std::string focused;
  for (auto child : box_.get_children()) {
    if (child->has_focus())
      focused = child->get_name();
    box_.remove(*child);
    delete child;
  }
  const auto labels = snapshot["labels"];
  for (const auto &window : snapshot["windows"]) {
    if (window["output"].asString() != bar_.output->name)
      continue;
    const auto address = window["address"].asString();
    auto button = new Gtk::Button();
    button->set_name(address);
    auto row = Gtk::make_managed<Gtk::Box>(Gtk::ORIENTATION_HORIZONTAL, 6);
    // Load explicitly: a missing/broken icon must not make GTK's asynchronous
    // image-missing fallback abort the entire recovery bar.
    auto theme = Gtk::IconTheme::get_default();
    Glib::RefPtr<Gdk::Pixbuf> pixels;
    try {
      if (theme && theme->has_icon(window["app_id"].asString()))
        pixels = theme->load_icon(window["app_id"].asString(), 16,
                                  Gtk::ICON_LOOKUP_FORCE_SIZE);
    } catch (const Glib::Error &error) {
      spdlog::debug("argvus-windows icon: {}", error.what().raw());
    }
    if (pixels) {
      auto icon = Gtk::make_managed<Gtk::Image>(pixels);
      row->pack_start(*icon, false, false);
    } else {
      row->pack_start(*Gtk::make_managed<Gtk::Label>("□"), false, false);
    }
    auto title = Gtk::make_managed<Gtk::Label>(window["title"].asString());
    title->set_ellipsize(Pango::ELLIPSIZE_END);
    title->set_max_width_chars(24);
    row->pack_start(*title, true, true);
    button->add(*row);
    button->set_tooltip_text(window["title"].asString() + "\n" +
                             labels["workspace"].asString() + ": " +
                             window["workspace"].asString());
    if (window["active"].asBool())
      button->get_style_context()->add_class("active");
    if (window["minimized"].asBool())
      button->get_style_context()->add_class("minimized");
    button->signal_clicked().connect(
        [this, address] { action("toggle", address); });
    button->signal_button_press_event().connect(
        [this, address, labels](GdkEventButton *event) {
          if (event->button != 3)
            return false;
          context_menu_ = std::make_unique<Gtk::Menu>();
          auto menu = context_menu_.get();
          for (const auto &command :
               {"restore", "minimize", "maximize", "close"}) {
            auto item =
                Gtk::make_managed<Gtk::MenuItem>(labels[command].asString());
            item->signal_activate().connect(
                [this, address, command] { action(command, address); });
            menu->append(*item);
          }
          menu->show_all();
          menu->popup_at_pointer(reinterpret_cast<GdkEvent *>(event));
          return true;
        },
        false);
    box_.pack_start(*button, true, true);
    button->show_all();
    if (focused == address)
      button->grab_focus();
  }
  box_.show();
  if (bar_.window.get_mapped() && event_box_.get_mapped())
    action("ready", "");
  AModule::update();
}
} // namespace waybar::modules::hyprland
