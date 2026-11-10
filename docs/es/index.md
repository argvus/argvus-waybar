---
title: Sobrescrituras de Waybar y de la barra de tareas
description: Personaliza la barra de tareas ARGVUS Waybar sin editar los archivos empaquetados.
---
`argvus-taskbar` proporciona la configuración JSONC/CSS de la barra de tareas ARGVUS y sus scripts auxiliares. `argvus-waybar` proporciona el ejecutable de Waybar, mientras que `argvus-session` inicia el servicio y selecciona los archivos efectivos. La copia gestionada y la copia generada son ambas escritas por `argvus-config`: reemplaza la capa de tema y reaplica los márgenes de la barra de tareas, el modo de grupo de utilidades `right-2`, el radio del borde y el bloque de fuente de telemetría cada vez que los temas o el estado del diseño cambian. `argvus-appearance` ya no escribe estos archivos; solo confirma el cambio y solicita una recarga.

## Precedencia de la configuración

Para la barra de tareas y la superficie de telemetría, `argvus sessionctl` resuelve la configuración y la hoja de estilos de forma independiente en este orden:

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
`$XDG_CONFIG_HOME` reemplaza a `~/.config` cuando se establece. El primer archivo existente gana.

El árbol generado viene **primero**, por lo que la capa de tema activa siempre gana: una copia obsoleta del usuario o nativa no debe mantener la barra de tareas en el tema anterior. La consecuencia práctica es que una anulación nativa `~/.config/waybar/` solo entra en efecto mientras el archivo generado correspondiente esté ausente — por ejemplo, después de `rm -rf ~/.config/argvus/data/generated` antes de la próxima recarga, o cuando un archivo nunca fue proyectado. Si deseas una anulación nativa duradera que sobreviva a los cambios de tema, utiliza el árbol generado como punto de partida, o acepta que la capa de tema posee estos dos archivos.

La configuración no se fusiona: un archivo JSONC de anulación reemplaza la configuración completa de la barra de tareas, y un archivo CSS de anulación reemplaza la hoja de estilo completa.

Los valores predeterminados empaquetados son entradas de solo lectura. No los edites:

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```
## Configuración de ARGVUS gestionada

La sesión normal de ARGVUS utiliza las copias gestionadas bajo:

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```
`argvus-config` recrea estos archivos a partir de los valores predeterminados empaquetados al aplicar un tema, luego vuelve a aplicar el estado persistente ARGVUS como los márgenes de la barra de tareas, el modo de grupo de utilidades `right-2`, el radio del borde y el bloque de fuente. Lo mismo ocurre con `data/waybar/argvus-taskbar.{jsonc,css}` y `data/waybar/argvus-widget-telemetry.{jsonc,css}`: se reemplazan desde los valores predeterminados empaquetados cuando hay un cambio de apariencia, por lo que los cambios manuales allí también se pierden.

Los archivos generados bajo `~/.config/argvus/data/generated/waybar/` son estado derivado y no deben editarse directamente; todo el árbol se reconstruye desde `config.json` en el próximo `argvus config apply`. No use `argvus --setup --copy taskbar` como la ruta de personalización de la barra de tareas; el ejecutor de la barra de tareas resuelve sus ubicaciones canónicas `data/taskbar/` arriba.

## Personalización JSONC persistente

Para una configuración manual duradera de la barra de tareas, cree una anulación nativa completa de Waybar:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```
Edita el texto en `~/.config/waybar/`. Los cambios comunes incluyen:

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
El ejemplo ilustra la estructura de Waybar; mantén el resto de la configuración empaquetada al personalizarla. Una anulación nativa es un archivo completo, no un fragmento JSONC parcial. Conserva los módulos y scripts requeridos por el escritorio ARGVUS si quieres que las acciones de la barra de tareas existentes sigan funcionando.

## Personalización CSS persistente

La hoja de estilo empaquetada importa sus colores desde la compilación del tema activo. Si sobreescribes el CSS, apunta la importación del tema a la compilación, cuya ruta permanece igual al cambiar de tema:

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```
Los archivos nativos de CSS y de tema pasan a ser propiedad del usuario. Los cambios de tema no los regenerarán automáticamente; actualícelos deliberadamente cuando ARGVUS agregue o cambie recursos del tema.

## Aplicar cambios e inspeccionar el archivo efectivo

Reinicie solo la barra de tareas después de cambiar su JSONC o CSS:

```sh
argvus sessionctl restart waybar
```
Para una actualización completa de la sesión/configuración, use:

```sh
argvus sessionctl reload
```
Para ver qué archivos utiliza realmente el proceso en ejecución de Waybar:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```
El proceso debería mostrar `-c` para el archivo JSONC efectivo y `-s` para el archivo CSS efectivo. Si existe un archivo nativo, los cambios en la copia ARGVUS administrada no modificarán la barra de tareas activa hasta que el archivo nativo sea eliminado o actualizado.

Se puede inspeccionar el servicio y los registros con:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```
Consulta [Taskbar](/docs/argvus-taskbar/taskbar/) para las funciones visibles para el usuario y [file locations](/docs/reference/file-locations/) para las rutas instaladas y de usuario.

## Compatibilidad del espacio de trabajo de Hyprland

La compilación ARGVUS acepta tanto IDs numéricos de espacio de trabajo legados como direcciones textuales de espacio de trabajo de Hyprland 0.57. Los espacios de trabajo nombrados sin un `id` reciben identificadores internos locales del proceso de manera consistente en todos los snapshots de espacio de trabajo, clientes, monitores y eventos. Estos identificadores nunca se envían a Hyprland: los botones de espacio de trabajo despachan el nombre real.

`hyprland/workspaces.workspace-metadata` nombra opcionalmente un archivo JSON relativo a `$XDG_RUNTIME_DIR`, como `argvus/project-workspaces.json`. Cada nombre de espacio de trabajo se asigna a un objeto con cadenas `label` y `tooltip`. Las etiquetas se escapan como texto Pango y no cambian los objetivos de coincidencia o de clic. Los metadatos faltantes recurren a los nombres de espacios de trabajo nativos. `argvus projects` posee los metadatos de proyecto derivados; vuelva a abrir un proyecto después de cambios en la lista/idioma para actualizarlos.

## Botones de ventana y barra de aplicaciones

Aparece un segundo Waybar en cada monitor, en el borde opuesto a la barra de tareas principal. Solo enumera las ventanas que pertenecen al espacio de trabajo actual de ese monitor, incluidas las ventanas minimizadas de ese espacio de trabajo. Un espacio de trabajo especial abierto tiene prioridad. Las ventanas fijadas permanecen visibles; las pestañas de grupo ocultas no crean entradas adicionales, y un grupo minimizado tiene una entrada de recuperación. No se enumeran por separado las pestañas dentro de una aplicación. Las entradas minimizadas conservan su asociación original con el monitor/espacio de trabajo. Haga clic en una ventana inactiva para activarla, en una ventana activa para minimizarla, o en una ventana minimizada para restaurarla; su menú contextual ofrece restaurar, minimizar, maximizar/restaurar y cerrar. Los iconos de aplicaciones desconocidas se reemplazan por un símbolo de ventana.

El módulo `hyprland/argvus-windows` consume un flujo JSON de `argvus windows watch --json`. Las actualizaciones de GTK se ejecutan en el hilo principal; las acciones usan arreglos de argumentos y direcciones de ventana validadas. La preparación para la recuperación se confirma contra la lista de capas del compositor.
