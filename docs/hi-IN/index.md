---
title: वेबारी और टास्कबार ओवरराइड्स
description: पैकेज्ड फाइलों को संपादित किए बिना ARGVUS वेबार टास्कबार को कस्टमाइज़ करें।
---

 provides the ARGVUS taskbar JSONC/CSS configuration and its helper scripts. 

 provides the Waybar binary, while 

 starts the service and selects the effective files. The managed copy and the generated copy are both written by 

: it replaces the theme layer and reapplies taskbar margins, 

 utility-group mode, border radius and the telemetry font block whenever themes or layout state change. 

 no longer writes these files; it only commits the change and asks for a reload.

## कॉन्फ़िगरेशन प्राथमिकता

टास्कबार और टेलीमेट्री सतह के लिए,  argvus-appearance  right-2  argvus-config  argvus-session  argvus-waybar  `argvus-taskbar`  `argvus-waybar`  `argvus-session`  `argvus-config`  `right-2`  `argvus-appearance` `argvus sessionctl` इस क्रम में कॉन्फ़िगरेशन और स्टाइलशीट को स्वतंत्र रूप से हल करता है:

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

`$XDG_CONFIG_HOME` को सेट किए जाने पर `~/.config` द्वारा बदला जाता है। पहला मौजूद फ़ाइल जीतता है।

जनित किया गया पेड़ **पहले** आता है इसलिए सक्रिय थीम लेयर हमेशा जीतती है: एक पुरानी उपयोगकर्ता या मूल प्रति को टास्कबार को पिछले थीम पर रखना नहीं चाहिए। इसका व्यावहारिक परिणाम यह है कि एक मूल `~/.config/waybar/` ओवरराइड केवल तब प्रभावी होता है जब संबंधित जनित फ़ाइल अनुपस्थित होती है — उदाहरण के लिए `rm -rf ~/.config/argvus/data/generated` के बाद अगले रीलोड से पहले, या जब कोई फ़ाइल कभी प्रोजेक्ट नहीं की गई हो। यदि आप एक टिकाऊ मूल ओवरराइड चाहते हैं जो थीम परिवर्तन को सहन करे, तो जनित पेड़ को प्रारंभिक बिंदु के रूप में उपयोग करें, या स्वीकार करें कि थीम लेयर के पास ये दो फ़ाइलें हैं।

कॉन्फ़िगरेशन मर्ज नहीं हुआ है: एक ओवरराइड JSONC फ़ाइल पूरी टास्कबार कॉन्फ़िगरेशन को बदल देती है, और एक ओवरराइड CSS फ़ाइल पूरी स्टाइलशीट को बदल देती है।

पैकेज किए गए डिफ़ॉल्ट केवल-पढ़ने योग्य इनपुट हैं। संपादित न करें:

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```

## संचालित ARGVUS कॉन्फ़िगरेशन

सामान्य ARGVUS सत्र में प्रबंधित प्रतियां का उपयोग किया जाता है:  के अंतर्गत

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```

`argvus-config` एक थीम लागू करते समय पैकेज किए गए डिफ़ॉल्ट्स से इन फ़ाइलों को फिर से बनाता है, फिर स्थायी ARGVUS स्थिति जैसे कि कार्यपट्टी मार्जिन, `right-2` यूटिलिटी-ग्रुप मोड, बॉर्डर रेडियस और फॉन्ट ब्लॉक को पुन: लागू करता है। `data/waybar/argvus-taskbar.{jsonc,css}` और `data/waybar/argvus-widget-telemetry.{jsonc,css}` के लिए भी यही सच है: इन्हें दिखावट में बदलाव होने पर पैकेज किए गए डिफ़ॉल्ट्स से पुनः प्रतिस्थापित किया जाता है, इसलिए वहाँ किए गए मैनुअल संपादन भी खो जाते हैं।

`~/.config/argvus/data/generated/waybar/` के तहत उत्पन्न फाइलें व्युत्पन्न स्थिति हैं और इन्हें सीधे संपादित नहीं किया जाना चाहिए; अगली argvus config apply में पूरी ट्री `config.json` से पुनर्निर्मित की जाती है।  `argvus config apply` `argvus --setup --copy taskbar` का उपयोग टास्कबार कस्टमाइज़ेशन पथ के रूप में न करें; टास्कबार रनर इसके सामान्य `data/taskbar/` स्थानों को ऊपर हल करता है।

## स्थायी JSONC कस्टमाइज़ेशन

एक मज़बूत मैनुअल टास्कबार कॉन्फ़िगरेशन के लिए, एक पूर्ण मूल Waybar ओवरराइड बनाएं:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```

`~/.config/waybar/` में कॉपी को संपादित करें। सामान्य बदलावों में शामिल हैं:

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

इस उदाहरण में Waybar संरचना को दर्शाया गया है; इसे अनुकूलित करते समय बाकी पैकेज की गई कॉन्फ़िगरेशन बनाए रखें। एक स्थानीय ओवरराइड एक पूर्ण फ़ाइल होती है, आंशिक JSONC खंड नहीं। यदि आप चाहते हैं कि मौजूदा टास्कबार क्रियाएँ काम करती रहें, तो ARGVUS डेस्कटॉप द्वारा आवश्यक मॉड्यूल और स्क्रिप्ट्स को संरक्षित करें।

## स्थायी CSS अनुकूलन

पैकेज्ड स्टाइलशीट अपने रंग सक्रिय थीम बिल्ड से इम्पोर्ट करता है। यदि आप CSS को ओवरराइड करते हैं, तो थीम इम्पोर्ट को बिल्ड की ओर इंगित करें, जिसका पथ थीम स्विच के दौरान समान रहता है:

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```

नेटीव CSS और थीम फाइलें उपयोगकर्ता-स्वामित्व वाली हो जाती हैं। थीम परिवर्तन उन्हें स्वचालित रूप से पुनः उत्पन्न नहीं करेगा; जब ARGVUS थीम एसेट्स जोड़ता या बदलता है, तब उन्हें जानबूझकर अपडेट करें।

## परिवर्तनों को लागू करें और प्रभावी फ़ाइल

का निरीक्षण करें। JSONC या CSS बदलने के बाद केवल टास्कबार को पुनः प्रारंभ करें:

```sh
argvus sessionctl restart waybar
```

। पूरी सत्र/कॉन्फ़िगरेशन ताज़ा करने के लिए उपयोग करें:

```sh
argvus sessionctl reload
```

। देखने के लिए कि चल रही Waybar प्रक्रिया वास्तव में किस फ़ाइल का उपयोग करती है:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```

सक्रिय JSONC फ़ाइल के लिए प्रक्रिया को `-c` और सक्रिय CSS फ़ाइल के लिए `-s` दिखाना चाहिए। यदि एक मूल फ़ाइल मौजूद है, तो प्रबंधित ARGVUS कॉपी में किए गए परिवर्तन सक्रिय टास्कबार को नहीं बदलेंगे जब तक कि मूल फ़ाइल को हटा दिया न जाए या अपडेट न किया जाए।

सेवा और लॉग्स की जांच इस प्रकार की जा सकती है:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```

उपयोगकर्ता-आधारित सुविधाओं के लिए [टास्कबार](/docs/argvus-taskbar/taskbar/) देखें और स्थापित और उपयोगकर्ता पथों के लिए [फ़ाइल स्थान](/docs/reference/file-locations/) देखें।

## Hyprland वर्कस्पेस संगतता

ARGVUS बिल्ड दोनों, परंपरागत संख्यात्मक कार्यक्षेत्र आईडी और Hyprland 0.57 पाठ्य कार्यक्षेत्र पतों को स्वीकार करता है। `id` के बिना नामित कार्यक्षेत्र स्थिर रूप से कार्यक्षेत्र स्नैपशॉट, क्लाइंट, मॉनीटर और घटनाओं के माध्यम से प्रोसेस-स्थानीय आंतरिक पहचानकर्ताओं को प्राप्त करते हैं। ये पहचानकर्ता कभी भी Hyprland को नहीं भेजे जाते: कार्यक्षेत्र बटन असली नाम प्रेषित करते हैं।

 optionally names a JSON file relative to 

, such as 

. Each workspace name maps to an object with 

 and 

 strings. Labels are escaped as Pango text and do not change matching or click targets. Missing metadata falls back to native workspace names. 

 owns the derived project metadata; reopen a project after list/language changes to refresh it.


## विंडो बटन और एप्लिकेशन बार

हर मॉनिटर पर दूसरी वेबॉर दिखती है, मुख्य टास्कबार के विपरीत किनारे पर। यह केवल उस मॉनिटर के वर्तमान कार्यक्षेत्र की विंडोज़ को सूचीबद्ध करती है, जिसमें उस कार्यक्षेत्र की न्यूनतम विंडोज़ भी शामिल हैं। कोई खुला विशेष कार्यक्षेत्र प्राथमिकता प्राप्त करता है। पिन की गई विंडोज़ दिखाई देती रहती हैं; छिपे हुए समूह टैब अतिरिक्त प्रविष्टियां नहीं बनाते, और एक न्यूनतम समूह में एक रिकवरी प्रविष्टि होती है। किसी एप्लिकेशन के अंदर के टैब अलग से सूचीबद्ध नहीं किए जाते। न्यूनतम प्रविष्टियां अपने मूल मॉनिटर/कार्यक्षेत्र संबंध को बनाए रखती हैं। किसी निष्क्रिय विंडो पर क्लिक करने से वह सक्रिय हो जाती है, किसी सक्रिय विंडो पर क्लिक करने से वह न्यूनतम हो जाती है, या किसी न्यूनतम विंडो पर क्लिक करने से वह पुनर्स्थापित होती है; इसका संदर्भ मेनू पुनर्स्थापित, न्यूनतम, अधिकतम/पुनर्स्थापित और बंद करने के विकल्प प्रदान करता है। अज्ञात एप्लिकेशन आइकॉन विंडो प्रतीक पर लौटता है।

 argvus projects  tooltip  label  argvus/project-workspaces.json  $XDG_RUNTIME_DIR  `hyprland/workspaces.workspace-metadata`  `$XDG_RUNTIME_DIR`  `argvus/project-workspaces.json`  `label`  `tooltip`  `argvus projects` `hyprland/argvus-windows` मॉड्यूल `argvus windows watch --json` से JSON स्ट्रीम का उपयोग करता है। GTK अपडेट मुख्य थ्रेड पर चलते हैं; क्रियाएं तर्क सरणियों और मान्य विंडो पतों का उपयोग करती हैं। रिकवरी तत्परता कंपोज़िटर लेयर सूची के खिलाफ पुष्टि की जाती है।
