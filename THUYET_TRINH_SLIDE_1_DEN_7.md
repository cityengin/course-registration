# GIÁO ÁN SLIDE BÀI GIẢNG & LỜI THOẠI THUYẾT TRÌNH CHI TIẾT (SLIDE 1 -> 7)
**Chuyên đề:** Quản lý trạng thái với Provider và ChangeNotifier trong Flutter  
**Dự án thực tế:** Course Registration & Phòng thí nghiệm Provider Lab  
**Học phần:** Lập trình đa nền tảng – Trường Đại học Bách khoa, Đại học Đà Nẵng  
**Giảng viên hướng dẫn:** TS. Nguyễn Duy Nhật Viễn  
**Sinh viên thực hiện:**  
- Đặng Công Thắng (MSSV: 106230061 – Lớp 23KTMT2)  
- Võ Văn Thái (MSSV: 106230027 – Lớp 23KTMT1)  

---

## 📌 BỐI CẢNH VÀ MỤC TIÊU CỦA 7 SLIDE ĐẦU TIÊN
- **Mục tiêu:** Cung cấp nền tảng lý thuyết từ mức cơ bản nhất (State là gì, tại sao `setState` bộc lộ hạn chế khi dự án mở rộng, kiến trúc phân lớp, luồng dữ liệu 1 chiều) cho đến cách tổ chức State trong mã nguồn thực tế (`RegistrationNotifier`, `ChangeNotifierProvider` toàn cục/cục bộ và 4 phương thức đọc State trong Provider).
- **Đối tượng người nghe:** Giảng viên và các bạn sinh viên trong lớp Lập trình đa nền tảng.
- **Phong thái thuyết trình:** Tự tin, rõ ràng, gãy gọn, nhấn mạnh tư duy kiến trúc sạch (Clean Architecture) và tối ưu hóa hiệu năng render (Rebuild Optimization).

---

# SLIDE 1: TRANG TIÊU ĐỀ & GIỚI THIỆU CHUYÊN ĐỀ

### 🖥️ Nội dung hiển thị trên Slide
- **Tiêu đề chính:** Quản lý trạng thái với Provider và ChangeNotifier trong Flutter
- **Tiêu đề phụ:** Ứng dụng thực tế *Course Registration* & Phòng thí nghiệm *Provider Lab*
- **Học phần:** Chuyên đề · Môn Lập trình đa nền tảng
- **Giảng viên hướng dẫn:** TS. Nguyễn Duy Nhật Viễn
- **Nhóm sinh viên thực hiện:**
  - Đặng Công Thắng – Lớp 23KTMT2 – MSSV: 106230061
  - Võ Văn Thái – Lớp 23KTMT1 – MSSV: 106230027
- **Đơn vị:** Khoa Điện tử Viễn thông – Trường Đại học Bách khoa, Đại học Đà Nẵng
- **Mã nguồn công khai:** `github.com/cityengin/course-registration`

---

### 🎙️ Lời thoại thuyết trình (Speaker Notes)
> *"Kính thưa thầy Nguyễn Duy Nhật Viễn cùng toàn thể các bạn sinh viên đang có mặt trong buổi báo cáo ngày hôm nay!*
>
> *Em tên là **Đặng Công Thắng**, đại diện nhóm gồm em và bạn **Võ Văn Thái**, xin phép được trình bày chuyên đề nghiên cứu và thực nghiệm của nhóm với đề tài:*
> **'Quản lý trạng thái với Provider và ChangeNotifier trong Flutter'**, thông qua sản phẩm thực tế là ứng dụng **Đăng ký học phần – Course Registration** và phòng thí nghiệm đo lường hiệu năng **Provider Lab**.
>
> *Thưa thầy và các bạn, khi bắt đầu làm quen với Flutter, hầu hết chúng ta đều đã quen thuộc với việc tạo ra các giao diện người dùng đẹp mắt. Tuy nhiên, khi một ứng dụng phát triển từ một màn hình đơn giản thành một hệ thống thực tế với hàng chục màn hình, luồng dữ liệu đan xen, thì câu hỏi lớn nhất luôn đặt ra là: **Làm thế nào để các thành phần giao diện khác nhau có thể chia sẻ dữ liệu một cách nhất quán, dễ bảo trì và đạt hiệu năng tối ưu nhất?** Đó chính là bài toán về **Quản lý trạng thái (State Management)**.*
>
> *Toàn bộ mã nguồn dự án của nhóm đã được đưa lên GitHub công khai tại địa chỉ `github.com/cityengin/course-registration`. Ngay sau đây, em xin phép bắt đầu phần báo cáo của nhóm."*

---

# SLIDE 2: PHÂN CÔNG NHIỆM VỤ & TINH THẦN CỘNG TÁC

### 🖥️ Nội dung hiển thị trên Slide
- **Đặng Công Thắng (52%):**
  - Thiết kế kiến trúc tổng thể, Model `Course`, danh mục 10 học phần mẫu ĐHBK.
  - Cài đặt `RegistrationNotifier` (logic nghiệp vụ: kiểm soát 14–24 tín chỉ, ngăn trùng lặp).
  - Xây dựng 2 màn hình nghiệp vụ chính (`CourseListScreen`, `RegisteredScreen`) + 3 widget thành phần (`CourseTile`, `CreditBadge`, `SummaryBar`).
  - Thiết kế bảng điều khiển kịch bản demo (`DemoPanel`), bộ kiểm thử tự động, slide báo cáo.
- **Võ Văn Thái (48%):**
  - Nghiên cứu và xây dựng màn hình thực nghiệm **Provider Lab** (`ProviderLabScreen`).
  - Cài đặt `LabNotifier` (ứng dụng Provider ở phạm vi cục bộ - scoped provider).
  - Phát triển bộ theo dõi vòng đời rebuild trực quan (`RebuildTracker` + `BuildCountChip`).
  - Thực nghiệm so sánh số lần rebuild thực tế giữa `setState` và 4 kỹ thuật đọc State trong Provider.

---

### 🎙️ Lời thoại thuyết trình (Speaker Notes)
> *[Chuyển slide, mỉm cười nhẹ]*
>
> *"Ở slide thứ 2, em xin tóm lược bảng phân công công việc của nhóm:*
>
> *Để đề tài không chỉ dừng lại ở lý thuyết suông mà có cả sản phẩm hoàn chỉnh lẫn công cụ chứng minh khoa học, nhóm em đã phân chia hai mảng nhiệm vụ tương hỗ rất rõ ràng:*
>
> - *Về phía em - **Đặng Công Thắng**, em đảm nhiệm việc thiết kế kiến trúc tổng thể, mô hình dữ liệu, xây dựng Notifier trung tâm quản lý logic nghiệp vụ đăng ký tín chỉ từ 14 đến 24 tín chỉ, hoàn thiện 2 màn hình chính của ứng dụng và các kịch bản demo kiểm thử tự động.*
> - *Về phía bạn **Võ Văn Thái**, bạn Thái tập trung vào việc hiện thực hóa phòng thí nghiệm **Provider Lab**. Đây là một môi trường thực nghiệm độc lập được bạn thiết kế nhằm đo đếm chính xác số lần hàm `build()` của từng widget được gọi, từ đó so sánh trực quan giữa `setState` truyền thống với 4 cách đọc dữ liệu khác nhau của Provider.*
>
> *Hai phần việc này bổ trợ cho nhau: Một bên là **ứng dụng thực tiễn**, và một bên là **thực nghiệm khoa học đo lường**. Tổng tỷ trọng đóng góp của hai thành viên là 52% và 48%, thể hiện tinh thần làm việc nhóm nghiêm túc và đồng đều trong suốt quá trình thực hiện."*

---

# SLIDE 3: TỔNG QUAN ĐỀ TÀI VÀ KIẾN TRÚC GIẢI PHÁP

### 🖥️ Nội dung hiển thị trên Slide
- **Vấn đề cốt lõi (The Problem):**
  - Cùng một dữ liệu (ví dụ: danh sách môn đã chọn, tổng số tín chỉ) cần hiển thị và phản hồi tại **4 vị trí khác nhau** trên giao diện.
  - Nếu chỉ dùng `setState()`: Dữ liệu và hàm callback phải truyền qua nhiều tầng widget trung gian (**Prop Drilling**), và mỗi lần cập nhật buộc phải vẽ lại cả cây widget (**Over-rebuilding**), gây lãng phí tài nguyên CPU/GPU.
- **Kiến trúc giải pháp gồm 3 khối module chính:**
  1. **Course Registration (Ứng dụng cốt lõi):** 10 học phần mẫu (2–4 TC), ràng buộc nghiệp vụ 14–24 tín chỉ, đồng bộ dữ liệu thời gian thực giữa 2 màn hình.
  2. **Demo Panel (Bảng tương tác kịch bản):** 4 kịch bản thao tác nhanh, trực quan hóa nhật ký `notifyListeners()`, chứng minh nguyên tắc *chỉ notify khi dữ liệu thật sự thay đổi*.
  3. **Provider Lab (Phòng thí nghiệm thực nghiệm):** Đối đầu trực tiếp `setState` vs Provider, so sánh 4 cách đọc State qua chip hiển thị số lần render `Build: n`.
- **Nền tảng kỹ thuật:** Flutter (Material 3) · `provider: ^6.1.5` · Bộ kiểm thử tự động 7 test (5 unit test + 2 widget test đạt 100%).

---

### 🎙️ Lời thoại thuyết trình (Speaker Notes)
> *"Thưa thầy và các bạn, để hiểu tại sao nhóm lại chọn Provider, chúng ta hãy bắt đầu từ **vấn đề căn bản nhất trong lập trình Flutter**:*
>
> *Hãy hình dung một bài toán hết sức quen thuộc: Sinh viên bấm vào nút 'Đăng ký' của môn 'Lập trình đa nền tảng'. Ngay lập tức:*
> 1. *Huy hiệu tín chỉ trên thanh AppBar góc trên phải nhảy số.*
> 2. *Thẻ môn học đó phải đổi sang màu xanh với nút 'Hủy môn'.*
> 3. *Thanh tiến độ dưới chân màn hình phải tăng lên.*
> 4. *Nếu chuyển sang màn hình danh sách môn đã chọn, môn đó cũng phải xuất hiện ngay lập tức.*
>
> *Nếu chỉ sử dụng giải pháp mặc định sơ khai là `setState()`:*
> - *Thứ nhất, ta gặp phải hiện tượng **Prop Drilling**: Widget cha ở trên cùng phải giữ biến State, sau đó chuyền biến và callback qua 4–5 tầng widget con cháu trung gian. Những widget ở giữa hoàn toàn không cần dữ liệu đó nhưng vẫn phải 'cõng' tham số giùm.*
> - *Thứ hai, là vấn đề **Rebuild diện rộng (Over-rebuilding)**: Khi gọi `setState()` ở widget cha, toàn bộ cây widget con cháu bên dưới bị ép vẽ lại từ đầu, dù có những thành phần hoàn toàn tĩnh không hề thay đổi. Điều này gây giật lag (frame drop) trên các thiết bị di động cấu hình yếu.*
>
> *Để giải quyết triệt để vấn đề này, nhóm em đã xây dựng một giải pháp hoàn chỉnh gồm 3 khối:*
> - *Thứ nhất là **Ứng dụng đăng ký học phần** chuẩn nghiệp vụ tín chỉ Đại học Bách khoa.*
> - *Thứ hai là **Bảng Demo Panel** giúp quan sát được từng xung nhịp phát ra của State.*
> - *Và thứ ba là **Phòng thí nghiệm Provider Lab** chứng minh bằng số liệu đếm số lần rebuild thực tế.*
> *Dự án được bảo chứng bằng 7 bài test tự động bao phủ toàn bộ logic, đảm bảo tính đúng đắn tuyệt đối."*

---

# SLIDE 4: KIẾN TRÚC PHÂN LỚP VÀ LUỒNG DỮ LIỆU MỘT CHIỀU

### 🖥️ Nội dung hiển thị trên Slide
- **Nguyên lý luồng dữ liệu một chiều (Unidirectional Data Flow):**
  $$\text{Sự kiện từ UI} \xrightarrow{\text{context.read}} \text{Notifier xử lý} \xrightarrow{\text{notifyListeners()}} \text{Widgets lắng nghe tự động Rebuild}$$
- **Phân tách trách nhiệm 3 lớp (Separation of Concerns):**
  1. **Lớp Giao diện (UI Layer - `lib/views/`, `lib/widgets/`):** Chỉ chịu trách nhiệm hiển thị giao diện và phát sinh sự kiện (User Interactions). Tuyệt đối không nhúng logic tính toán.
  2. **Lớp Quản lý trạng thái (State Layer - `lib/notifiers/`):** Nơi chứa toàn bộ nghiệp vụ (Business Logic). Quản lý dữ liệu sống và chủ động quyết định thời điểm phát tín hiệu `notifyListeners()`.
  3. **Lớp Dữ liệu (Data Layer - `lib/models/`, `lib/data/`):** Định nghĩa cấu trúc Model bất biến (`Course`) và danh mục dữ liệu gốc.
- **Cầu nối trung gian:** `ChangeNotifierProvider` bọc ngoài `MaterialApp` tại `main.dart`, đóng vai trò là kho chứa và phân phối State xuống toàn bộ cây widget.

---

### 🎙️ Lời thoại thuyết trình (Speaker Notes)
> *[Chỉ tay vào sơ đồ luồng dữ liệu trên slide]*
>
> *"Ở slide 4, em xin kính mời thầy và các bạn cùng quan sát linh hồn kiến trúc của ứng dụng: **Mô hình phân lớp và Luồng dữ liệu một chiều**.*
>
> *Trong phát triển phần mềm chuyên nghiệp, nguyên tắc sống còn là **Separation of Concerns – Tách biệt trách nhiệm**:*
> - *Bên tay trái là **Lớp Giao diện (UI)**: Các widget như `CourseTile`, nút bấm chỉ làm đúng một việc: lắng nghe thao tác chạm của người dùng. Khi người dùng bấm 'Đăng ký', widget không tự ý tăng biến đếm, mà chỉ dùng lệnh `context.read` để gửi một thông điệp yêu cầu Notifier xử lý.*
> - *Ở trung tâm là **RegistrationNotifier**: Đây là 'bộ não' của ứng dụng. Tại đây, Notifier tiếp nhận yêu cầu, kiểm tra xem đã đủ điều kiện chưa (có trùng môn không, có vượt quá 24 tín chỉ không). Nếu hợp lệ, Notifier cập nhật danh sách và bắn ra một sự kiện thông báo: `notifyListeners()`.*
> - *Ngay khi tín hiệu này phát ra, **ChangeNotifierProvider** sẽ lập tức đánh thức các widget con ở bên phải đang đăng ký lắng nghe nó:*
>   - *`CreditBadge` trên AppBar dùng `watch` sẽ cập nhật lại số tín chỉ.*
>   - *Chỉ riêng `CourseTile` của môn đó dùng `select` mới vẽ lại trạng thái của mình.*
>   - *`SummaryBar` dùng `Consumer` sẽ vẽ lại thanh tiến độ.*
>
> *Dữ liệu đi theo một vòng khép kín duy nhất một chiều: **UI phát sinh hành động $\rightarrow$ State biến đổi $\rightarrow$ UI cập nhật**. Không có bất kỳ sự thay đổi ngầm nào từ bên ngoài, giúp mã nguồn vô cùng trong sáng và dễ dàng gỡ lỗi (debug)."*

---

# SLIDE 5: REGISTRATIONNOTIFIER – CHANGENOTIFIER CHỨA TOÀN BỘ NGHIỆP VỤ

### 🖥️ Nội dung hiển thị trên Slide
- **Bốn nguyên tắc thiết kế State chuẩn mực trong `RegistrationNotifier`:**
  1. **Đóng gói bảo vệ (Encapsulation):** Biến `_registered` được đặt ở phạm vi `private`. Bên ngoài chỉ có thể đọc qua getter `List.unmodifiable(_registered)`, ngăn chặn việc can thiệp trái phép (`.add()` ngoài ý muốn).
  2. **Trạng thái dẫn xuất (Derived State):** `totalCredits` và `status` không lưu biến độc lập mà được tính tức thì từ danh sách bằng toán tử `fold()`, đảm bảo nguyên tắc **Single Source of Truth** (không bao giờ xảy ra lệch dữ liệu).
  3. **Ràng buộc nghiệp vụ chặt chẽ:** Tối thiểu 14 tín chỉ, tối đa 24 tín chỉ, kiểm tra chống trùng lặp môn học bằng `isRegistered(course.id)`.
  4. **Notify có điều kiện (Conditional Notification):** Khi gặp lỗi (trùng môn, quá 24 TC), hàm `register()` lập tức `return String?` báo lỗi và **TUYỆT ĐỐI KHÔNG GỌI `notifyListeners()`**, bảo vệ ứng dụng khỏi những lần rebuild lãng phí.
- **Trích đoạn mã nguồn (`lib/notifiers/registration_notifier.dart`):**
  ```dart
  class RegistrationNotifier extends ChangeNotifier {
    final List<Course> _registered = [];
    List<Course> get registered => List.unmodifiable(_registered);
    int get totalCredits => _registered.fold(0, (sum, c) => sum + c.credits);

    String? register(Course course) {
      if (isRegistered(course.id)) return 'Đã đăng ký!';
      if (totalCredits + course.credits > maxCredits) return 'Vượt quá 24 TC!';
      _registered.add(course);
      notifyListeners(); // CHỈ THÔNG BÁO KHI STATE THẬT SỰ ĐỔI!
      return null;
    }
  }
  ```

---

### 🎙️ Lời thoại thuyết trình (Speaker Notes)
> *"Đi sâu vào chi tiết cài đặt của bộ não ứng dụng ở Slide 5: `RegistrationNotifier` kế thừa từ `ChangeNotifier` của Flutter Foundation.*
>
> *Ở đây, nhóm em tuân thủ nghiêm ngặt 4 nguyên tắc kỹ thuật mà mọi kỹ sư phần mềm đều cần chú trọng:*
>
> *1. **Thứ nhất là Tính đóng gói:** Danh sách `_registered` có dấu gạch dưới, tức là hoàn toàn private. Nếu từ màn hình giao diện mà gõ `notifier._registered.clear()` hay `.add()` thì trình biên dịch sẽ báo lỗi ngay. Muốn đọc danh sách, bên ngoài chỉ có thể truy cập qua getter `List.unmodifiable`. Điều này đảm bảo dữ liệu không bao giờ bị sửa đổi tùy tiện từ bên ngoài.*
>
> *2. **Thứ hai là Trạng thái dẫn xuất (Derived State):** Nhiều bạn khi mới học thường tạo thêm một biến `int totalCredits = 0;` rồi mỗi lần thêm môn lại cộng dồn thủ công. Cách làm đó rất dễ gây ra lỗi không đồng bộ dữ liệu. Ở đây, `totalCredits` là một getter sử dụng hàm `fold()`, tính toán trực tiếp từ danh sách học phần hiện có. Danh sách là nguồn chân lý duy nhất (Single Source of Truth).*
>
> *3. **Thứ ba là Ràng buộc nghiệp vụ tín chỉ:** Mọi quy chế đào tạo về tín chỉ tối thiểu 14, tối đa 24 đều được kiểm soát tập trung tại đây.*
>
> *4. **Và đặc biệt nhất là nguyên tắc: Notify có điều kiện:***
> *Các bạn hãy nhìn vào đoạn code: Nếu sinh viên cố tình bấm đăng ký một môn đã có rồi, hoặc nếu cộng thêm môn này mà vượt quá 24 tín chỉ, hàm sẽ trả về ngay chuỗi cảnh báo lỗi và thoát ra. **Tuyệt đối không gọi `notifyListeners()`!** Nhờ vậy, không một widget nào trên giao diện bị kích hoạt rebuild thừa thãi. Đây chính là bí quyết giúp tối ưu hóa hiệu năng ứng dụng ngay từ tầng logic."*

---

# SLIDE 6: CUNG CẤP STATE – CHANGENOTIFIERPROVIDER TOÀN CỤC VÀ CỤC BỘ

### 🖥️ Nội dung hiển thị trên Slide
- **Vai trò của `ChangeNotifierProvider`:**
  - Khởi tạo và quản lý vòng đời của một `ChangeNotifier`.
  - Đưa instance Notifier xuống cây widget thông qua cơ chế `InheritedWidget`.
  - Tự động gọi phương thức `dispose()` khi widget bị hủy để giải phóng bộ nhớ, chống memory leak.
- **Bảng so sánh đối chiếu:**

| Tiêu chí | Toàn cục / Global (`main.dart`) | Cục bộ / Scoped (`provider_lab_screen.dart`) |
| :--- | :--- | :--- |
| **Vị trí bọc** | Bọc ngoài cùng quanh `MaterialApp` | Bọc riêng bên trong màn hình `ProviderLabScreen` |
| **Instance Notifier** | `RegistrationNotifier()` | `LabNotifier()` |
| **Phạm vi truy cập** | Mọi màn hình: `CourseListScreen`, `RegisteredScreen` | Chỉ các widget con bên trong màn hình Provider Lab |
| **Vòng đời (Lifecycle)** | Sống suốt thời gian ứng dụng chạy | Sinh ra khi vào Lab $\rightarrow$ Tự động `dispose()` khi thoát ra (Pop) |
| **Mục đích** | Dữ liệu nghiệp vụ chung cần đồng bộ xuyên suốt | Phục vụ đo đạc thực nghiệm, cô lập hoàn toàn khỏi dữ liệu thật |

---

### 🎙️ Lời thoại thuyết trình (Speaker Notes)
> *"Sau khi đã xây dựng xong Notifier, câu hỏi tiếp theo là: **Làm sao để các Widget trên cây giao diện có thể tiếp cận được Notifier này?** Câu trả lời nằm ở `ChangeNotifierProvider` tại Slide 6.*
>
> *Trong dự án này, nhóm em áp dụng cả hai mô hình cung cấp State tùy theo mục đích:*
>
> *1. **Thứ nhất là Provider Toàn cục (Global):** Được khai báo tại `main.dart`, bọc ngay bên ngoài `MaterialApp`. Tại sao phải bọc cao nhất như vậy? Bởi vì dữ liệu đăng ký học phần cần được chia sẻ giữa nhiều màn hình khác nhau: Màn hình danh sách môn học và Màn hình các học phần đã đăng ký. Khi người dùng chuyển qua lại giữa các màn hình qua Navigator, cả hai màn hình đều đang cùng nhìn vào một instance `RegistrationNotifier` duy nhất.*
>
> *2. **Thứ hai là Provider Cục bộ (Scoped Provider):** Được đặt trong `lib/lab/provider_lab_screen.dart`. Tại sao không đặt chung `LabNotifier` lên toàn cục?*
> *- Lý do thứ nhất: Màn hình Lab chỉ là nơi thực nghiệm đo số lần build, nó không liên quan đến dữ liệu đăng ký thật.*
> *- Lý do thứ hai: **Vòng đời tài nguyên**. Khi bọc cục bộ tại màn hình Lab, `LabNotifier` chỉ được sinh ra khi người dùng bấm vào xem Lab. Khi người dùng bấm nút Back quay ra, `ChangeNotifierProvider` sẽ tự động phát hiện và gọi hàm `dispose()` để giải phóng `LabNotifier` khỏi bộ nhớ RAM.*
>
> *Việc hiểu và phân định rõ ràng khi nào dùng Provider Toàn cục, khi nào dùng Provider Cục bộ chính là yếu tố quyết định giữa một ứng dụng hoạt động trơn tru, tiết kiệm RAM với một ứng dụng bị rò rỉ bộ nhớ (memory leak)."*

---

# SLIDE 7: BỐN CÁCH ĐỌC STATE TRONG PROVIDER

### 🖥️ Nội dung hiển thị trên Slide
- **Trục so sánh mức độ tinh chỉnh Rebuild (Phạm vi thu hẹp dần):**
  $$\text{setState (Cả cây)} \longrightarrow \text{watch (Cả Widget)} \longrightarrow \text{Consumer (Hàm builder)} \longrightarrow \text{select (Trường con đổi)} \longrightarrow \text{read (0 Rebuild)}$$
- **Bảng tổng hợp 4 phương thức đọc State:**

| Cách đọc | Rebuild khi nào? | Cơ chế thực tế | Áp dụng trong dự án |
| :--- | :--- | :--- | :--- |
| **`context.watch<T>()`** | Mỗi lần `notifyListeners()` | Đăng ký widget làm subscriber toàn phần | `CreditBadge` trên AppBar, `RegisteredScreen` |
| **`Consumer<T>`** | Chỉ chạy lại hàm `builder` | Widget bọc chuyên dụng, có tham số `child` giữ lại phần tĩnh | `SummaryBar` (thanh tiến độ ở footer) |
| **`context.select<T, R>()`** | **CHỈ** khi giá trị con `R` đổi | Lọc điều kiện, bỏ qua các thay đổi không liên quan | `CourseTile` (chỉ theo dõi `isRegistered(id)`) |
| **`context.read<T>()`** | **KHÔNG BAO GIỜ** | Chỉ lấy instance để gọi hàm thực thi, không lắng nghe | Các nút bấm `onPressed`: Đăng ký, Hủy môn, Reset |

- **QUY TẮC BẤT DI BẤT DỊCH (Golden Rule):**
  - **`watch` / `select` / `Consumer`**: Chỉ dùng trong thân hàm `build()`.
  - **`context.read`**: Chỉ dùng trong các hàm callback sự kiện (`onPressed`, `onTap`).
  - *Tuyệt đối không dùng `read` trong `build()` vì UI sẽ không cập nhật khi dữ liệu đổi, và không dùng `watch` trong callback.*

---

### 🎙️ Lời thoại thuyết trình (Speaker Notes)
> *[Nhấn mạnh giọng, truyền cảm hứng]*
>
> *"Và đây chính là Slide 7 – **Slide quan trọng nhất trong toàn bộ phần lý thuyết nền tảng**: Bốn phương thức đọc State trong Provider.*
>
> *Nhiều lập trình viên Flutter thường phàn nàn rằng 'Tại sao dùng Provider rồi mà app vẫn giật lag?'. Câu trả lời là vì họ chưa phân biệt được 4 cách đọc này:*
>
> *1. **Đầu tiên là `context.watch<T>()`:** Đây là cách đọc toàn diện nhất. Cứ mỗi khi Notifier bắn ra `notifyListeners()`, toàn bộ widget chứa hàm `watch` sẽ bị build lại. Chúng ta dùng nó cho những widget nhỏ và bắt buộc phải hiển thị dữ liệu mới nhất của toàn bộ hệ thống, ví dụ như huy hiệu `CreditBadge` trên thanh tiêu đề.*
>
> *2. **Thứ hai là `Consumer<T>`:** Nếu một widget của chúng ta có kích thước lớn, chứa nhiều thành phần tĩnh như banner, tiêu đề, nút bấm cố định, ta không muốn toàn bộ widget đó bị build lại. `Consumer` cho phép ta khoanh vùng: Chỉ có hàm `builder` của nó chạy lại, còn những phần tĩnh được đưa vào tham số `child` sẽ được tái sử dụng nguyên vẹn mà không hề tốn một chu kỳ CPU nào để vẽ lại.*
>
> *3. **Thứ ba – Tinh hoa của việc tối ưu – là `context.select<T, R>()`:** Hãy tưởng tượng danh sách của chúng ta có 10 môn học. Khi sinh viên bấm đăng ký Môn số 1, ta chỉ muốn thẻ Môn số 1 đổi trạng thái. Chín môn còn lại không hề thay đổi thì tuyệt đối không được phép rebuild! `context.select` giải quyết bài toán này xuất sắc: Nó chỉ lắng nghe đúng biểu thức logic `isRegistered(id)`. Khi tổng tín chỉ tăng, nhưng trạng thái môn này không đổi, thẻ này vẫn giữ nguyên, không tốn tài nguyên render.*
>
> *4. **Và cuối cùng là `context.read<T>()`:** Phương thức này hoàn toàn **KHÔNG** đăng ký lắng nghe rebuild. Nó chỉ đóng vai trò lấy tham chiếu của Notifier để gọi hàm thực thi, ví dụ gọi `notifier.register(course)`. Do đó, nó sinh ra là để đặt bên trong các sự kiện bấm nút `onPressed`.*
>
> *👉 Nhóm em xin đúc kết thành **Quy tắc vàng:** `watch`, `select` và `Consumer` dùng trong hàm `build()`; còn `context.read` luôn luôn đặt trong callback sự kiện!*
>
> *Và để chứng minh cho thầy và các bạn thấy sự chênh lệch rõ rệt về số lần rebuild giữa các cách đọc này trên thực tế, sau đây em xin phép nhường lại phần trình bày tiếp theo cho bạn **Võ Văn Thái** để đưa chúng ta bước vào các Slide thực nghiệm chuyên sâu và tham quan phòng thí nghiệm Provider Lab! Xin trân trọng cảm ơn thầy và các bạn!"*

---

## 💡 BẢNG TỔNG KẾT NHANH CHO NGƯỜI THUYẾT TRÌNH (CHEAT SHEET)

| Slide | Chủ đề | Điểm nhấn cần làm nổi bật | Thời lượng khuyến nghị |
| :---: | :--- | :--- | :---: |
| **1** | Mở đầu & Giới thiệu | Đặt vấn đề State Management trong thực tế, thái độ tự tin. | 45 giây |
| **2** | Phân công nhiệm vụ | Tính bổ trợ: Thắng (Kiến trúc, Nghiệp vụ, Demo) – Thái (Thực nghiệm Lab, Đo rebuild). | 45 giây |
| **3** | Vấn đề & Giải pháp | Nỗi đau của `setState`: Prop drilling + Over-rebuilding. Giới thiệu 3 khối module. | 1 phút 15 giây |
| **4** | Kiến trúc phân lớp | Luồng 1 chiều: UI event $\rightarrow$ Notifier $\rightarrow$ notifyListeners $\rightarrow$ Rebuild. Tách lớp sạch. | 1 phút 15 giây |
| **5** | RegistrationNotifier | Encapsulation (unmodifiable), Derived State (fold), Conditional Notify (chỉ notify khi state thật sự đổi). | 1 phút 30 giây |
| **6** | Provider Toàn cục vs Cục bộ | Global (main.dart) cho dữ liệu liên màn hình; Local (Lab) tự `dispose()` dọn dẹp RAM. | 1 phút 15 giây |
| **7** | Bốn cách đọc State | Trục thu hẹp rebuild: `watch` $\rightarrow$ `Consumer` $\rightarrow$ `select` $\rightarrow$ `read`. Quy tắc vàng (build vs callback). | 1 phút 45 giây |
| **TỔNG** | **Slide 1 đến Slide 7** | **Nền tảng lý thuyết và kiến trúc hoàn chỉnh trước khi vào thực nghiệm** | **~8 phút** |
