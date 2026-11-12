---
title: Ghi đè Waybar và taskbar
description: Tùy chỉnh thanh tác vụ ARGVUS Waybar mà không cần chỉnh sửa các tệp đã đóng gói.
---

 provides the ARGVUS taskbar JSONC/CSS configuration and its helper scripts.

 provides the Waybar binary, while

 khởi động dịch vụ và chọn các tập tin hiệu quả. Bản sao được quản lý và bản sao được tạo đều được viết bởi

: it replaces the theme layer and reapplies taskbar margins,

 utility-group mode, border radius and the telemetry font block whenever themes or layout state change.

 no longer writes these files; it only commits the change and asks for a reload.

## Sự ưu tiên cấu hình

Đối với thanh tác vụ và bề mặt thu thập dữ liệu,  argvus-appearance  right-2  argvus-config  argvus-session  argvus-waybar  `argvus-taskbar`  `argvus-waybar`  `argvus-session`  `argvus-config`  `right-2`  `argvus-appearance` `argvus sessionctl` giải quyết cấu hình và bảng kiểu độc lập theo thứ tự này:

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

`$XDG_CONFIG_HOME` thay thế `~/.config` khi nó được đặt. Tệp tồn tại đầu tiên sẽ là tệp chiến thắng.

Cây được sinh ra xuất hiện **đầu tiên** nên lớp chủ đề đang hoạt động luôn thắng: một bản sao của người dùng hoặc gốc đã cũ không được giữ thanh tác vụ theo chủ đề trước đó. Hệ quả thực tế là một ghi đè `~/.config/waybar/` gốc chỉ có hiệu lực khi tệp tương ứng được tạo ra chưa tồn tại — ví dụ sau `rm -rf ~/.config/argvus/data/generated` trước lần tải lại tiếp theo, hoặc khi một tệp chưa bao giờ được chiếu. Nếu bạn muốn một ghi đè gốc bền vững tồn tại qua các thay đổi chủ đề, hãy sử dụng cây được sinh ra làm điểm khởi đầu, hoặc chấp nhận rằng lớp chủ đề sở hữu hai tệp này.

Cấu hình không được gộp: một tệp JSONC ghi đè sẽ thay thế toàn bộ cấu hình thanh tác vụ, và một tệp CSS ghi đè sẽ thay thế toàn bộ bảng kiểu.

Các giá trị mặc định đã đóng gói chỉ đọc. Không chỉnh sửa:

```text
/usr/share/argvus/taskbar/config/argvus-taskbar.jsonc
/usr/share/argvus/taskbar/config/argvus-taskbar.css
```

## Cấu hình ARGVUS được quản lý

Phiên ARGVUS bình thường sử dụng các bản sao được quản lý dưới:

```text
~/.config/argvus/data/taskbar/argvus-taskbar.jsonc
~/.config/argvus/data/taskbar/argvus-taskbar.css
```

`argvus-config` tạo lại các tệp này từ mặc định được đóng gói khi áp dụng một chủ đề, sau đó áp dụng lại trạng thái ARGVUS lâu dài như lề thanh tác vụ, chế độ nhóm tiện ích `right-2`, bán kính viền và khối phông chữ. Điều tương tự cũng áp dụng cho `data/waybar/argvus-taskbar.{jsonc,css}` và `data/waybar/argvus-widget-telemetry.{jsonc,css}`: chúng được thay thế từ mặc định được đóng gói khi thay đổi giao diện, vì vậy các chỉnh sửa thủ công ở đó cũng bị mất.

Các tệp được tạo dưới `~/.config/argvus/data/generated/waybar/` là trạng thái dẫn xuất và không nên chỉnh sửa trực tiếp; toàn bộ cây sẽ được xây dựng lại từ `config.json` vào `argvus config apply` tiếp theo. Không sử dụng `argvus --setup --copy taskbar` làm đường dẫn tùy chỉnh thanh tác vụ; trình chạy thanh tác vụ giải quyết các vị trí `data/taskbar/` chuẩn của nó ở phía trên.

## Tùy chỉnh JSONC bền vững

Để có cấu hình thanh tác vụ thủ công bền vững, hãy tạo một ghi đè Waybar gốc hoàn chỉnh:

```sh
mkdir -p ~/.config/waybar
cp /usr/share/argvus/taskbar/config/argvus-taskbar.jsonc \
  ~/.config/waybar/argvus-taskbar.jsonc
```

Chỉnh sửa bản sao trong `~/.config/waybar/`. Các thay đổi phổ biến bao gồm:

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

Ví dụ minh họa cấu trúc Waybar; giữ nguyên phần cấu hình được đóng gói khi tùy chỉnh nó. Ghi đè bản địa là một tập tin hoàn chỉnh, không phải một mảnh JSONC từng phần. Giữ các mô-đun và tập lệnh mà desktop ARGVUS yêu cầu nếu bạn muốn các hành động trên thanh tác vụ hiện tại tiếp tục hoạt động.

## Tùy chỉnh CSS bền vững

Bảng kiểu đóng gói nhập các màu sắc của nó từ bản dựng chủ đề đang hoạt động. Nếu bạn ghi đè CSS, hãy trỏ việc nhập chủ đề đến bản dựng, đường dẫn của nó vẫn giữ nguyên khi chuyển đổi chủ đề:

```sh
cp /usr/share/argvus/taskbar/config/argvus-taskbar.css \
  ~/.config/waybar/argvus-taskbar.css
sed -i '1s|.*|@import url("'"$HOME"'/.config/argvus/data/generated/theme/current/taskbar/theme.css");|' \
  ~/.config/waybar/argvus-taskbar.css
```

Các tệp CSS và chủ đề gốc trở thành tài sản thuộc sở hữu người dùng. Thay đổi chủ đề sẽ không tự động tái tạo chúng; hãy cập nhật chúng một cách có chủ ý khi ARGVUS thêm hoặc thay đổi tài nguyên chủ đề.

## Áp dụng các thay đổi và kiểm tra tệp hiệu quả

Khởi động lại chỉ thanh tác vụ sau khi thay đổi JSONC hoặc CSS của nó:

```sh
argvus sessionctl restart waybar
```

Để làm mới toàn bộ phiên/cấu hình, sử dụng:

```sh
argvus sessionctl reload
```

Để xem các tệp mà tiến trình Waybar đang chạy thực sự sử dụng:

```sh
pgrep -af 'waybar.*argvus-taskbar'
```

Quá trình nên hiển thị `-c` cho tệp JSONC hiệu lực và `-s` cho tệp CSS hiệu lực. Nếu có một tệp gốc, các thay đổi đối với bản sao ARGVUS được quản lý sẽ không thay đổi thanh tác vụ đang hoạt động cho đến khi tệp gốc được xóa hoặc cập nhật.

Dịch vụ và nhật ký có thể được kiểm tra với:

```sh
systemctl --user status argvus-taskbar.service
journalctl --user -u argvus-taskbar.service -n 50 --no-pager
```

Xem Thanh tác vụ để biết các tính năng hướng tới người dùng và vị trí tệp cho đường dẫn người dùng và cài đặt.

## Tương thích workspace Hyprland

Bản dựng ARGVUS chấp nhận cả ID workspace số kiểu cũ lẫn địa chỉ workspace dạng văn bản của Hyprland 0.57. Các workspace được đặt tên mà không có `id` nhận các định danh nội bộ cục bộ quy trình một cách nhất quán trên các bản chụp workspace, client, màn hình và sự kiện. Những định danh này không bao giờ được gửi tới Hyprland: các nút workspace gửi tên thật.

`hyprland/workspaces.workspace-metadata` tùy chọn đặt tên cho một tệp JSON liên quan đến `$XDG_RUNTIME_DIR`, chẳng hạn như `argvus/project-workspaces.json`. Mỗi tên không gian làm việc ánh xạ tới một đối tượng với chuỗi `label` và `tooltip`. Nhãn được thoát dưới dạng văn bản Pango và không thay đổi một khớp hoặc mục tiêu nhấp chuột. Siêu dữ liệu bị thiếu sẽ trở về tên không gian làm việc gốc. `argvus projects` argvus windows watch --json  `hyprland/argvus-windows` `argvus windows watch --json`   sở hữu siêu dữ liệu dự án được dẫn xuất; mở lại dự án sau khi thay đổi danh sách/ngôn ngữ để làm mới nó.


##

Một Waybar thứ hai xuất hiện trên mỗi màn hình, ở cạnh đối diện với thanh tác vụ chính. Nó chỉ liệt kê các cửa sổ thuộc không gian làm việc hiện tại của màn hình đó, bao gồm cả các cửa sổ đã thu nhỏ từ không gian làm việc đó. Một không gian làm việc đặc biệt đang mở sẽ được ưu tiên. Các cửa sổ ghim vẫn hiển thị; các tab nhóm bị ẩn sẽ không tạo mục bổ sung, và một nhóm thu nhỏ chỉ có một mục khôi phục. Các tab bên trong một ứng dụng không được liệt kê riêng. Các mục thu nhỏ vẫn giữ liên kết với màn hình/không gian làm việc gốc. Nhấp vào một cửa sổ không hoạt động để kích hoạt nó, cửa sổ đang hoạt động để thu nhỏ nó, hoặc cửa sổ đã thu nhỏ để khôi phục; menu ngữ cảnh của nó cung cấp các tùy chọn khôi phục, thu nhỏ, phóng to/khôi phục và đóng. Biểu tượng ứng dụng không xác định sẽ dùng ký hiệu cửa sổ thay thế.

The

 module consumes a JSON stream from

. GTK các bản cập nhật chạy trên luồng chính; hành động sử dụng mảng đối số và địa chỉ cửa sổ được xác thực. Sự sẵn sàng phục hồi được xác nhận dựa trên danh sách lớp tổng hợp.

Xem[Thanh tác vụ](/docs/argvus-taskbar/taskbar/)cho các tính năng hướng tới người dùng và[vị trí tệp](/docs/reference/file-locations/)cho các đường dẫn đã cài đặt và người dùng.
