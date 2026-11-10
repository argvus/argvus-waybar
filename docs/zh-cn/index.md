---
title: Waybar 和任务栏覆盖
description: 无需编辑打包的文件即可自定义 ARGVUS Waybar 任务栏。
---
`argvus-taskbar` 提供 ARGVUS 任务栏的 JSONC/CSS 配置及其辅助脚本。`argvus-waybar` 提供 Waybar 二进制文件，而 `argvus-session` 启动服务并选择有效文件。受管理的副本和生成的副本均由 `argvus-config` 编写：它在主题层发生变化时替换主题层并重新应用任务栏边距、`right-2` 实用程序组模式、边框半径以及遥测字体块。`argvus-appearance` 不再写入这些文件；它只提交更改并请求重新加载。

## 配置优先级

对于任务栏和遥测界面，`argvus sessionctl` 独立按以下顺序解析配置和样式表：

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
`$XDG_CONFIG_HOME` 会在设置时替换 `~/.config`。先存在的文件优先。

生成的树**优先**，因此活动主题层总是胜出：过时的用户或原生副本不能将任务栏保留在上一个主题上。实际结果是，原生的 `~/.config/waybar/` 覆盖只有在对应的生成文件不存在时才会生效——例如在 `rm -rf ~/.config/argvus/data/generated` 之后、下一次重新加载之前，或者当文件从未被投影时。如果你想要一个在主题更改后仍然有效的原生覆盖，请以生成的树作为起点，或者接受主题层控制这两个文件。

配置不会合并：覆盖的 JSONC 文件会替换完整的任务栏配置，覆盖的 CSS 文件会替换完整的样式表。

打包的默认值是只读的输入。请勿编辑：

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```
## 托管 ARGVUS 配置

普通的 ARGVUS 会话使用以下位置的托管副本：

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```
`argvus-config` 在应用主题时会从打包的默认文件重新生成这些文件，然后重新应用持久的 ARGVUS 状态，例如任务栏边距、`right-2` 工具组模式、边框半径和字体块。`data/waybar/argvus-taskbar.{jsonc,css}` 和 `data/waybar/argvus-widget-telemetry.{jsonc,css}` 也是如此：在外观更改时会从打包的默认文件替换，因此那里的手动编辑也会丢失。

`~/.config/argvus/data/generated/waybar/` 下生成的文件是派生状态，不应直接编辑；整个树将在下一次 argvus config apply 时从 `config.json` 重新构建。不要使用  `argvus config apply` `argvus --setup --copy taskbar` 作为任务栏自定义路径；任务栏运行程序会解析其上方的规范 `data/taskbar/` 位置。

## 持久 JSONC 自定义

为了持久的手动任务栏配置，请创建一个完整的原生 Waybar 覆盖:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```
编辑 `~/.config/waybar/` 中的文案。常见的更改包括：

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
该示例说明了 Waybar 的结构；在自定义时请保留其余打包配置。原生覆盖是一个完整的文件，而不是部分 JSONC 片段。如果希望现有任务栏操作继续工作，请保留 ARGVUS 桌面所需的模块和脚本。

## 持久的 CSS 自定义

打包的样式表从活动主题构建中导入其颜色。如果你覆盖 CSS，请将主题导入指向该构建，其路径在主题切换时保持不变：

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```
本地 CSS 和主题文件将由用户拥有。主题更改不会自动重新生成它们；当 ARGVUS 添加或更改主题资源时，请有意更新它们。

## 应用更改并检查有效文件

在更改任务栏的 JSONC 或 CSS 后仅重启任务栏：

```sh
argvus sessionctl restart waybar
```
要进行完整的会话/配置刷新，请使用：

```sh
argvus sessionctl reload
```
查看正在运行的 Waybar 进程实际使用了哪些文件：

```sh
pgrep -af 'waybar.*argvus-taskbar'
```
该过程应显示 `-c` 对应有效的 JSONC 文件，以及 `-s` 对应有效的 CSS 文件。如果存在本地文件，对托管的 ARGVUS 副本的更改不会更改活动任务栏，除非本地文件被删除或更新。

可以检查服务和日志如下：

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```
请参阅 [Taskbar](/docs/argvus-taskbar/taskbar/)] 了解面向用户的功能，以及 [file locations](/docs/reference/file-locations/)] 了解已安装和用户路径。

## Hyprland 工作区兼容性

ARGVUS 构建同时接受传统的数字工作区 ID 和 Hyprland 0.57 的文本工作区地址。未命名的工作区 `id` 在工作区快照、客户端、监视器和事件中始终接收进程本地的内部标识符。这些标识符永远不会发送到 Hyprland：工作区按钮会派发真实名称。

`hyprland/workspaces.workspace-metadata` 可选择命名相对于 `$XDG_RUNTIME_DIR` 的 JSON 文件，例如 `argvus/project-workspaces.json`。每个工作区名称映射到一个包含 `label` 和 `tooltip` 字符串的对象。标签以 Pango 文本形式转义，不会更改匹配或点击目标。缺失的元数据将回退到本地工作区名称。`argvus projects` 拥有派生的项目元数据；在列表/语言更改后重新打开项目以刷新它。

## 窗口按钮和应用程序栏

在每个显示器上都会出现第二个 Waybar，位于主任务栏的对边。它只列出属于该显示器当前工作区的窗口，包括该工作区已最小化的窗口。打开的特殊工作区优先显示。固定的窗口保持可见；隐藏的组标签不会创建额外条目，而已最小化的组只会有一个恢复条目。应用程序内的标签不会单独列出。最小化的条目保持其原始的显示器/工作区关联。点击非激活窗口可激活它，点击激活窗口可最小化它，点击最小化窗口可恢复它；其上下文菜单提供恢复、最小化、最大化/恢复和关闭功能。未知的应用程序图标会回退为窗口符号。

`hyprland/argvus-windows` 模块从 `argvus windows watch --json` 消费 JSON 流。GTK 更新在主线程上运行；操作使用参数数组和验证过的窗口地址。恢复准备情况根据合成器层列表进行确认。
