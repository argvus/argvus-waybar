---
title: Substitutions de Waybar et de la barre des tâches
description: Personnalisez la barre des tâches ARGVUS Waybar sans modifier les fichiers empaquetés.
---
`argvus-taskbar` fournit la configuration JSONC/CSS de la barre des tâches ARGVUS et ses scripts d'assistance. `argvus-waybar` fournit le binaire Waybar, tandis que `argvus-session` démarre le service et sélectionne les fichiers effectifs. La copie gérée et la copie générée sont toutes deux écrites par `argvus-config` : il remplace la couche de thème et réapplique les marges de la barre des tâches, le mode groupe d'utilitaires `right-2`, le rayon des bordures et le bloc de polices de télémétrie chaque fois que les thèmes ou l'état de la mise en page changent. `argvus-appearance` n'écrit plus ces fichiers ; il se contente de valider le changement et demande un rechargement.

## Priorité de la configuration

Pour la barre des tâches et la surface de télémétrie, `argvus sessionctl` résout la configuration et la feuille de style indépendamment dans cet ordre :

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
`$XDG_CONFIG_HOME` remplace `~/.config` lorsqu'il est défini. Le premier fichier existant l'emporte.

L'arborescence générée vient **en premier**, donc la couche de thème active l'emporte toujours : une copie utilisateur ou native obsolète ne doit pas conserver la barre des tâches sur le thème précédent. La conséquence pratique est qu'une substitution native `~/.config/waybar/` ne prend effet que lorsque le fichier généré correspondant est absent — par exemple après `rm -rf ~/.config/argvus/data/generated` avant le prochain rechargement, ou lorsqu'un fichier n'a jamais été projeté. Si vous souhaitez une substitution native durable qui survive aux changements de thème, utilisez l'arborescence générée comme point de départ, ou acceptez que la couche de thème possède ces deux fichiers.

La configuration n'est pas fusionnée : un fichier JSONC de substitution remplace la configuration complète de la barre des tâches, et un fichier CSS de substitution remplace la feuille de style complète.

Les valeurs par défaut fournies sont en lecture seule. Ne pas modifier :

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```
## Configuration gérée d'ARGVUS

La session ARGVUS normale utilise les copies gérées sous :

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```
`argvus-config` recrée ces fichiers à partir des valeurs par défaut emballées lors de l'application d'un thème, puis réapplique l'état persistant ARGVUS tel que les marges de la barre des tâches, le mode de groupe d'utilitaires `right-2`, le rayon de bordure et le bloc de police. Il en va de même pour `data/waybar/argvus-taskbar.{jsonc,css}` et `data/waybar/argvus-widget-telemetry.{jsonc,css}` : ils sont remplacés à partir des valeurs par défaut emballées lors d'un changement d'apparence, donc les modifications manuelles y sont également perdues.

Les fichiers générés sous `~/.config/argvus/data/generated/waybar/` sont des états dérivés et ne doivent pas être modifiés directement ; tout l'arborescence est reconstruite depuis `config.json` lors du prochain `argvus config apply`. N'utilisez pas `argvus --setup --copy taskbar` comme chemin de personnalisation de la barre des tâches ; le lanceur de la barre des tâches résout ses emplacements canoniques `data/taskbar/` ci-dessus.

## Personnalisation JSONC persistante

Pour une configuration manuelle durable de la barre des tâches, créez un contournement Waybar natif complet :

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```
Modifiez le texte dans `~/.config/waybar/`. Les modifications courantes incluent :

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
L'exemple illustre la structure de Waybar ; conservez le reste de la configuration fournie lors de sa personnalisation. Une substitution native est un fichier complet, et non un fragment JSONC partiel. Préservez les modules et scripts requis par le bureau ARGVUS si vous souhaitez que les actions de la barre des tâches existantes continuent de fonctionner.

## Personnalisation CSS persistante

La feuille de style fournie importe ses couleurs à partir de la version active du thème. Si vous remplacez le CSS, pointez l'importation du thème vers la version, dont le chemin reste le même lors des changements de thème :

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```
Les fichiers CSS natifs et de thème deviennent la propriété de l'utilisateur. Les modifications de thème ne les régénéreront pas automatiquement ; mettez-les à jour délibérément lorsque ARGVUS ajoute ou modifie des ressources de thème.

## Appliquer les modifications et inspecter le fichier effectif

Redémarrez uniquement la barre des tâches après avoir modifié son JSONC ou CSS :

```sh
argvus sessionctl restart waybar
```
Pour un rafraîchissement complet de la session/configuration, utilisez :

```sh
argvus sessionctl reload
```
Pour voir quels fichiers le processus Waybar en cours d'exécution utilise réellement :

```sh
pgrep -af 'waybar.*argvus-taskbar'
```
Le processus devrait afficher `-c` pour le fichier JSONC effectif et `-s` pour le fichier CSS effectif. Si un fichier natif existe, les modifications apportées à la copie ARGVUS gérée ne changeront pas la barre des tâches active tant que le fichier natif n'est pas supprimé ou mis à jour.

Le service et les journaux peuvent être inspectés avec :

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```
Voir [Taskbar](/docs/argvus-taskbar/taskbar/) pour les fonctionnalités visibles par l'utilisateur et [file locations](/docs/reference/file-locations/) pour les chemins installés et utilisateur.

## Compatibilité des espaces de travail Hyprland

La version ARGVUS accepte à la fois les identifiants numériques d'espaces de travail hérités et les adresses textuelles des espaces de travail Hyprland 0.57. Les espaces de travail nommés sans un `id` reçoivent des identifiants internes locaux au processus de manière cohérente à travers les instantanés d'espaces de travail, les clients, les moniteurs et les événements. Ces identifiants ne sont jamais envoyés à Hyprland : les boutons des espaces de travail envoient le vrai nom.

`hyprland/workspaces.workspace-metadata` nomme éventuellement un fichier JSON par rapport à `$XDG_RUNTIME_DIR`, comme `argvus/project-workspaces.json`. Chaque nom d’espace de travail correspond à un objet avec les chaînes `label` et `tooltip`. Les étiquettes sont échappées en tant que texte Pango et ne modifient pas la correspondance ni les cibles de clic. Les métadonnées manquantes se reportent aux noms d’espace de travail natifs. `argvus projects` possède les métadonnées du projet dérivé ; rouvrez un projet après des changements de liste/langue pour le rafraîchir.

## Boutons de la fenêtre et barre d’application

Une deuxième Waybar apparaît sur chaque moniteur, du côté opposé à la barre des tâches principale. Elle ne liste que les fenêtres appartenant à l'espace de travail actuel de ce moniteur, y compris les fenêtres minimisées de cet espace de travail. Un espace de travail spécial ouvert a la priorité. Les fenêtres épinglées restent visibles ; les onglets de groupe masqués ne créent pas d'entrées supplémentaires, et un groupe minimisé a une entrée de récupération. Les onglets à l'intérieur d'une application ne sont pas énumérés séparément. Les entrées minimisées conservent leur association d'origine avec le moniteur/l'espace de travail. Cliquez sur une fenêtre inactive pour l'activer, sur une fenêtre active pour la minimiser, ou sur une fenêtre minimisée pour la restaurer ; son menu contextuel propose restaurer, minimiser, maximiser/restaurer et fermer. Les icônes d'application inconnues sont remplacées par un symbole de fenêtre.

Le module `hyprland/argvus-windows` consomme un flux JSON de `argvus windows watch --json`. Les mises à jour GTK s'exécutent sur le thread principal ; les actions utilisent des tableaux d'arguments et des adresses de fenêtres validées. La préparation à la récupération est confirmée par rapport à la liste des couches du compositeur.
