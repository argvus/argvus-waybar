#pragma once
#include "AModule.hpp"
#include "bar.hpp"
#include <atomic>
#include <gio/gio.h>
#include <mutex>
#include <thread>

namespace waybar::modules::hyprland {
class ArgvusWindows : public AModule {
public:
  ArgvusWindows(const std::string &, const Bar &, const Json::Value &);
  ~ArgvusWindows() override;
  void update() override;

private:
  const Bar &bar_;
  Gtk::Box box_{Gtk::ORIENTATION_HORIZONTAL, 4};
  std::mutex mutex_;
  Json::Value snapshot_;
  std::atomic<bool> running_{true};
  GCancellable *cancellation_;
  GSubprocess *process_ = nullptr;
  std::thread worker_;
  sigc::connection heartbeat_;
  std::unique_ptr<Gtk::Menu> context_menu_;
  void listen();
  void action(const std::string &, const std::string &);
};
} // namespace waybar::modules::hyprland
