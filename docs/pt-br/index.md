---
title: Overrides da Waybar e da taskbar
description: Personalize a taskbar Waybar do ARGVUS sem editar arquivos empacotados.
slug: pt/0.4.0/docs/user-guide/desktop/waybar-overrides
---

`argvus-taskbar` fornece a configuração JSONC/CSS da taskbar do ARGVUS e seus helpers. `argvus-waybar` fornece o binário Waybar, enquanto `argvus-session` inicia o serviço e seleciona os arquivos efetivos. Tanto a cópia gerenciada quanto a gerada são escritas pelo `argvus-config`: ele substitui a camada de tema e reaplica margens da taskbar, modo do grupo utilitário `right-2`, raio de borda e o bloco de fonte da telemetria quando temas ou estado de layout mudam. O `argvus-appearance` não escreve mais esses arquivos; ele apenas confirma a mudança e pede um reload.

## Precedência da configuração

Para a taskbar e para a superfície de telemetria, `argvus-sessionctl` resolve a configuração e a folha de estilos independentemente nesta ordem:

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

`$XDG_CONFIG_HOME` substitui `~/.config` quando estiver definido. O primeiro arquivo existente vence.

A árvore generated vem **primeiro** para que a camada de tema ativa sempre vença: uma cópia do usuário ou nativa obsoleta não pode manter a taskbar no tema anterior. A consequência prática é que um override nativo em `~/.config/waybar/` só tem efeito enquanto o arquivo generated correspondente não existir — por exemplo após `rm -rf ~/.config/argvus/data/generated` antes do próximo reload, ou quando o arquivo nunca foi projetado. Se você quiser um override nativo durável que sobreviva a mudanças de tema, use a árvore generated como ponto de partida, ou aceite que a camada de tema é dona desses dois arquivos.

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

O `argvus-config` recria esses arquivos a partir dos padrões empacotados ao aplicar um tema e depois reaplica o estado persistente do ARGVUS, como margens da taskbar, o modo do grupo utilitário `right-2`, o raio de borda e o bloco de fonte. O mesmo vale para `data/waybar/argvus-taskbar.{jsonc,css}` e `data/waybar/argvus-widget-telemetry.{jsonc,css}`: eles são substituídos a partir dos defaults empacotados em uma mudança de aparência, então edições manuais nesses arquivos também são perdidas.

Arquivos em `~/.config/argvus/data/generated/waybar/` são estado derivado e não devem ser editados diretamente; a árvore inteira é reconstruída a partir do `config.json` no próximo `argvus-config apply`. Não use `argvus --setup --copy taskbar` como caminho de personalização da taskbar; o runner resolve as localizações canônicas `data/taskbar/` descritas acima.

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

O exemplo mostra a estrutura da Waybar; mantenha o restante da configuração empacotada ao personalizá-la. Um override nativo é um arquivo completo, não um fragmento JSONC parcial. Preserve os módulos e scripts necessários ao desktop ARGVUS se quiser manter as ações existentes da taskbar.

## Personalização persistente do CSS

A folha de estilos empacotada importa temas usando caminhos relativos. Se você substituir o CSS, copie também o diretório de temas ou troque os imports por caminhos existentes na sua configuração:

```sh
mkdir -p ~/.config/waybar/themes
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
cp -a /usr/share/argvus/taskbar/config/themes/. ~/.config/waybar/themes/
```

CSS e temas nativos passam a pertencer ao usuário. As mudanças de tema não os regeneram automaticamente; atualize-os conscientemente quando o ARGVUS adicionar ou alterar assets de tema.

## Aplicar alterações e consultar o arquivo efetivo

Reinicie apenas a taskbar depois de alterar seu JSONC ou CSS:

```sh
argvus-sessionctl restart waybar
```

Para uma atualização completa da sessão/configuração, use:

```sh
argvus-sessionctl reload
```

Para ver quais arquivos o processo Waybar em execução realmente usa:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```

O processo deve mostrar `-c` para o JSONC efetivo e `-s` para o CSS efetivo. Se existir um arquivo nativo, alterações na cópia gerenciada do ARGVUS não mudarão a taskbar ativa até que o arquivo nativo seja removido ou atualizado.

O serviço e os logs podem ser consultados com:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```

Veja [Taskbar](/pt/docs/argvus-taskbar/taskbar/) para as funcionalidades voltadas ao usuário e [localizações de arquivos](/pt/docs/reference/file-locations/) para os caminhos instalados e do usuário.
