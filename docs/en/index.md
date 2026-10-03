---
title: Waybar and taskbar overrides
description: Customize the ARGVUS Waybar taskbar without editing packaged files.
---

`argvus-taskbar` provides the ARGVUS taskbar JSONC/CSS configuration and its helper scripts. `argvus-waybar` provides the Waybar binary, while `argvus-session` starts the service and selects the effective files. The managed copy and the generated copy are both written by `argvus-config`: it replaces the theme layer and reapplies taskbar margins, `right-2` utility-group mode, border radius and the telemetry font block whenever themes or layout state change. `argvus-appearance` no longer writes these files; it only commits the change and asks for a reload.

## Configuration precedence

For the taskbar and the telemetry surface, `argvus-sessionctl` resolves the configuration and stylesheet independently in this order:

```text
~/.config/argvus/data/generated/waybar/argvus-taskbar.{jsonc,css}
~/.config/argvus/data/generated/waybar/argvus-widget-telemetry.{jsonc,css}
        ↓
~/.config/argvus/data/waybar/argvus-taskbar.{jsonc,css}
~/.config/argvus/data/waybar/argvus-widget-telemetry.{jsonc,css}
        ↓
~/.config/waybar/argvus-taskbar.{jsonc,css}
~/.config/waybar/argvus-widget-telemetry.{jsonc,css}
        ↓
/usr/share/argvus/taskbar/config/argvus-taskbar.{jsonc,css}
```

`$XDG_CONFIG_HOME` replaces `~/.config` when it is set. The first existing file wins.

The generated tree comes **first** so the active theme layer always wins: a stale user or native copy must not keep the taskbar on the previous theme. The practical consequence is that a native `~/.config/waybar/` override only takes effect while the corresponding generated file is absent — for example after `rm -rf ~/.config/argvus/data/generated` before the next reload, or when a file was never projected. If you want a durable native override that survives theme changes, use the generated tree as the starting point, or accept that the theme layer owns these two files.

The configuration is not merged: an override JSONC file replaces the complete taskbar configuration, and an override CSS file replaces the complete stylesheet.

The packaged defaults are read-only inputs. Do not edit:

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```

## Managed ARGVUS configuration

The normal ARGVUS session uses the managed copies under:

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```

`argvus-config` recreates these files from the packaged defaults when applying a theme, then reapplies persistent ARGVUS state such as taskbar margins, the `right-2` utility-group mode, border radius and the font block. The same is true of `data/waybar/argvus-taskbar.{jsonc,css}` and `data/waybar/argvus-widget-telemetry.{jsonc,css}`: they are replaced from the packaged defaults on an appearance change, so manual edits there are lost too.

Generated files under `~/.config/argvus/data/generated/waybar/` are derived state and should not be edited directly; the whole tree is rebuilt from `config.json` on the next `argvus-config apply`. Do not use `argvus --setup --copy taskbar` as the taskbar customization path; the taskbar runner resolves its canonical `data/taskbar/` locations above.

## Persistent JSONC customization

For a durable manual taskbar configuration, create a complete native Waybar override:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```

Edit the copy in `~/.config/waybar/`. Common changes include:

```jsonc
{
  "modules-left": ["hyprland/workspaces", "custom/my-module"],
  "custom/my-module": {
    "exec": "my-command",
    "interval": 10,
    "format": "{}"
  }
}
```

The example illustrates the Waybar structure; keep the rest of the packaged configuration when customizing it. A native override is a complete file, not a partial JSONC fragment. Preserve modules and scripts required by the ARGVUS desktop if you want the existing taskbar actions to continue working.

## Persistent CSS customization

The packaged stylesheet imports theme files with relative paths. If you override the CSS, copy the theme directory as well or replace the imports with paths that exist in your configuration:

```sh
mkdir -p ~/.config/waybar/themes
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
cp -a /usr/share/argvus/taskbar/config/themes/. ~/.config/waybar/themes/
```

Native CSS and theme files become user-owned. Theme changes will not regenerate them automatically; update them deliberately when ARGVUS adds or changes theme assets.

## Apply changes and inspect the effective file

Restart only the taskbar after changing its JSONC or CSS:

```sh
argvus-sessionctl restart waybar
```

For a complete session/configuration refresh, use:

```sh
argvus-sessionctl reload
```

To see which files the running Waybar process actually uses:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```

The process should show `-c` for the effective JSONC file and `-s` for the effective CSS file. If a native file exists, changes to the managed ARGVUS copy will not change the active taskbar until the native file is removed or updated.

The service and logs can be inspected with:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```

See [Taskbar](/docs/argvus-taskbar/taskbar/) for the user-facing features and [file locations](/docs/reference/file-locations/) for the installed and user paths.
