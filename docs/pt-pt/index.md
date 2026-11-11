---
title: Overrides da Waybar e da taskbar
description: Personalize a taskbar Waybar do ARGVUS sem editar ficheiros empacotados.
---

`argvus-taskbar` fornece a configuração JSONC/CSS da taskbar do ARGVUS e seus helpers. `argvus-waybar` fornece o binário Waybar, enquanto `argvus-session` inicia o serviço e seleciona os ficheiros efetivos. Tanto a cópia gerenciada quanto a gerada são escritas pelo `argvus-config`: ele substitui a camada de tema e reaplica margens da taskbar, modo do grupo utilitário `right-2`, raio de borda e o bloco de fonte da telemetria quando temas ou estado de layout mudam. O `argvus-appearance` não escreve mais esses ficheiros; ele apenas confirma a mudança e pede um reload.

## Precedência da configuração

Para a taskbar e para a superfície de telemetria, `argvus sessionctl` resolve a configuração e a folha de estilos independentemente nesta ordem:

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

`$XDG_CONFIG_HOME` substitui `~/.config` quando estiver definido. O primeiro ficheiro existente vence.

A árvore generated vem **primeiro** para que a camada de tema ativa sempre vença: uma cópia do utilizador ou nativa obsoleta não pode manter a taskbar no tema anterior. A consequência prática é que um override nativo em `~/.config/waybar/` só tem efeito enquanto o ficheiro generated correspondente não existir — por exemplo após `rm -rf ~/.config/argvus/data/generated` antes do próximo reload, ou quando o ficheiro nunca foi projetado. Se você quiser um override nativo durável que sobreviva a mudanças de tema, use a árvore generated como ponto de partida, ou aceite que a camada de tema é dona desses dois ficheiros.

A configuração não é mesclada: um JSONC de override substitui a configuração completa da taskbar, e um CSS de override substitui a folha de estilos completa.

Os padrões empacotados são entradas somente leitura. Não edite:

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```

## Configuração gerenciada pelo ARGVUS

A sessão normal do ARGVUS usa as cópias gerenciadas em:

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```

O `argvus-config` recria esses ficheiros a partir dos padrões empacotados ao aplicar um tema e depois reaplica o estado persistente do ARGVUS, como margens da taskbar, o modo do grupo utilitário `right-2`, o raio de borda e o bloco de fonte. O mesmo vale para `data/waybar/argvus-taskbar.{jsonc,css}` e `data/waybar/argvus-widget-telemetry.{jsonc,css}`: eles são substituídos a partir dos defaults empacotados em uma mudança de aparência, então edições manuais nesses ficheiros também são perdidas.

Ficheiros em `~/.config/argvus/data/generated/waybar/` são estado derivado e não devem ser editados diretamente; a árvore inteira é reconstruída a partir do `config.json` no próximo `argvus config apply`. Não use `argvus --setup --copy taskbar` como caminho de personalização da taskbar; o runner resolve as localizações canônicas `data/taskbar/` descritas acima.

## Personalização persistente do JSONC

Para uma configuração manual persistente da taskbar, crie um override nativo completo da Waybar:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```

Edite a cópia em `~/.config/waybar/`. Alterações comuns incluem:

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

O exemplo mostra a estrutura da Waybar; mantenha o restante da configuração empacotada ao personalizá-la. Um override nativo é um ficheiro completo, não um fragmento JSONC parcial. Preserve os módulos e scripts necessários ao desktop ARGVUS se quiser manter as ações existentes da taskbar.

## Personalização persistente do CSS

A folha de estilos empacotada importa as cores do build do tema ativo. Se você substituir o CSS, aponte o import do tema para o build, cujo caminho não muda entre trocas de tema:

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```

CSS e temas nativos passam a pertencer ao utilizador. As mudanças de tema não os regeneram automaticamente; atualize-os conscientemente quando o ARGVUS adicionar ou alterar assets de tema.

## Aplicar alterações e consultar o ficheiro efetivo

Reinicie apenas a taskbar depois de alterar seu JSONC ou CSS:

```sh
argvus sessionctl restart waybar
```

Para uma atualização completa da sessão/configuração, use:

```sh
argvus sessionctl reload
```

Para ver quais ficheiros o processo Waybar em execução realmente usa:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```

O processo deve mostrar `-c` para o JSONC efetivo e `-s` para o CSS efetivo. Se existir um ficheiro nativo, alterações na cópia gerenciada do ARGVUS não mudarão a taskbar ativa até que o ficheiro nativo seja removido ou atualizado.

O serviço e os logs podem ser consultados com:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```

Veja [Taskbar](/pt/docs/argvus-taskbar/taskbar/) para as funcionalidades voltadas ao utilizador e [localizações de ficheiros](/pt/docs/reference/file-locations/) para os caminhos instalados e do utilizador.

## Compatibilidade de workspaces do Hyprland

A versão ARGVUS aceita tanto IDs numéricos antigos como endereços textuais de workspaces do Hyprland 0.57. Workspaces nomeados sem `id` recebem identificadores internos locais ao processo, consistentes entre snapshots, clientes, monitores e eventos. Esses identificadores nunca são enviados ao Hyprland: os botões usam o nome real.

`hyprland/workspaces.workspace-metadata` pode indicar um ficheiro JSON relativo a `$XDG_RUNTIME_DIR`, como `argvus/project-workspaces.json`. Cada nome de workspace aponta para um objeto com strings `label` e `tooltip`. Os rótulos são escapados como texto Pango e não alteram a identificação nem o destino do clique. Sem metadados, o nome nativo é usado. `argvus projects` gera os metadados de projetos; reabra um projeto após alterar a lista ou o idioma para atualizar os rótulos.


## Botões de janela e barra de aplicações

Uma segunda Waybar aparece em cada monitor, na borda oposta à taskbar principal. Ela lista apenas as janelas do workspace atual daquele monitor, incluindo as minimizadas desse workspace. Um workspace especial aberto tem prioridade. Janelas fixadas permanecem visíveis; abas ocultas de grupos não criam entradas extras, e um grupo minimizado tem uma entrada de recuperação. Abas internas das aplicações não são enumeradas separadamente. As minimizadas mantêm a associação ao monitor e workspace originais. Clique em uma janela sem foco para ativá-la, na janela ativa para minimizá-la ou em uma minimizada para restaurá-la; o menu de contexto oferece restaurar, minimizar, maximizar/restaurar e fechar. Ícones de aplicações desconhecidos usam um símbolo de janela.

O módulo `hyprland/argvus-windows` consome um fluxo JSON de `argvus windows watch --json`. Atualizações GTK executam na thread principal; ações usam arrays de argumentos e endereços de janela validados. A prontidão da recuperação é confirmada na lista de superfícies do compositor.
