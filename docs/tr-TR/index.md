---
title: Waybar ve görev çubuğu geçersiz kılmaları
description: Paketlenmiş dosyaları düzenlemeden ARGVUS Waybar görev çubuğunu özelleştirin.
---

`argvus-taskbar` ARGVUS görev çubuğu JSONC/CSS yapılandırmasını ve yardımcı betiklerini sağlar. `argvus-waybar` Waybar ikili dosyasını sağlar, `argvus-session` ise servisi başlatır ve geçerli dosyaları seçer. Yönetilen kopya ve üretilen kopya her ikisi de `argvus-config` tarafından yazılır: tema katmanını değiştirir ve görev çubuğu kenar boşluklarını yeniden uygular, `right-2` yardımcı program-grup modunu, kenar yarıçapını ve tema veya düzen durumu değiştiğinde telemetri yazı tipi bloğunu uygular. `argvus-appearance` artık bu dosyaları yazmaz; sadece değişikliği kaydeder ve yeniden yükleme ister.

## Yapılandırma önceliği

Görev çubuğu ve telemetri yüzeyi için, `argvus sessionctl` yapılandırmayı ve stil dosyasını bağımsız olarak bu sırayla çözer:

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

`$XDG_CONFIG_HOME` ayarlandığında `~/.config` ile değiştirilir. Mevcut ilk dosya kazanır.

Oluşturulan ağaç **önce** gelir, bu nedenle aktif tema katmanı her zaman kazanır: eski bir kullanıcı veya yerel kopya görev çubuğunu önceki temada tutmamalıdır. Pratik sonuç olarak, bir yerel `~/.config/waybar/` geçersiz kılma yalnızca ilgili oluşturulmuş dosya mevcut olmadığında etkili olur — örneğin `rm -rf ~/.config/argvus/data/generated`'dan sonra bir sonraki yeniden yüklemeye kadar veya bir dosya hiç projelendirilmediyse. Tema değişikliklerinden etkilenmeyen kalıcı bir yerel geçersiz kılma istiyorsanız, başlatma noktası olarak oluşturulan ağacı kullanın veya tema katmanının bu iki dosyanın sahibi olduğunu kabul edin.

Yapılandırma birleştirilmez: bir geçersiz kılma JSONC dosyası tüm görev çubuğu yapılandırmasını değiştirir ve bir geçersiz kılma CSS dosyası tüm stil dosyasını değiştirir.

Paketlenmiş varsayılanlar salt okunur girişlerdir. Düzenlemeyin:

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```

## Yönetilen ARGVUS yapılandırması

Normal ARGVUS oturumu, yönetilen kopyaları altında kullanır:

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```

`argvus-config`, bir temayı uygularken bu dosyaları paketlenmiş varsayılanlardan yeniden oluşturur, ardından görev çubuğu kenar boşlukları, `right-2` yardımcı program grubu modu, kenar yarıçapı ve yazı tipi bloğu gibi kalıcı ARGVUS durumunu yeniden uygular. `data/waybar/argvus-taskbar.{jsonc,css}` ve `data/waybar/argvus-widget-telemetry.{jsonc,css}` için de durum aynıdır: görünüm değiştiğinde paketlenmiş varsayılanlardan değiştirilirler, dolayısıyla oradaki elle yapılan düzenlemeler de kaybolur.

`~/.config/argvus/data/generated/waybar/` altında oluşturulan dosyalar türetilmiş durumdadır ve doğrudan düzenlenmemelidir; tüm ağaç bir sonraki argvus config apply sırasında `config.json`'den yeniden oluşturulur.  `argvus config apply` `argvus --setup --copy taskbar`'yu görev çubuğu özelleştirme yolu olarak kullanmayın; görev çubuğu çalıştırıcısı üstteki kanonik `data/taskbar/` konumlarını çözer.

## Kalıcı JSONC özelleştirmesi

Dayanıklı bir elle görev çubuğu yapılandırması için, tam bir yerel Waybar geçersiz kılma oluşturun:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```

`~/.config/waybar/` içindeki kopyayı düzenleyin. Yaygın değişiklikler şunları içerir:

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

Örnek, Waybar yapısını gösterir; özelleştirirken paketlenmiş konfigürasyonun geri kalanını koruyun. Yerel geçersiz kılma, kısmi bir JSONC parçası değil, tam bir dosyadır. Mevcut görev çubuğu eylemlerinin çalışmaya devam etmesini istiyorsanız ARGVUS masaüstü için gerekli modülleri ve betikleri koruyun.

## Kalıcı CSS özelleştirmesi

Paketlenmiş stil sayfası renklerini aktif tema yapımından alır. CSS'i geçersiz kılarsanız, tema ithalatını yapıya yönlendirin; yolu tema değişikliklerinde aynı kalır:

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```

Yerel CSS ve tema dosyaları kullanıcı tarafından sahip olunur. Tema değişiklikleri bunları otomatik olarak yeniden üretmez; ARGVUS tema varlıklarını eklediğinde veya değiştirdiğinde bunları kasıtlı olarak güncelleyin.

## Değişiklikleri uygulayın ve etkin dosyayı inceleyin

JSONC veya CSS'yi değiştirdikten sonra yalnızca görev çubuğunu yeniden başlatın:

```sh
argvus sessionctl restart waybar
```

Tam bir oturum/konfigürasyon yenilemesi için kullanın:

```sh
argvus sessionctl reload
```

Çalışan Waybar sürecinin hangi dosyaları gerçekten kullandığını görmek için:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```

İşlem, geçerli JSONC dosyası için `-c` ve geçerli CSS dosyası için `-s` göstermelidir. Eğer bir yerel dosya mevcutsa, yönetilen ARGVUS kopyasında yapılan değişiklikler, yerel dosya kaldırılana veya güncellenene kadar aktif görev çubuğunu değiştirmeyecektir.

Hizmet ve günlükler şu şekilde incelenebilir:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```

Kullanıcıya yönelik özellikler için [Görev Çubuğu](/docs/argvus-taskbar/taskbar/) ve kurulu ve kullanıcı yolları için [dosya konumları](/docs/reference/file-locations/) bölümüne bakın.

## Hyprland çalışma alanı uyumluluğu

ARGVUS yapısı hem eski sayısal çalışma alanı kimliklerini hem de Hyprland 0.57 metin tabanlı çalışma alanı adreslerini kabul eder. `id` olmadan adlandırılmış çalışma alanları, çalışma alanı anlık görüntüleri, istemciler, monitörler ve olaylar arasında işlem yerel dahili kimlikleri tutarlı bir şekilde alır. Bu kimlikler hiçbiryere Hyprland'e gönderilmez: çalışma alanı düğmeleri gerçek adı gönderir.

`hyprland/workspaces.workspace-metadata`, `$XDG_RUNTIME_DIR`'ye göre isteğe bağlı olarak bir JSON dosyası adını belirler, örneğin `argvus/project-workspaces.json`. Her çalışma alanı adı, `label` ve `tooltip` dizelerini içeren bir nesne ile eşlenir. Etiketler Pango metni olarak kaçış yapılır ve eşleme veya tıklama hedeflerini değiştirmez. Eksik meta veriler, yerel çalışma alanı adlarına geri döner. `argvus projects` türetilmiş proje meta verilerinin sahibidir; liste/dil değişikliklerinden sonra projeyi yeniden açarak bunu yenileyin.


## Pencere düğmeleri ve uygulama çubuğu

İkinci bir Waybar her monitörde, ana görev çubuğunun karşı kenarında görünür. Sadece o monitörün mevcut çalışma alanına ait pencereleri listeler; bu listeye o çalışma alanındaki simge durumuna küçültülmüş pencereler de dahildir. Açık olan özel bir çalışma alanı önceliklidir. Sabitlenmiş pencereler görünür kalır; gizli grup sekmeleri ek bir kayıt oluşturmaz ve simge durumuna küçültülmüş bir grubun bir geri getirme kaydı olur. Bir uygulama içindeki sekmeler ayrı ayrı listelenmez. Simge durumuna küçültülmüş öğeler orijinal monitör/çalışma alanı ilişkisini korur. Etkin olmayan bir pencereye tıklarsanız etkinleştirirsiniz, etkin bir pencereye tıklarsanız simge durumuna küçültürsünüz veya simge durumuna küçültülmüş bir pencereye tıklarsanız geri yüklersiniz; bağlam menüsü geri yükle, simge durumuna küçült, büyüt/görüntüle ve kapat seçeneklerini sunar. Bilinmeyen uygulama simgeleri bir pencere simgesiyle gösterilir.

`hyprland/argvus-windows` modülü, `argvus windows watch --json`'den bir JSON akışı tüketir. GTK güncellemeleri ana iş parçacığında çalışır; eylemler, argüman dizilerini ve doğrulanmış pencere adreslerini kullanır. Kurtarma hazırılığı, kompozitör katman listesine karşı doğrulanır.
