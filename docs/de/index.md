---
title: Waybar- und Taskleiste-Overrides
description: Passen Sie die ARGVUS Waybar-Taskleiste an, ohne verpackte Dateien zu bearbeiten.
---
`argvus-taskbar` stellt die ARGVUS-Taskleiste JSONC/CSS-Konfiguration und deren Hilfsskripte bereit. `argvus-waybar` stellt das Waybar-Binary bereit, während `argvus-session` den Dienst startet und die effektiven Dateien auswählt. Die verwaltete Kopie und die generierte Kopie werden beide von `argvus-config` geschrieben: Es ersetzt die Themenebene und wendet die Taskleistenränder erneut an, `right-2` Utility-Gruppenmodus, Rahmenradius und den Telemetrie-Schriftblock, wann immer sich Themen oder Layoutzustand ändern. `argvus-appearance` schreibt diese Dateien nicht mehr; es führt nur die Änderung durch und fordert einen Reload an.

## Konfigurationspräzedenz

Für die Taskleiste und die Telemetrie-Oberfläche löst `argvus sessionctl` die Konfiguration und das Stylesheet unabhängig in folgender Reihenfolge:

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
`$XDG_CONFIG_HOME` ersetzt `~/.config`, wenn es gesetzt ist. Die erste vorhandene Datei gewinnt.

Der generierte Baum kommt **zuerst**, sodass die aktive Theme-Ebene immer gewinnt: Eine veraltete Benutzer- oder native Kopie darf die Taskleiste des vorherigen Themes nicht beibehalten. Die praktische Konsequenz ist, dass eine native `~/.config/waybar/`-Überschreibung nur dann wirksam wird, wenn die entsprechende generierte Datei fehlt – zum Beispiel nach `rm -rf ~/.config/argvus/data/generated` vor dem nächsten Laden oder wenn eine Datei niemals projiziert wurde. Wenn Sie eine dauerhafte native Überschreibung wünschen, die Theme-Änderungen übersteht, verwenden Sie den generierten Baum als Ausgangspunkt oder akzeptieren Sie, dass die Theme-Ebene diese beiden Dateien kontrolliert.

Die Konfiguration wird nicht zusammengeführt: Eine JSONC-Überschreibungsdatei ersetzt die komplette Taskleisten-Konfiguration, und eine CSS-Überschreibungsdatei ersetzt das komplette Stylesheet.

Die voreingestellten Pakete sind schreibgeschützte Eingaben. Bitte nicht bearbeiten:

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```
## Verwaltete ARGVUS-Konfiguration

Die normale ARGVUS-Sitzung verwendet die verwalteten Kopien unter:

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```
`argvus-config` stellt diese Dateien aus den standardmäßig mitgelieferten Paketen wieder her, wenn ein Thema angewendet wird, und wendet dann den persistenten ARGVUS-Zustand erneut an, wie z. B. Taskleistenränder, den `right-2`-Dienstprogramm-Gruppenmodus, die Randradius-Einstellung und den Schriftblock. Dasselbe gilt für `data/waybar/argvus-taskbar.{jsonc,css}` und `data/waybar/argvus-widget-telemetry.{jsonc,css}`: Sie werden bei einer Änderung des Erscheinungsbildes aus den standardmäßig mitgelieferten Paketen ersetzt, sodass manuelle Änderungen dort ebenfalls verloren gehen.

Die unter `~/.config/argvus/data/generated/waybar/` generierten Dateien sind abgeleiteter Zustand und sollten nicht direkt bearbeitet werden; der gesamte Baum wird beim nächsten argvus config apply aus `config.json` neu aufgebaut. Verwenden Sie  `argvus config apply` `argvus --setup --copy taskbar` nicht als Pfad für die Taskleistenanpassung; der Taskleisten-Runner löst seine kanonischen `data/taskbar/`-Standorte oben auf.

## Persistente JSONC-Anpassung

Für eine dauerhaft manuelle Taskleistenkonfiguration erstellen Sie eine vollständige native Waybar-Überschreibung:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```
Bearbeiten Sie den Text in `~/.config/waybar/`. Häufige Änderungen sind:

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
Das Beispiel veranschaulicht die Waybar-Struktur; bewahren Sie die restliche konfigurierte Paketstruktur bei, wenn Sie sie anpassen. Eine native Überschreibung ist eine vollständige Datei, kein teilweises JSONC-Fragment. Bewahren Sie Module und Skripte, die vom ARGVUS-Desktop benötigt werden, wenn Sie möchten, dass die bestehenden Taskleiste-Aktionen weiterhin funktionieren.

## Persistente CSS-Anpassung

Das paketierte Stylesheet importiert seine Farben aus dem aktiven Theme-Build. Wenn Sie das CSS überschreiben, verweisen Sie das Theme-Import auf den Build, dessen Pfad bei Theme-Wechseln gleich bleibt:

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```
Native CSS- und Themen-Dateien werden benutzerabhängig. Themenänderungen werden sie nicht automatisch neu generieren; aktualisieren Sie sie bewusst, wenn ARGVUS Themenressourcen hinzufügt oder ändert.

## Änderungen anwenden und die effektive Datei überprüfen

Starten Sie nur die Taskleiste neu, nachdem Sie deren JSONC- oder CSS-Datei geändert haben:

```sh
argvus sessionctl restart waybar
```
Für eine vollständige Sitzungs-/Konfigurationsaktualisierung verwenden Sie:

```sh
argvus sessionctl reload
```
Um zu sehen, welche Dateien der laufende Waybar-Prozess tatsächlich verwendet:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```
Der Prozess sollte `-c` für die effektive JSONC-Datei und `-s` für die effektive CSS-Datei anzeigen. Wenn eine native Datei existiert, werden Änderungen an der verwalteten ARGVUS-Kopie die aktive Taskleiste nicht ändern, bis die native Datei entfernt oder aktualisiert wird.

Der Dienst und die Protokolle können überprüft werden mit:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```
Siehe [Taskbar](/docs/argvus-taskbar/taskbar/) für die benutzerorientierten Funktionen und [Dateispeicherorte](/docs/reference/file-locations/) für die installierten und Benutzerpfade.

## Hyprland-Arbeitsbereich-Kompatibilität

Der ARGVUS-Build akzeptiert sowohl veraltete numerische Arbeitsbereichs-IDs als auch Hyprland 0.57 textuelle Arbeitsbereichsadressen. Benannte Arbeitsbereiche ohne ein `id` erhalten prozesslokale interne Bezeichner konsistent über Arbeitsbereichs-Snapshots, Clients, Monitore und Ereignisse hinweg. Diese Bezeichner werden niemals an Hyprland gesendet: Arbeitsbereichsschaltflächen senden den echten Namen.

`hyprland/workspaces.workspace-metadata` benennt optional eine JSON-Datei relativ zu `$XDG_RUNTIME_DIR`, wie zum Beispiel `argvus/project-workspaces.json`. Jeder Arbeitsbereichsname wird einem Objekt mit `label`- und `tooltip`-Strings zugeordnet. Bezeichnungen werden als Pango-Text maskiert und ändern weder Übereinstimmungen noch Klickziele. Fehlende Metadaten fallen auf die nativen Arbeitsbereichsnamen zurück. `argvus projects` besitzt die abgeleiteten Projektmetadaten; öffnen Sie ein Projekt nach Listen-/Sprachänderungen erneut, um es zu aktualisieren.

## Fenster-Schaltflächen und Anwendungsleiste

Eine zweite Waybar erscheint auf jedem Monitor, am Rand gegenüber der Haupt-Taskleiste. Sie listet nur die Fenster auf, die zum aktuellen Workspace dieses Monitors gehören, einschließlich minimierter Fenster dieses Workspaces. Ein geöffnetes spezielles Workspace hat Vorrang. Anpinnte Fenster bleiben sichtbar; versteckte Gruppentabs erzeugen keine zusätzlichen Einträge, und eine minimierte Gruppe hat einen einzigen Wiederherstellungseintrag. Tabs innerhalb einer Anwendung werden nicht separat aufgelistet. Minimierte Einträge behalten ihre ursprüngliche Monitor-/Workspace-Zuordnung. Klicken Sie auf ein inaktives Fenster, um es zu aktivieren, auf ein aktives Fenster, um es zu minimieren, oder auf ein minimiertes Fenster, um es wiederherzustellen; sein Kontextmenü bietet Wiederherstellen, Minimieren, Maximieren/Wiederherstellen und Schließen. Unbekannte Anwendungssymbole werden durch ein Fenstersymbol ersetzt.

Das `hyprland/argvus-windows`-Modul verarbeitet einen JSON-Stream von `argvus windows watch --json`. GTK-Updates laufen im Hauptthread; Aktionen verwenden Argumentarrays und validierte Fensteradressen. Die Wiederherstellungsbereitschaft wird anhand der Liste der Kompositor-Ebenen bestätigt.
