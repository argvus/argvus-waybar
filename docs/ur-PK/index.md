---
title:                                                ﺯﮉﯿﺋﺍﺭ ﺭﻭﻭﺍ ﺭﺎﺑ ﮏﺳﺎﭨ ﺭﻭﺍ ﺭﺎﺑ ﮮﻭ
description: پیک فائلوں میں ترمیم کیے بغیر ARGVUS Waybar ٹاسک بار کو حسب ضرورت بنائیں۔
---

`argvus-taskbar`ARGVUS ﺭﺎﺑ ﮏﺳﺎﭨ JSONC/CSS ۔ﮯﮨ ﺎﺗﺮﮐ ﻢﮨﺍﺮﻓ ﺲﭩﭘﺮﮑﺳﺍ ﻥﻭﺎﻌﻣ ﮯﮐ ﺱﺍ ﺭﻭﺍ ﻦﺸﯾﺮﮕﯿﻔﻨﮐ`argvus-waybar` provides the Waybar binary, while `argvus-session` starts the service and selects the effective files. The managed copy and the generated copy are both written by `argvus-config`: it replaces the theme layer and reapplies taskbar margins, `right-2` utility-group mode, border radius and the telemetry font block whenever themes or layout state change. `argvus-appearance` no longer writes these files; it only commits the change and asks for a reload.

##                                                                 ﺖﯿﻗﻮﻓ ﯽﮐ ﺐﯿﺗﺮﺗ

                                           ،ﮯﯿﻟ ﮯﮐ ﺢﻄﺳ ﯼﺮﭩﯿﻣ ﯽﻠﯿﭨ ﺭﻭﺍ ﺭﺎﺑ ﮏﺳﺎﭨ`argvus sessionctl`               :ﮯﮨ ﺎﺗﺮﮐ ﻞﺣ ﺮﭘ ﺭﻮﻃ ﮧﻧﺍﺩﺍﺯﺁ ﮟﯿﻣ ﺐﯿﺗﺮﺗ ﺱﺍ ﻮﮐ ﭧﯿﺷ ﻞﺋﺎﭩﺳﺍ ﺭﻭﺍ ﺐﯿﺗﺮﺗ

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

۔ﮯﮨ ﺎﺘﺘﯿﺟ ﻞﺋﺎﻓ ﮦﺩﻮﺟﻮﻣ ﻼ﻿ﮩﭘ ۔ﮯﮨ ﺎﺘﯿﻟ ﮧﮕﺟ ﯽﮐ `$XDG_CONFIG_HOME`، `~/.config`



۔ﮯﮨ ﯽﺘﯾﺩ ﺮﮐ ﻞﯾﺪﺒﺗ ﻮﮐ ﭧﯿﺷ ﻞﺋﺎﭩﺳﺍ ﻞﻤﮑﻣ ﻞﺋﺎﻓ CSS ﮉﯿﺋﺍﺭﺭﻭﻭﺍ ﮏﯾﺍ ﺭﻭﺍ ،ﮯﮨ ﯽﺘﯾﺩ ﺮﮐ ﻞﯾ

                  :ﮟﯾﺮﮐ ﮧﻧ ﻢﯿﻣﺮﺗ ۔ﮟﯿﮨ ﭧﭘ ﻥﺍ ﮯﯿﻟ ﮯﮐ ﮯﻨﮬﮍﭘ ﻑﺮﺻ ﺲﭩﻟﺎﻔﯾﮈ ﮦﺪﺷ ﺞﯿﮑﯿﭘ

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```

##                                                      ﻦﺸﯾﺮﮕﯿﻔﻨﮐ ARGVUS ﮦﺪﺷ ﻢﻈﻨﻣ

           :ﮯﮨ ﺎﺗﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ ﻝﻮﻘﻧ ﮦﺪﺷ ﺞﯿﻨﯿﻣ ﺖﺤﺗ ﮯﮐ ﻞﯾﺫ ﮧﺟﺭﺪﻨﻣ ﻦﺸﯿﺳ ARGVUS ﻞﻣﺭﺎﻧ

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```

 rm -rf ~/.config/argvus/data/generated  `~/.config/waybar/`  `rm -rf ~/.config/argvus/data/generated` `argvus-config` recreates these files from the packaged defaults when applying a theme, then reapplies persistent ARGVUS state such as taskbar margins, the `right-2` utility-group mode, border radius and the font block. The same is true of `data/waybar/argvus-taskbar.{jsonc,css}` and `data/waybar/argvus-widget-telemetry.{jsonc,css}`۔ﮟﯿﮨ ﯽﺗﺎﺟ ﻮﮨ ﻊﺋﺎﺿ ﯽﮭﺑ ﺕﺎﻤﯿﻣﺮﺗ ﯽﺘﺳﺩ ﯽﮐ ﮞﺎﮨﻭ ﮯﯿﻟ ﺱﺍ ،ﮟﯿﮨ ﮯﺗﺎﺟ ﮯﯾﺩ ﻝﺪﺑ ﮯﺳ ﺲﭩﻟﺎﻔﯾﮈ

Generated files under `~/.config/argvus/data/generated/waybar/` are derived state and should not be edited directly; the whole tree is rebuilt from `config.json` on the next `argvus config apply`. Do not use `argvus --setup --copy taskbar`       ﮯﮨ ﺎﺗﺮﮐ ﻞﺣ ﻮﮐ ﻞﺣ ﯼﺭﺎﯿﻌﻣ ﮯﻨﭘﺍ ﺮﻧﺭ ﺭﺎﺑ ﮏﺳﺎﭨ ؛ﮧﺘﺳﺍﺭ ﺎﮐ ﺺﯿﺼﺨﺗ ﺭﺎﺑ ﮏﺳﺎﭨ ﺭﻮﻄﺑ`data/taskbar/` locations above.

##                                                          ﺕﺭﻭﺮﺿ ﺐﺴﺣ JSONC ﻞﻘﺘﺴﻣ

:ﮟﯿﺋﺎﻨﺑ ﮉﯿﺋﺍﺭ ﺭﻭﻭﺍ ﺭﺎﺑ ﮮﻭ ﯽﻣﺎﻘﻣ ﻞﻤﮑﻣ ،ﮯﯿﻟ ﮯﮐ ﻦﺸﯾﺮﮕﯿﻔﻨﮐ ﺭﺎﺑ ﮏﺳﺎﭨ ﯽﺘﺳﺩ ﺭﺍﺪﯿﺋﺎﭘ ﮏ

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```

`~/.config/waybar/` ﮟﯿﮨ ﻞﻣﺎﺷ ﮟﯿﻣ ﮞﻮﯿﻠﯾﺪﺒﺗ ﻡﺎﻋ ۔ﮟﯾﺮﮐ ﻢﯿﻣﺮﺗ ﮟﯿﻣ ﯽﭘﺎﮐ ﮟﯿﻣ:

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

۔ﮟﯿﮭﮐﺭ ﻅﻮﻔﺤﻣ ﻮﮐ ﺲﭩﭘﺮﮑﺳﺍ

## ﺕﺭﻭﺮﺿ ﺐﺴﺣ CSS ﻞﻘﺘﺴﻣ

:ﮯﮨ ﺎﺘﮨﺭ ﺎﺴﯿﺟ ﮏﯾﺍ ﻥﺍﺭﻭﺩ ﮯﮐ ﺰﭽﺋﻮﺳ ﻢﯿﮭﺗ ﮧﺘﺳﺍﺭ ﺎﮐ ﺲﺟ ،ﮟﯾﺮﮐ ﮦﺭﺎﺷﺍ ﻑﺮﻃ ﯽﮐ ﮉﻠﺑ ﻮﮐ ﭦﺭ

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```

۔ﮟﯾﺮﮐ ﭧﯾﮈ ﭖﺍ ﺮﭘ ﺭﻮﻃ ﯼﺭﻮﻌﺷ ﮟﯿﮩﻧﺍ ﻮﺗ ﮮﺮﮐ ﻞﯾﺪﺒﺗ ﺎﯾ ﮮﺮﮐ ﻞﻣﺎﺷ ﮯﺛﺎﺛﺍ ﻢﯿﮭﺗ ARGVUS ﺐﺟ

##                                 ﮟﯾﺮﮐ ﮧﻨﺋﺎﻌﻣ ﺎﮐ ﻞﺋﺎﻓ ﺮﺛﺆﻣ ﺭﻭﺍ ﮟﯾﺮﮐ ﻮﮔﻻ﻿ ﮞﺎﯿﻠﯾﺪﺒﺗ

        :ﮟﯾﺮﮐ ﻉﻭﺮﺷ ﮦﺭﺎﺑﻭﺩ ﻮﮐ ﺭﺎﺑ ﮏﺳﺎﭨ ﻑﺮﺻ ﺪﻌﺑ ﮯﮐ ﮯﻧﺮﮐ ﻞﯾﺪﺒﺗ CSS ﺎﯾ JSONC ﺎﮐ ﺱﺍ

```sh
argvus sessionctl restart waybar
```

                            :ﮟﯾﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ ،ﮯﯿﻟ ﮯﮐ ﮯﻧﺮﮐ ﮦﺯﺎﺗ ﻮﮐ ﺐﯿﺗﺮﺗ/ﻦﺸﯿﺳ ﻞﻤﮑﻣ

```sh
argvus sessionctl reload
```

     :ﮯﮨ ﺎﺗﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ ﮟﯿﻠﺋﺎﻓ ﯽﺴﻧﻮﮐ ﻞﺻﺍﺭﺩ ﻞﻤﻋ Waybar ﺎﮨﺭ ﻞﭼ ﮧﮐ ﮯﯿﻟ ﮯﮐ ﮯﻨﮭﮑﯾﺩ ﮧﯾ

```sh
pgrep -af 'waybar.*argvus-taskbar'
```

۔ﮯﺋﺎﺟ

:ﮯﮨ ﺎﺘﮑﺳ ﺎﺟ ﺎﯿﮐ ﮧﻨﺋﺎﻌﻣ ﺎﮐ ﺰﮔﻻ﻿ ﺭﻭﺍ ﺱﻭﺮﺳ

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```

۔ﮟﯿﮭﮑﯾﺩ (ZXQMA

## ﺖﻘﺑﺎﻄﻣ ﯽﮐ ﺲﯿﭙﺳﺍ ﮎﺭﻭ ﮉﻨﯿﻟﺮﭙﺋﺎﮨ

ARGVUS بلڈ لیگیسی عددی ورک اسپیس IDs اور Hyprland 0.57 متنی ورک اسپیس ایڈریس دونوں کو قبول کرتی ہے۔ نام شدہ ورک اسپیسز بغیر -s `-c` `-s` `id` ورک اسپیس اسنیپ شاٹس، کلائنٹس، مانیٹرس اور ایونٹس میں مستقل طور پر پروسیس لوکل اندرونی شناخت کار حاصل کرتے ہیں۔ یہ شناخت کنندگان کبھی بھی Hyprland پر نہیں بھیجے جاتے: ورک اسپیس بٹن اصل نام بھیجتے ہیں۔

`hyprland/workspaces.workspace-metadata` optionally names a JSON file relative to `$XDG_RUNTIME_DIR`, such as `argvus/project-workspaces.json`. Each workspace name maps to an object with `label` and `tooltip`۔ﮟﯿﮨ ﮯﺗﺎﺟ ﮯﯿﮐ ﻝﺎﻤﻌﺘﺳﺍ ﻡﺎﻧ ﮯﮐ ﺲﯿﭙﺳﺍ ﮎﺭﻭ ﯽﻣﺎﻘﻣ ﮯﯿﻟ ﮯﮐ ﺎﭩﯾﮈ ﺎﭩﯿﻣ ﺐﺋﺎﻏ ۔ﮯﺗﺮﮐ ﮟﯿﮩﻧ `argvus projects` owns the derived project metadata; reopen a project after list/language changes to refresh it.


## ﺭﺎﺑ ﯽﮐ ﺖﺳﺍﻮﺧﺭﺩ ﺭﻭﺍ ﻦﭩﺑ ﻭﮉﻧﻭ



`hyprland/argvus-windows` ﻝﻮﯾﮈﺎﻣ، `argvus windows watch --json` ﮯﺳ JSON ۔ﮯﮨ ﺎﺗﺮﮐ ﻝﺎﻤﻌﺘﺳﺍ ﻢﯾﺮﭩﺳﺍ GT

                                                                        ﮟﯿﮭﮑﯾﺩ[                                                                      ﺭﺎﺑ ﮏﺳﺎﭨ](/docs/argvus-taskbar/taskbar/)                                     ﺭﻭﺍ ﮯﯿﻟ ﮯﮐ ﺕﺎﯿﺻﻮﺼﺧ ﯽﻟﺍﻭ ﮯﻧﺁ ﮯﻨﻣﺎﺳ ﮯﮐ ﻑﺭﺎﺻ[                                                                 ﮟﯿﮩﮕﺟ ﯽﮐ ﻞﺋﺎﻓ](/docs/reference/file-locations/)                                         ۔ﮯﯿﻟ ﮯﮐ ﮞﻮﺘﺳﺍﺭ ﮯﮐ ﻑﺭﺎﺻ ﺭﻭﺍ ﮦﺪﺷ ﻝﺎﭩﺴﻧﺍ
