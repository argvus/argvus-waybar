---
title: Waybar 및 작업 표시줄 덮어쓰기
description: 패키지 파일을 편집하지 않고 ARGVUS Waybar 작업 표시줄을 사용자 정의하세요.
---
`argvus-taskbar`는 ARGVUS 작업 표시줄 JSONC/CSS 구성과 그 보조 스크립트를 제공합니다. `argvus-waybar`는 Waybar 바이너리를 제공하며, `argvus-session`는 서비스를 시작하고 유효한 파일을 선택합니다. 관리된 복사본과 생성된 복사본 모두 `argvus-config`에 의해 작성됩니다: 테마 레이어를 교체하고 작업 표시줄 여백을 다시 적용하며, `right-2` 유틸리티 그룹 모드, 테두리 반경 및 테마나 레이아웃 상태가 변경될 때마다 원격 측정 글꼴 블록을 적용합니다. `argvus-appearance`는 더 이상 이러한 파일을 작성하지 않으며, 변경 사항을 커밋하고 다시 로드를 요청하는 것만 수행합니다.

## 구성 우선순위

작업 표시줄과 원격 측정 화면의 경우, `argvus sessionctl`는 다음 순서로 구성과 스타일시트를 독립적으로 해결합니다:

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
`$XDG_CONFIG_HOME`은 `~/.config`이 설정될 때 이를 대체합니다. 먼저 존재하는 파일이 우선합니다.

생성된 트리가 **먼저** 나오므로 활성 테마 레이어가 항상 우선합니다: 오래된 사용자 또는 기본 복사본이 이전 테마에서 작업 표시줄을 유지해서는 안 됩니다. 실제 결과는, 기본 `~/.config/waybar/` 재정의는 해당 생성된 파일이 없을 때만 적용된다는 것입니다 — 예를 들어 `rm -rf ~/.config/argvus/data/generated` 이후 다음 재로드 전, 또는 파일이 한 번도 투영되지 않았을 때입니다. 테마 변경 후에도 지속되는 기본 재정의를 원하면, 생성된 트리를 시작점으로 사용하거나, 이 두 파일은 테마 레이어의 소유임을 받아들여야 합니다.

구성은 병합되지 않습니다: 재정의 JSONC 파일은 전체 작업 표시줄 구성을 대체하며, 재정의 CSS 파일은 전체 스타일시트를 대체합니다.

패키지된 기본값은 읽기 전용 입력입니다. 편집하지 마십시오:

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```
## 관리되는 ARGVUS 구성

일반 ARGVUS 세션은 다음 아래의 관리된 복사본을 사용합니다:

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```
`argvus-config`는 테마를 적용할 때 패키지 기본값에서 이러한 파일을 다시 생성한 다음, 작업 표시줄 여백, `right-2` 유틸리티 그룹 모드, 테두리 반경 및 글꼴 블록과 같은 지속적인 ARGVUS 상태를 다시 적용합니다. `data/waybar/argvus-taskbar.{jsonc,css}`와 `data/waybar/argvus-widget-telemetry.{jsonc,css}`도 마찬가지입니다: 외관 변경 시 패키지 기본값으로 교체되므로 수동으로 편집한 내용도 사라집니다.

`~/.config/argvus/data/generated/waybar/` 아래에 생성된 파일은 도출된 상태이며 직접 편집해서는 안 됩니다; 전체 트리는 다음 argvus config apply에서 `config.json`로부터 재구성됩니다. 작업 표시줄 사용자 정의 경로로  `argvus config apply` `argvus --setup --copy taskbar`를 사용하지 마십시오; 작업 표시줄 실행기는 위에 명시된 정규 `data/taskbar/` 위치를 확인합니다.

## 지속적인 JSONC 사용자 정의

지속 가능한 수동 작업 표시줄 구성을 위해 전체 네이티브 Waybar 오버라이드를 생성하십시오:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```
`~/.config/waybar/`의 복사본을 편집하세요. 일반적인 변경 사항은 다음과 같습니다:

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
예시는 Waybar 구조를 보여줍니다; 사용자 정의할 때 나머지 패키지된 구성은 그대로 유지하세요. 네이티브 오버라이드는 부분 JSONC 조각이 아니라 완전한 파일입니다. 기존 작업 표시줄 기능이 계속 작동하도록 하려면 ARGVUS 데스크탑에서 필요한 모듈과 스크립트를 보존하세요.

## 지속적인 CSS 사용자 정의

패키지된 스타일시트는 활성 테마 빌드에서 색상을 가져옵니다. CSS를 오버라이드하는 경우 테마 가져오기 경로를 빌드로 지정하세요. 이 경로는 테마를 전환해도 동일하게 유지됩니다:

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```
네이티브 CSS 및 테마 파일은 사용자가 소유하게 됩니다. 테마 변경 사항은 자동으로 파일을 재생성하지 않으므로, ARGVUS가 테마 자산을 추가하거나 변경할 때 파일을 의도적으로 업데이트해야 합니다.

## 변경 사항 적용 및 실제 파일 확인

JSONC 또는 CSS를 변경한 후에는 작업 표시줄만 재시작하세요:

```sh
argvus sessionctl restart waybar
```
완전한 세션/구성 새로 고침을 위해, 다음을 사용하세요:

```sh
argvus sessionctl reload
```
실행 중인 Waybar 프로세스가 실제로 사용하는 파일을 확인하려면:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```
해당 프로세스는 유효한 JSONC 파일에 대해 `-c`를, 유효한 CSS 파일에 대해 `-s`를 보여야 합니다. 네이티브 파일이 존재하는 경우, 관리되는 ARGVUS 복사본에 대한 변경 사항은 네이티브 파일이 제거되거나 업데이트될 때까지 활성 작업 표시줄에 반영되지 않습니다.

서비스와 로그는 다음을 통해 검사할 수 있습니다:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```
사용자용 기능은 [Taskbar](/docs/argvus-taskbar/taskbar/)]를, 설치 및 사용자 경로는 [file locations](/docs/reference/file-locations/)]를 참조하세요.

## Hyprland 작업 공간 호환성

ARGVUS 빌드는 이전의 숫자형 작업 공간 ID와 Hyprland 0.57 텍스트 작업 공간 주소를 모두 지원합니다. `id`이 없는 이름 있는 작업 공간은 작업 공간 스냅샷, 클라이언트, 모니터 및 이벤트 전반에 걸쳐 일관된 프로세스 로컬 내부 식별자를 받습니다. 이러한 식별자는 Hyprland로 전송되지 않습니다: 작업 공간 버튼은 실제 이름을 전달합니다.

`hyprland/workspaces.workspace-metadata`는 선택적으로 `$XDG_RUNTIME_DIR`에 상대적인 JSON 파일의 이름을 지정할 수 있으며, 예를 들어 `argvus/project-workspaces.json`와 같습니다. 각 작업 공간 이름은 `label` 및 `tooltip` 문자열을 가진 객체에 매핑됩니다. 라벨은 Pango 텍스트로 이스케이프되며 일치하거나 클릭 대상에는 영향을 주지 않습니다. 메타데이터가 없으면 기본 작업 공간 이름을 사용합니다. `argvus projects`는 파생된 프로젝트 메타데이터를 소유하며, 목록/언어 변경 후 프로젝트를 다시 열면 해당 메타데이터가 새로고침됩니다.

## 창 버튼 및 애플리케이션 바

두 번째 Waybar는 모든 모니터에서 나타나며, 메인 작업 표시줄과 반대편 가장자리에 위치합니다. 해당 모니터의 현재 작업 공간에 속한 창만 나열하며, 최소화된 창도 포함됩니다. 특별 작업 공간이 열려 있을 경우 우선합니다. 고정된 창은 계속 보이며, 숨겨진 그룹 탭은 추가 항목을 생성하지 않고, 최소화된 그룹에는 하나의 복구 항목이 있습니다. 애플리케이션 내부의 탭은 별도로 나열되지 않습니다. 최소화된 항목은 원래의 모니터/작업 공간 연결을 유지합니다. 비활성 창을 클릭하면 활성화되고, 활성 창을 클릭하면 최소화되며, 최소화된 창을 클릭하면 복원됩니다. 해당 창의 컨텍스트 메뉴에는 복원, 최소화, 최대화/복원 및 닫기 옵션이 있습니다. 알 수 없는 애플리케이션 아이콘은 창 기호로 대체됩니다.

`hyprland/argvus-windows` 모듈은 `argvus windows watch --json`에서 JSON 스트림을 소비합니다. GTK 업데이트는 메인 스레드에서 실행되며, 액션은 인수 배열과 검증된 창 주소를 사용합니다. 복구 준비 상태는 컴포지터 계층 목록과 비교하여 확인됩니다.
