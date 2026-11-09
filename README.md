# Course Registration – Quản lý trạng thái với Provider & ChangeNotifier

Ứng dụng mẫu **Đăng ký học phần (Course Registration)** được xây dựng bằng **Flutter (Material 3)** cho môn học **Lập trình đa nền tảng**, nhằm minh họa trực quan và chuyên sâu về chủ đề **"Quản lý trạng thái (State Management) với Provider và ChangeNotifier"**.

---

## 👥 Thành viên nhóm & Phân công nhiệm vụ

| Thành viên | Vai trò & Nhiệm vụ thực hiện | Nhánh Git |
| :--- | :--- | :--- |
| **Đặng Công Thắng** | • Thiết kế kiến trúc tổng thể, model (`Course`), danh mục học phần (`courseCatalog`).<br>• Cài đặt logic nghiệp vụ & quản lý state trung tâm (`RegistrationNotifier`).<br>• Xây dựng màn chính (`CourseListScreen`), màn học phần đã đăng ký (`RegisteredScreen`).<br>• Tách các widget thành phần (`CourseTile`, `CreditBadge`, `SummaryBar`).<br>• Bảng điều khiển demo (`DemoPanel`, `_NotifyLog`) & hoàn thiện `README.md`. | `thang` |
| **Thái** | • Xây dựng màn hình thực nghiệm chuyên sâu **Provider Lab** (`ProviderLabScreen`).<br>• Cài đặt `LabNotifier` và bộ theo dõi rebuild trực quan (`RebuildTracker`).<br>• Trực quan hóa so sánh số lần rebuild: `setState`, `context.watch`, `Consumer`, `context.select`, `context.read` qua chip `Build: n`. | `thai` |

---

## 📌 Bảng tra cứu: Khái niệm → Vị trí trong Code

| Khái niệm / Kỹ thuật | File nguồn | Mô tả & Mục đích sử dụng trong dự án |
| :--- | :--- | :--- |
| **ChangeNotifier & notifyListeners()** | `lib/notifiers/registration_notifier.dart` | Lớp quản lý trạng thái kế thừa `ChangeNotifier`. Mọi logic nghiệp vụ (kiểm tra 14–24 TC, chống trùng môn) nằm tại đây. Chỉ gọi `notifyListeners()` khi state thật sự thay đổi. |
| **ChangeNotifierProvider (Toàn cục)** | `lib/main.dart` | Bọc ngoài cùng quanh `MaterialApp` để cung cấp thể hiện duy nhất của `RegistrationNotifier` cho tất cả các màn hình (`CourseListScreen`, `RegisteredScreen`). |
| **ChangeNotifierProvider (Cục bộ)** | `lib/lab/provider_lab_screen.dart` | Bọc riêng cho màn hình Lab với `LabNotifier`. State tự động giải phóng (`dispose()`) khi người dùng thoát khỏi màn hình (pop Navigator). |
| **context.watch** | `lib/widgets/credit_badge.dart`<br>`lib/views/registered_screen.dart` | Đăng ký widget làm listener; tự động kích hoạt rebuild toàn bộ widget khi `notifyListeners()` được gọi (dùng cho badge tín chỉ trên AppBar và danh sách đã đăng ký). |
| **Consumer** | `lib/widgets/summary_bar.dart`<br>`lib/lab/provider_lab_screen.dart` | Lắng nghe thay đổi nhưng cô lập phạm vi rebuild chỉ trong hàm `builder`, tối ưu hiệu năng render giao diện. |
| **context.select** | `lib/widgets/course_tile.dart`<br>`lib/lab/provider_lab_screen.dart` | Chỉ lắng nghe một phần dữ liệu cụ thể (`isRegistered(id)`). Widget chỉ rebuild khi giá trị được chọn thay đổi, bỏ qua các thay đổi khác. |
| **context.read** | Các nút bấm trong `CourseTile`, `RegisteredScreen`, `DemoPanel`, `ProviderLabScreen` | Truy xuất Notifier để gọi phương thức thực thi (`register`, `unregister`, `clearAll`) mà KHÔNG đăng ký lắng nghe rebuild. |
| **addListener & removeListener** | `lib/widgets/demo_panel.dart` (`_NotifyLog`) | Minh họa cơ chế nền tảng của `ChangeNotifier`. Provider thực chất sử dụng cơ chế `addListener` này bên dưới để kích hoạt widget rebuild. |
| **Tách biệt UI / State / Nghiệp vụ** | • UI: `lib/views/`, `lib/widgets/`<br>• State & Logic: `lib/notifiers/`<br>• Data & Model: `lib/models/`, `lib/data/` | Áp dụng Separation of Concerns: Widget hoàn toàn không chứa logic tính toán tín chỉ hay kiểm tra điều kiện; mọi tính toán do Notifier đảm nhiệm. |

---

## 📂 Cấu trúc thư mục `lib/`

```text
lib/
├── data/
│   └── course_catalog.dart             # Danh mục 10 học phần mẫu ĐH Bách Khoa (2–4 tín chỉ, tổng 30 TC)
├── lab/
│   ├── lab_notifier.dart               # Notifier riêng phục vụ thực nghiệm đo đếm rebuild
│   ├── provider_lab_screen.dart        # Màn hình so sánh trực quan setState vs các cách dùng Provider
│   └── rebuild_tracker.dart            # Tiện ích đếm số lần hàm build() được gọi
├── models/
│   └── course.dart                     # Model học phần (id, code, name, credits, lecturer - immutable)
├── notifiers/
│   └── registration_notifier.dart      # Quản lý danh sách đăng ký, tổng tín chỉ (min 14, max 24), trạng thái
├── views/
│   ├── course_list_screen.dart         # Màn hình chính danh sách học phần kèm DemoPanel
│   └── registered_screen.dart          # Màn hình danh sách học phần đã đăng ký (đồng bộ 2 chiều)
├── widgets/
│   ├── course_tile.dart                # Thẻ từng môn học (context.select theo dõi trạng thái, context.read xử lý nút)
│   ├── credit_badge.dart               # Huy hiệu tổng tín chỉ trên AppBar (context.watch)
│   ├── demo_panel.dart                 # Bảng điều khiển kịch bản demo + Nhật ký notifyListeners (addListener)
│   └── summary_bar.dart                # Thanh tiến độ và trạng thái ở chân màn hình (Consumer)
└── main.dart                           # Điểm khởi chạy app, bọc ChangeNotifierProvider toàn cục
```

---

## 🚀 Hướng dẫn cài đặt & Chạy ứng dụng

### 1. Cài đặt thư viện dependencies:
```bash
flutter pub get
```

### 2. Chạy ứng dụng:
- Trên thiết bị Android (hoặc giả lập Android):
  ```bash
  flutter run
  ```
- Hoặc chạy thử nghiệm trên Windows / Chrome:
  ```bash
  flutter run -d windows
  # hoặc
  flutter run -d chrome
  ```

### 3. Chạy toàn bộ Unit & Widget Tests:
```bash
flutter test
```
*(Tất cả 6 bài test về khởi tạo state, đăng ký thành công, chặn đăng ký trùng môn, chặn vượt 24 TC, hủy môn và render widget đều đã vượt qua 100%).*

---

## 🎬 Kịch bản Demo từng bước (Dành cho thuyết trình)

### Bước 1: Trải nghiệm tương tác đa chiều ở màn hình chính
1. Nhấn nút **Đăng ký** ở một môn học bất kỳ (ví dụ: *Lập trình đa nền tảng - 3 TC*).
2. Quan sát sự thay đổi đồng thời tại 3 vị trí trên giao diện:
   - **`CreditBadge`** trên AppBar nhảy từ `0/24 TC` lên `3/24 TC` (dùng `context.watch`).
   - Thẻ môn học vừa chọn đổi trạng thái sang *"Đã chọn"*, nút bấm đổi thành *"Hủy môn"* (dùng `context.select`).
   - **`SummaryBar`** ở chân màn hình tăng thanh tiến độ và hiển thị số tín chỉ còn thiếu để đạt tối thiểu (dùng `Consumer`).

### Bước 2: Đồng bộ trạng thái liên màn hình
1. Bấm vào biểu tượng **Học phần đã đăng ký** (`Icons.assignment_turned_in_outlined`) trên AppBar.
2. Màn hình `RegisteredScreen` hiển thị danh sách các môn đã chọn.
3. Nhấn biểu tượng thùng rác để hủy 1 môn.
4. Nhấn nút Back quay lại màn hình chính: Số tín chỉ trên AppBar, trạng thái nút trong danh sách và thanh tiến độ ở màn hình chính đều tự động giảm tương ứng (chứng minh việc dùng chung 1 instance State duy nhất).

### Bước 3: Sử dụng "Bảng điều khiển demo" (DemoPanel)
Mở thẻ **Bảng điều khiển demo** ở đầu danh sách môn học:
- **Bấm "Đăng ký đủ tối thiểu":** Hệ thống tự động chọn các môn cho đến khi tổng tín chỉ đạt $\ge 14\text{ TC}$. Thanh tiến độ và huy hiệu chuyển sang màu xanh lá (*Hợp lệ*), khu vực nhật ký bên dưới ghi nhận các lượt notify.
- **Bấm "Thử vượt giới hạn":** Hệ thống liên tục đăng ký cho đến khi vượt quá $24\text{ TC}$, xuất hiện `SnackBar` cảnh báo màu đỏ: *"Không thể đăng ký: Tổng tín chỉ sẽ vượt quá giới hạn tối đa (24 tín chỉ)!"*.
- **Bấm "Thử đăng ký trùng":** Hệ thống cố ý gọi `register` lại môn đã đăng ký:
  - Một `SnackBar` màu cam hiện lên báo lỗi trùng môn.
  - **Quan sát khu Nhật ký notifyListeners:** Bộ đếm và danh sách nhật ký **hoàn toàn không tăng thêm dòng mới**. Điều này chứng minh trực quan rằng `RegistrationNotifier` chỉ gọi `notifyListeners()` khi state thật sự biến đổi.
- **Bấm "Hủy tất cả":** Reset toàn bộ danh sách đăng ký về `0 TC`.

### Bước 4: Khám phá "Provider Lab" (Trực quan hóa Rebuild)
1. Bấm biểu tượng kính lúp / ống nghiệm (`Icons.science_outlined`) trên AppBar để mở **Provider Lab**.
2. Thử nghiệm so sánh 5 cách quản lý và đọc state:
   - **Cách 1 - `setState()` truyền thống:** Bấm tăng số đếm $\rightarrow$ Cả màn hình cha và mọi con đều tăng chip `Build: n`.
   - **Cách 2 - `context.watch()`:** Khi dữ liệu thay đổi $\rightarrow$ Toàn bộ widget chứa `context.watch` bị rebuild.
   - **Cách 3 - `Consumer`:** Chỉ duy nhất khối nằm trong hàm `builder` của `Consumer` tăng số lần build, phần còn lại giữ nguyên.
   - **Cách 4 - `context.select()`:** Thay đổi các trường dữ liệu khác không làm widget rebuild; chỉ khi trường dữ liệu được chọn thay đổi thì chip mới tăng.
   - **Cách 5 - `context.read()`:** Bấm gọi hàm thoải mái $\rightarrow$ Chip `Build: 1` giữ nguyên vĩnh viễn, không bao giờ rebuild.
