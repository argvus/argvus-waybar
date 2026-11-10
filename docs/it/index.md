---
title: Sovrascritture di Waybar e della barra delle applicazioni
description: Personalizza la barra delle applicazioni ARGVUS Waybar senza modificare i file confezionati.
---
`argvus-taskbar` fornisce la configurazione JSONC/CSS della barra delle applicazioni ARGVUS e i suoi script di supporto. `argvus-waybar` fornisce il binario di Waybar, mentre `argvus-session` avvia il servizio e seleziona i file effettivi. La copia gestita e la copia generata sono entrambe scritte da `argvus-config`: sostituisce il livello del tema e riapplica i margini della barra delle applicazioni, la modalità del gruppo di utilità di `right-2`, il raggio del bordo e il blocco del font della telemetria ogni volta che cambiano temi o stato del layout. `argvus-appearance` non scrive più questi file; si limita a confermare la modifica e richiedere un ricaricamento.

## Precedenza della configurazione

Per la barra delle applicazioni e la superficie di telemetria, `argvus sessionctl` risolve la configurazione e il foglio di stile in modo indipendente in questo ordine:

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
`$XDG_CONFIG_HOME` sostituisce `~/.config` quando è impostato. Il primo file esistente ha la precedenza.

L'albero generato viene **prima** quindi lo strato del tema attivo ha sempre la precedenza: una copia utente o nativa obsoleta non deve mantenere la barra delle applicazioni sul tema precedente. La conseguenza pratica è che una sovrascrittura nativa `~/.config/waybar/` entra in vigore solo quando il file generato corrispondente è assente — per esempio dopo `rm -rf ~/.config/argvus/data/generated` prima del successivo caricamento, o quando un file non è mai stato proiettato. Se vuoi una sovrascrittura nativa duratura che sopravvive ai cambiamenti del tema, usa l'albero generato come punto di partenza, o accetta che lo strato del tema possieda questi due file.

La configurazione non viene unita: un file JSONC di sovrascrittura sostituisce l'intera configurazione della barra delle applicazioni, e un file CSS di sovrascrittura sostituisce l'intero foglio di stile.

I valori predefiniti inclusi nel pacchetto sono input di sola lettura. Non modificare:

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```
## Configurazione ARGVUS gestita

La normale sessione ARGVUS utilizza le copie gestite sotto:

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```
`argvus-config` ricrea questi file dai valori predefiniti pacchettizzati quando si applica un tema, quindi riapplica lo stato ARGVUS persistente come i margini della barra delle applicazioni, la modalità gruppo di utility `right-2`, il raggio del bordo e il blocco del font. Lo stesso vale per `data/waybar/argvus-taskbar.{jsonc,css}` e `data/waybar/argvus-widget-telemetry.{jsonc,css}`: vengono sostituiti dai valori predefiniti pacchettizzati al cambio dell'aspetto, quindi anche le modifiche manuali lì vengono perse.

I file generati sotto `~/.config/argvus/data/generated/waybar/` sono uno stato derivato e non dovrebbero essere modificati direttamente; l'intero albero viene ricostruito da `config.json` al prossimo `argvus config apply`. Non usare `argvus --setup --copy taskbar` come percorso di personalizzazione della barra delle applicazioni; il runner della barra delle applicazioni risolve le sue posizioni canoniche `data/taskbar/` sopra.

## Personalizzazione JSONC persistente

Per una configurazione manuale della barra delle applicazioni durevole, crea un override completo nativo di Waybar:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```
Modifica il testo in `~/.config/waybar/`. Le modifiche comuni includono:

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
L'esempio illustra la struttura di Waybar; conserva il resto della configurazione pacchettizzata quando la personalizzi. Una sovrascrittura nativa è un file completo, non un frammento JSONC parziale. Mantieni i moduli e gli script richiesti dal desktop ARGVUS se vuoi che le azioni della barra delle applicazioni esistenti continuino a funzionare.

## Personalizzazione CSS persistente

Il foglio di stile pacchettizzato importa i suoi colori dalla build del tema attivo. Se sovrascrivi il CSS, punta l'importazione del tema alla build, il cui percorso rimane lo stesso durante il cambio dei temi:

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```
I file CSS nativi e i file del tema diventano di proprietà dell'utente. Le modifiche al tema non li rigenereranno automaticamente; aggiornali deliberatamente quando ARGVUS aggiunge o modifica risorse del tema.

## Applica le modifiche e controlla il file effettivo

Riavvia solo la barra delle applicazioni dopo aver modificato il suo JSONC o CSS:

```sh
argvus sessionctl restart waybar
```
Per un aggiornamento completo della sessione/configurazione, utilizzare:

```sh
argvus sessionctl reload
```
Per vedere quali file il processo Waybar in esecuzione utilizza effettivamente:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```
Il processo dovrebbe mostrare `-c` per il file JSONC effettivo e `-s` per il file CSS effettivo. Se esiste un file nativo, le modifiche alla copia gestita ARGVUS non cambieranno la barra delle applicazioni attiva fino a quando il file nativo non venga rimosso o aggiornato.

Il servizio e i log possono essere controllati con:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```
Vedi [Taskbar](/docs/argvus-taskbar/taskbar/) per le funzionalità visibili all'utente e [file locations](/docs/reference/file-locations/) per i percorsi installati e utente.

## Compatibilità degli spazi di lavoro di Hyprland

La build ARGVUS accetta sia gli ID numerici legacy degli spazi di lavoro sia gli indirizzi testuali degli spazi di lavoro di Hyprland 0.57. Gli spazi di lavoro denominati senza un `id` ricevono identificatori interni locali al processo in modo coerente attraverso snapshot degli spazi di lavoro, client, monitor ed eventi. Questi identificatori non vengono mai inviati a Hyprland: i pulsanti degli spazi di lavoro inviano il nome reale.

`hyprland/workspaces.workspace-metadata` indica facoltativamente un file JSON relativo a `$XDG_RUNTIME_DIR`, come `argvus/project-workspaces.json`. Ogni nome di workspace mappa a un oggetto con stringhe `label` e `tooltip`. Le etichette sono scappate come testo Pango e non modificano i target di corrispondenza o di clic. I metadati mancanti ricadono sui nomi dei workspace nativi. `argvus projects` possiede i metadati del progetto derivati; riapri un progetto dopo modifiche alla lista/linguaggio per aggiornarli.

## Pulsanti della finestra e barra delle applicazioni

Un secondo Waybar appare su ogni monitor, sul bordo opposto alla barra delle applicazioni principale. Elenca solo le finestre appartenenti al workspace corrente di quel monitor, incluse le finestre ridotte a icona di quel workspace. Un workspace speciale aperto ha la precedenza. Le finestre appuntate rimangono visibili; le schede di gruppo nascoste non creano voci aggiuntive e un gruppo ridotto a icona ha una voce di recupero. Le schede all'interno di un'applicazione non sono enumerate separatamente. Le voci ridotte mantengono la loro associazione originale con monitor/workspace. Clicca su una finestra inattiva per attivarla, su una finestra attiva per ridurla a icona o su una finestra ridotta a icona per ripristinarla; il suo menu contestuale offre ripristina, riduci a icona, ingrandisci/ripristina e chiudi. Le icone di applicazioni sconosciute ricadono su un simbolo di finestra.

Il modulo `hyprland/argvus-windows` consuma un flusso JSON da `argvus windows watch --json`. Gli aggiornamenti GTK vengono eseguiti sul thread principale; le azioni utilizzano array di argomenti e indirizzi di finestra validati. La preparazione al recupero viene confermata rispetto all'elenco dei livelli del compositore.
