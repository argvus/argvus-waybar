---
title: Waybarとタスクバーのオーバーライド
description: パッケージ化されたファイルを編集せずに、ARGVUS Waybar タスクバーをカスタマイズする。
---
`argvus-taskbar` は ARGVUS タスクバーの JSONC/CSS 設定とその補助スクリプトを提供します。`argvus-waybar` は Waybar バイナリを提供し、`argvus-session` はサービスを起動して有効なファイルを選択します。管理されたコピーと生成されたコピーはどちらも `argvus-config` によって書き込まれます：テーマレイヤーを置き換え、タスクバーのマージンを再適用し、`right-2` ユーティリティグループモード、ボーダー半径、テレメトリーフォントブロックをテーマやレイアウト状態が変更されるたびに適用します。`argvus-appearance` はもはやこれらのファイルを書き込まず、変更をコミットしリロードを求めるだけです。

## 設定の優先順位

タスクバーとテレメトリーサーフェスについて、`argvus sessionctl` は以下の順序で設定とスタイルシートを独立して解決します:

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
`$XDG_CONFIG_HOME` は `~/.config` が設定されているときに置き換えられます。最初に存在するファイルが優先されます。

生成されたツリーが**最初**に来るため、アクティブなテーマ層が常に優先されます：古いユーザーまたはネイティブのコピーが前のテーマでタスクバーを保持してはいけません。実際の結果として、ネイティブの `~/.config/waybar/` のオーバーライドは、対応する生成ファイルが存在しない場合のみ有効になります — 例えば `rm -rf ~/.config/argvus/data/generated` の後、次のリロード前、またはファイルが一度もプロジェクトされなかった場合などです。テーマ変更に耐える耐久性のあるネイティブオーバーライドを行いたい場合は、生成されたツリーを出発点として使用するか、これら2つのファイルはテーマ層の管理下であることを受け入れてください。

構成はマージされません：オーバーライド JSONC ファイルはタスクバーの構成全体を置き換え、オーバーライド CSS ファイルはスタイルシート全体を置き換えます。

パッケージ化されたデフォルトは読み取り専用の入力です。編集しないでください:

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```
## 管理された ARGVUS 設定

通常の ARGVUS セッションは、以下の管理コピーを使用します:

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```
`argvus-config`は、テーマを適用する際にパッケージ化されたデフォルトからこれらのファイルを再作成し、タスクバーのマージン、`right-2`ユーティリティグループモード、ボーダー半径、フォントブロックなどの永続的なARGVUS状態を再適用します。`data/waybar/argvus-taskbar.{jsonc,css}`および`data/waybar/argvus-widget-telemetry.{jsonc,css}`についても同様で、外観の変更時にはパッケージ化されたデフォルトから置き換えられるため、手動での編集も失われます。

`~/.config/argvus/data/generated/waybar/`で生成されたファイルは派生状態であるため、直接編集すべきではありません。次回のargvus config apply時には、`config.json`からツリー全体が再構築されます。 `argvus config apply` `argvus --setup --copy taskbar`をタスクバーカスタマイズのパスとして使用しないでください。タスクバーランナーは上記の正式な`data/taskbar/`の場所を解決します。

## 永続的なJSONCカスタマイズ

手動での永続的なタスクバー構成を作成するには、完全なネイティブWaybarオーバーライドを作成してください:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```
`~/.config/waybar/` のコピーを編集します。一般的な変更には次のものがあります:

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
この例はWaybarの構造を示しています。カスタマイズする際は、パッケージ化された他の設定も保持してください。ネイティブのオーバーライドは部分的なJSONCフラグメントではなく、完全なファイルです。既存のタスクバーの動作を継続させたい場合は、ARGVUSデスクトップに必要なモジュールやスクリプトを保持してください。

## 永続的なCSSカスタマイズ

パッケージ化されたスタイルシートは、アクティブなテーマビルドから色をインポートします。CSSをオーバーライドする場合、テーマのインポートをビルドに向けてください。ビルドのパスはテーマを切り替えても同じままです:

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```
ネイティブのCSSおよびテーマファイルはユーザー所有になります。テーマの変更は自動的にこれらを再生成しません。ARGVUSがテーマのアセットを追加または変更したときに、意図的にそれらを更新してください。

## 変更を適用して有効なファイルを確認する

JSONCまたはCSSを変更した後、タスクバーのみを再起動します:

```sh
argvus sessionctl restart waybar
```
セッション/設定を完全にリフレッシュするには、次を使用してください:

```sh
argvus sessionctl reload
```
実行中の Waybar プロセスが実際に使用しているファイルを確認するには:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```
プロセスは、実際の JSONC ファイルには `-c`、実際の CSS ファイルには `-s` を表示する必要があります。ネイティブファイルが存在する場合、管理対象の ARGVUS コピーの変更は、ネイティブファイルが削除または更新されるまで、アクティブなタスクバーに反映されません。

サービスおよびログは以下で確認できます:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```
ユーザー向け機能については[Taskbar](/docs/argvus-taskbar/taskbar/)、インストールおよびユーザーパスについては[file locations](/docs/reference/file-locations/)を参照してください。

## Hyprlandワークスペースの互換性

ARGVUSビルドは、従来の数値ワークスペースIDとHyprland 0.57のテキスト形式ワークスペースアドレスの両方を受け付けます。`id`のない名前付きワークスペースには、ワークスペースのスナップショット、クライアント、モニター、イベントにわたって一貫したプロセスローカルの内部識別子が割り当てられます。これらの識別子はHyprlandに送信されることはなく、ワークスペースボタンは実際の名前を送信します。

`hyprland/workspaces.workspace-metadata` は、`$XDG_RUNTIME_DIR` を基準とした JSON ファイルの名前を任意で指定できます。例えば `argvus/project-workspaces.json` などです。各ワークスペース名は、`label` および `tooltip` の文字列を持つオブジェクトに対応します。ラベルは Pango テキストとしてエスケープされ、マッチングやクリック対象は変わりません。メタデータが存在しない場合は、ネイティブのワークスペース名が使用されます。`argvus projects` が派生したプロジェクトメタデータを管理します。リストや言語を変更した後にプロジェクトを再度開くと、メタデータが更新されます。

## ウィンドウボタンとアプリケーションバー

セカンドのWaybarは、すべてのモニターに、メインタスクバーの反対側の端に表示されます。そのモニターの現在のワークスペースに属するウィンドウのみをリスト表示し、そのワークスペースから最小化されたウィンドウも含まれます。開いている特別なワークスペースが優先されます。ピン留めされたウィンドウは表示されたままで、非表示のグループタブは追加のエントリを作成せず、最小化されたグループには1つの回復用エントリがあります。アプリケーション内のタブは個別に列挙されません。最小化されたエントリは元のモニター／ワークスペースの関連付けを保持します。非アクティブなウィンドウをクリックするとアクティブになり、アクティブなウィンドウをクリックすると最小化され、最小化されたウィンドウをクリックすると復元されます；そのコンテキストメニューでは復元、最小化、最大化／復元、閉じるが選べます。未知のアプリケーションのアイコンは、ウィンドウ記号にフォールバックします。

`hyprland/argvus-windows`モジュールは`argvus windows watch --json`からのJSONストリームを消費します。GTKの更新はメインスレッドで実行され、アクションは引数配列と検証済みのウィンドウアドレスを使用します。リカバリ準備はコンポジタレイヤリストに対して確認されます。
