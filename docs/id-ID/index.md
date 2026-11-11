---
title: Override Waybar dan taskbar
description: Sesuaikan taskbar ARGVUS Waybar tanpa mengedit file yang dikemas.
---

`argvus-taskbar` menyediakan konfigurasi JSONC/CSS taskbar ARGVUS beserta skrip pembantunya. `argvus-waybar` menyediakan berkas biner Waybar, sedangkan `argvus-session` memulai layanan dan memilih berkas yang efektif. Salinan yang dikelola dan salinan yang dihasilkan keduanya ditulis oleh `argvus-config`: ia mengganti lapisan tema dan menerapkan kembali margin taskbar, mode grup utilitas `right-2`, radius border, dan blok font telemetry setiap kali tema atau keadaan tata letak berubah. `argvus-appearance` tidak lagi menulis berkas-berkas ini; ia hanya melakukan komit perubahan dan meminta pemuatan ulang.

## Prioritas konfigurasi

Untuk bilah tugas dan permukaan telemetri, `argvus sessionctl` menyelesaikan konfigurasi dan lembar gaya secara independen dalam urutan ini:

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

`$XDG_CONFIG_HOME` menggantikan `~/.config` saat diatur. File pertama yang ada menang.

Pohon yang dihasilkan muncul **pertama** sehingga lapisan tema aktif selalu menang: salinan pengguna yang usang atau salinan asli tidak boleh mempertahankan bilah tugas pada tema sebelumnya. Konsekuensi praktisnya adalah bahwa penggantian `~/.config/waybar/` asli hanya berlaku sementara file yang dihasilkan yang sesuai tidak ada — misalnya setelah `rm -rf ~/.config/argvus/data/generated` sebelum muat ulang berikutnya, atau ketika sebuah file tidak pernah diproyeksikan. Jika Anda menginginkan penggantian asli yang tahan lama yang bertahan melalui perubahan tema, gunakan pohon yang dihasilkan sebagai titik awal, atau terimalah bahwa lapisan tema yang memiliki kedua file ini.

Konfigurasi tidak digabungkan: file JSONC override menggantikan seluruh konfigurasi taskbar, dan file CSS override menggantikan seluruh stylesheet.

Default yang dikemas adalah input hanya-baca. Jangan diedit:

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```

## Konfigurasi ARGVUS yang dikelola

Sesi ARGVUS normal menggunakan salinan yang dikelola di bawah:

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```

`argvus-config` membuat ulang file-file ini dari default yang dikemas saat menerapkan tema, kemudian menerapkan kembali status ARGVUS yang persisten seperti margin taskbar, mode grup utilitas `right-2`, radius batas, dan blok font. Hal yang sama berlaku untuk `data/waybar/argvus-taskbar.{jsonc,css}` dan `data/waybar/argvus-widget-telemetry.{jsonc,css}`: mereka diganti dari default yang dikemas saat terjadi perubahan tampilan, sehingga pengeditan manual di sana juga hilang.

File yang dihasilkan di bawah `~/.config/argvus/data/generated/waybar/` adalah status turunan dan tidak boleh diedit langsung; seluruh pohon dibangun kembali dari `config.json` pada `argvus config apply` berikutnya. Jangan menggunakan `argvus --setup --copy taskbar` sebagai jalur kustomisasi taskbar; runner taskbar menyelesaikan lokasi `data/taskbar/` kanoniknya di atas.

## Kustomisasi JSONC Persisten

Untuk konfigurasi taskbar manual yang tahan lama, buat override Waybar native lengkap:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```

Edit salinan di `~/.config/waybar/`. Perubahan umum termasuk:

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

Contoh ini menggambarkan struktur Waybar; pertahankan konfigurasi paket lainnya saat menyesuaikannya. Override asli adalah file lengkap, bukan fragmen JSONC sebagian. Pertahankan modul dan skrip yang diperlukan oleh desktop ARGVUS jika Anda ingin tindakan taskbar yang ada tetap berfungsi.

## Kustomisasi CSS persisten

Stylesheet yang dikemas mengimpor warnanya dari build tema aktif. Jika Anda menimpa CSS, arahkan impor tema ke build, yang jalurnya tetap sama saat pergantian tema:

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```

File CSS dan tema asli menjadi milik pengguna. Perubahan tema tidak akan menghasilkannya kembali secara otomatis; perbarui secara sengaja ketika ARGVUS menambahkan atau mengubah aset tema.

## Terapkan perubahan dan periksa file efektif

Restart hanya taskbar setelah mengubah JSONC atau CSS-nya:

```sh
argvus sessionctl restart waybar
```

Untuk penyegaran sesi/konfigurasi lengkap, gunakan:

```sh
argvus sessionctl reload
```

Untuk melihat file mana yang sebenarnya digunakan oleh proses Waybar yang berjalan:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```

Proses harus menampilkan `-c` untuk file JSONC yang berlaku dan `-s` untuk file CSS yang berlaku. Jika file asli ada, perubahan pada salinan ARGVUS yang dikelola tidak akan mengubah taskbar aktif sampai file asli dihapus atau diperbarui.

Layanan dan log dapat diperiksa dengan:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```

Lihat [Taskbar](/docs/argvus-taskbar/taskbar/) untuk fitur yang terlihat oleh pengguna dan [lokasi file](/docs/reference/file-locations/) untuk jalur terpasang dan pengguna.

## kompatibilitas workspace Hyprland

Build ARGVUS menerima baik ID workspace numerik lama maupun alamat workspace tekstual Hyprland 0.57. Workspace bernama tanpa `id` menerima identifier internal lokal-proses secara konsisten di seluruh snapshot workspace, klien, monitor, dan event. Identifier ini tidak pernah dikirim ke Hyprland: tombol workspace mengirimkan nama aslinya.

`hyprland/workspaces.workspace-metadata` secara opsional menamai file JSON relatif terhadap `$XDG_RUNTIME_DIR`, seperti `argvus/project-workspaces.json`. Setiap nama ruang kerja dipetakan ke objek dengan string `label` dan `tooltip`. Label di-escape sebagai teks Pango dan tidak mengubah pencocokan atau target klik. Metadata yang hilang kembali ke nama ruang kerja asli. `argvus projects` memiliki metadata proyek yang diturunkan; buka kembali proyek setelah perubahan daftar/bahasa untuk menyegarkannya.


## Tombol jendela dan bilah aplikasi

Sebuah Waybar kedua muncul di setiap monitor, di tepi yang berlawanan dengan taskbar utama. Waybar ini hanya menampilkan jendela-jendela yang termasuk dalam workspace saat ini di monitor tersebut, termasuk jendela yang diminimalkan dari workspace itu. Workspace khusus yang terbuka memiliki prioritas. Jendela yang disematkan tetap terlihat; tab grup yang disembunyikan tidak membuat entri tambahan, dan grup yang diminimalkan memiliki satu entri pemulihan. Tab di dalam sebuah aplikasi tidak dihitung secara terpisah. Entri yang diminimalkan tetap mempertahankan asosiasi monitor/workspace aslinya. Klik jendela yang tidak aktif untuk mengaktifkannya, jendela yang aktif untuk meminimalkannya, atau jendela yang diminimalkan untuk mengembalikannya; menu konteksnya menawarkan opsi pulihkan, minimalkan, maksimalkan/pulihkan, dan tutup. Ikon aplikasi yang tidak dikenal kembali ke simbol jendela.

Modul `hyprland/argvus-windows` mengonsumsi aliran JSON dari `argvus windows watch --json`. Pembaruan GTK berjalan di thread utama; tindakan menggunakan array argumen dan alamat jendela yang telah divalidasi. Kesiapan pemulihan dikonfirmasi terhadap daftar lapisan kompositor.
