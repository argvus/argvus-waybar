---
title:                                                    ﻡﺎﻬﻤﻟﺍ ﻂﻳﺮﺷﻭ Waybar ﺕﺍﺯﻭﺎﺠﺗ
description: قم بتخصيص شريط مهام ARGVUS Waybar دون تحرير الملفات المجمعة.
---

 يوفر تكوين شريط المهام ARGVUS JSONC/CSS والبرامج النصية المساعدة الخاصة به.

 provides the Waybar binary, while

يبدأ الخدمة ويختار الملفات الفعالة. تتم كتابة النسخة المُدارة والنسخة التي تم إنشاؤها بواسطة

: يستبدل طبقة السمة ويعيد تطبيق هوامش شريط المهام،

 وضع مجموعة الأدوات المساعدة، ونصف قطر الحدود، وكتلة خط القياس عن بعد عندما تتغير السمات أو حالة التخطيط.

 لم يعد يكتب هذه الملفات. إنه ينفذ التغيير فقط ويطلب إعادة التحميل.

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

يقوم argvus-config بإعادة إنشاء هذه الملفات من الإعدادات الافتراضية المجمعة عند تطبيق سمة، ثم يعيد تطبيق حالة ARGVUS المستمرة مثل هوامش شريط المهام، ووضع مجموعة الأدوات المساعدة اليمنى-2، ونصف قطر الحدود وكتلة الخط. وينطبق الشيء نفسه على data/waybar/argvus-taskbar.{jsonc,css} وdata/waybar/argvus-widget-telemetry.{jsonc,css}: يتم استبدالهما من الإعدادات الافتراضية المجمعة عند تغيير المظهر، لذلك يتم فقدان التعديلات اليدوية هناك أيضًا.

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
