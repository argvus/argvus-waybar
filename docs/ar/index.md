---
title:                                                    ﻡﺎﻬﻤﻟﺍ ﻂﻳﺮﺷﻭ Waybar ﺕﺍﺯﻭﺎﺠﺗ
description: Customize the ARGVUS Waybar taskbar without editing packaged files.
---

 provides the ARGVUS taskbar JSONC/CSS configuration and its helper scripts. 

 provides the Waybar binary, while 

 starts the service and selects the effective files. The managed copy and the generated copy are both written by 

: it replaces the theme layer and reapplies taskbar margins, 

 utility-group mode, border radius and the telemetry font block whenever themes or layout state change. 

 no longer writes these files; it only commits the change and asks for a reload.

##                                                                 ﺔﺌﻴﻬﺘﻟﺍ ﺔﻳﻮﻟﻭﺃ

:ﻲﻟﺎﺘﻟﺍ ﺐﻴﺗﺮﺘﻟﺎﺑ ﻞﻘﺘﺴﻣ ﻞﻜﺸﺑ ﻁﺎﻤﻧﻷ﻿ﺍ ﺔﻗﺭﻭﻭ ﻦﻳﻮﻜﺘﻟﺍ ﻞﺤﺑ  argvus-appearance  right-2  argvus-config  argvus-session  argvus-waybar  `argvus-taskbar`  `argvus-waybar`  `argvus-session`  `argvus-config`  `right-2`  `argvus-appearance` `argvus sessionctl` ﻡﻮﻘﻳ ،ﺪ

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

`$XDG_CONFIG_HOME` ﻞﺤﻣ ﻞﺤﻳ `~/.config` ﺰﺋﺎﻔﻟﺍ ﻮﻫ ًﻻ﻿ﻭﺃ ﺩﻮﺟﻮﻤﻟﺍ ﻒﻠﻤﻟﺍ .ﻪﻨﻴﻴﻌ



.ﻞﻣﺎﻜﻟﺎﺑ ﻁﺎﻤﻧﻷ﻿ﺍ ﺔﻗﺭﻭ ﻝﺪﺒﺘﺴﻳ ﺯﻭﺎﺠﺘﻠﻟ CSS ﻒﻠﻣﻭ ،ﻞﻣﺎﻜﻟﺎﺑ ﻡﺎﻬﻤﻟﺍ ﻂﻳﺮﺷ ﻦﻳﻮﻜﺗ ﻝﺪﺒﺘﺴﻳ

              :ﺎﻫﺮﻳﺮﺤﺘﺑ ﻢﻘﺗ ﻻ﻿ .ﻂﻘﻓ ﺓءﺍﺮﻘﻠﻟ ﺕﻼ﻿ﺧﺪﻣ ﻲﻫ ﺓﺄﺒﻌﻤﻟﺍ ﺔﻴﺿﺍﺮﺘﻓﻻ﻿ﺍ ﺕﺍﺩﺍﺪﻋﻹ﻿ﺍ

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```

##                                                            ﺭﺍﺪﻤﻟﺍ ARGVUS ﻦﻳﻮﻜﺗ

                                 :ﺖﺤﺗ ﺓﺭﺍﺪُﻤﻟﺍ ﺦﺴﻨﻟﺍ ﻡﺪﺨﺘﺴﺗ ﺔﻳﺩﺎﻌﻟﺍ ARGVUS ﺔﺴﻠﺟ

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```

argvus-config recreates these files from the packaged defaults when applying a theme, then reapplies persistent ARGVUS state such as taskbar margins, the right-2 utility-group mode, border radius and the font block. The same is true of data/waybar/argvus-taskbar.{jsonc,css} and data/waybar/argvus-widget-telemetry.{jsonc,css}: they are replaced from the packaged defaults on an appearance change, so manual edits there are lost too.

## ﺮﻤﺘﺴﻣ JSONC ﺺﻴﺼﺨﺗ

                       :ﻞﻣﺎﻛ ﻲﻠﺻﺃ Waybar ﺯﻭﺎﺠﺗ ﺊﺸﻧﺃ ،ﻢﺋﺍﺩ ﻱﻭﺪﻳ ﻡﺎﻬﻣ ﻂﻳﺮﺷ ﺩﺍﺪﻋﻹ﻿

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```

                      :ﺔﻌﺋﺎﺸﻟﺍ ﺕﺍﺮﻴﻴﻐﺘﻟﺍ ﻞﻤﺸﺗ .`~/.config/waybar/` argvus windows watch --json  hyprland/argvus-windows  argvus projects  tooltip  label  argvus/project-workspaces.json  $XDG_RUNTIME_DIR  hyprland/workspaces.workspace-metadata  id  -s  -c  ~/.config/waybar/  data/taskbar/  argvus --setup --copy taskbar  argvus config apply  config.json  ~/.config/argvus/data/generated/waybar/  data/waybar/argvus-widget-telemetry.{jsonc,css}  data/waybar/argvus-taskbar.{jsonc,css}  right-2  argvus-config  `rm -rf ~/.config/argvus/data/generated` `argvus-config`  `right-2`  `data/waybar/argvus-taskbar.{jsonc,css}`  `data/waybar/argvus-widget-telemetry.{jsonc,css}`  `~/.config/argvus/data/generated/waybar/`  `config.json`  `argvus config apply`  `argvus --setup --copy taskbar`  `data/taskbar/`  `~/.config/waybar/`  `-c`  `-s`  `id`  `hyprland/workspaces.workspace-metadata`  `$XDG_RUNTIME_DIR`  `argvus/project-workspaces.json`  `label`  `tooltip`  `argvus projects`  `hyprland/argvus-windows`  `argvus windows watch --json`   ﻲﻓ ﺔﺨﺴﻨﻟﺍ ﺭﺮﺣ

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

.ﻞﻤﻌﻟﺍ ﻲﻓ ﺔﻴﻟﺎﺤﻟﺍ ﻡﺎﻬﻤﻟﺍ ﻂﻳﺮ

## ﺮﻤﺘﺴﻣ CSS ﺺﻴﺼﺨﺗ

:ﺔﻤﺴﻟﺍ ﺕﻼ﻿ﻳﺪﺒﺗ ﺮﺒﻋ ﻮﻫ ﺎﻤﻛ ﻩﺭﺎﺴﻣ ﻞﻈﻳ ﻱﺬﻟﺍ ،ءﺎﻨﺒﻟﺍ ﻰﻟﺇ ﺔﻤﺴﻟﺍ ﺩﺍﺮﻴﺘﺳﺍ ﻪﻴﺟﻮﺘﺑ ﻢﻘﻓ ،

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```

.ﺕﺎﻤﺴﻟﺍ ﻝﻮﺻﺃ ﺮﻴﻐﻳ ﻭﺃ ARGVUS ﻒﻴﻀﻳ ﺎﻣﺪﻨﻋ ﺍًﺪﻤﻋ ﺎﻬﺜﻳﺪﺤﺘﺑ ﻢﻗ ؛ﺎًﻴﺋﺎﻘﻠﺗ ﺎﻬﺋﺎﺸﻧﺇ ﺓﺩﺎﻋﺈ

##                                              ﻝﺎّﻌﻔﻟﺍ ﻒﻠﻤﻟﺍ ﺺﺤﻓﻭ ﺕﺍﺮﻴﻴﻐﺘﻟﺍ ﻖﻴﺒﻄﺗ

                    :ﻪﺑ ﺹﺎﺨﻟﺍ CSS ﻭﺃ JSONC ﺮﻴﻴﻐﺗ ﺪﻌﺑ ﻂﻘﻓ ﻡﺎﻬﻤﻟﺍ ﻂﻳﺮﺷ ﻞﻴﻐﺸﺗ ﺪﻋﺃ

```sh
argvus sessionctl restart waybar
```

                                        :ﻡﺪﺨﺘﺳﺍ ،ﻞﻣﺎﻜﻟﺎﺑ ﺩﺍﺪﻋﻹ﻿ﺍ/ﺔﺴﻠﺠﻟﺍ ﺓﺩﺎﻌﺘﺳﻻ﻿

```sh
argvus sessionctl reload
```

                  :ﺔﻳﺭﺎﺠﻟﺍ Waybar ﺔﻴﻠﻤﻋ ﻊﻗﺍﻮﻟﺍ ﻲﻓ ﺎﻬﻣﺪﺨﺘﺴﻳ ﻲﺘﻟﺍ ﺕﺎﻔﻠﻤﻟﺍ ﺔﻓﺮﻌﻤﻟ

```sh
pgrep -af 'waybar.*argvus-taskbar'
```

.ﻪﺜﻳﺪﺤﺗ ﻭ

:ﻡﺍﺪﺨﺘﺳﺎﺑ ﺕﻼ﻿ﺠﺴﻟﺍﻭ ﺔﻣﺪﺨﻟﺍ ﺺﺤﻓ ﻦﻜﻤﻳ

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```

.ﻡﺪﺨﺘﺴﻤﻟﺍ ﺕﺍﺭﺎﺴﻣﻭ

## ﻞﻤﻌﻟﺍ ﺔﺣﺎﺴﻣ ﻖﻓﺍﻮﺗ






## ﻖﻴﺒﻄﺘﻟﺍ ﻂﻳﺮﺷﻭ

                                                                          ﺮﻈﻧﺍ[                                                                   ﻡﺎﻬﻤﻟﺍ ﻂﻳﺮﺷ](/docs/argvus-taskbar/taskbar/)                                                       ﻭ ﻡﺪﺨﺘﺴﻤﻟﺍ ﺔﻬﺟﺍﻭ ﺕﺍﺰﻴﻤﻟ[                                                                 ﺕﺎﻔﻠﻤﻟﺍ ﻊﻗﺍﻮﻣ](/docs/reference/file-locations/)                                            .ﻡﺪﺨﺘﺴﻤﻟﺍ ﺕﺍﺭﺎﺴﻣﻭ ﺔﺘﺒﺜﻤﻟﺍ ﺕﺍﺭﺎﺴﻤﻠﻟ
