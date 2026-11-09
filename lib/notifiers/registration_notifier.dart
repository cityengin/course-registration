import 'package:flutter/foundation.dart';
import '../models/course.dart';

/// Enum biểu diễn trạng thái đăng ký tín chỉ:
/// - notEnough: Chưa đủ số tín chỉ tối thiểu (< 14 tín chỉ)
/// - valid: Số tín chỉ hợp lệ (14 - 24 tín chỉ)
enum RegistrationStatus {
  notEnough('Chưa đủ số tín chỉ tối thiểu'),
  valid('Số tín chỉ hợp lệ');

  final String description;
  const RegistrationStatus(this.description);
}

/// RegistrationNotifier: Quản lý toàn bộ trạng thái và nghiệp vụ đăng ký học phần.
/// Widget chỉ lắng nghe hoặc gọi hàm từ Notifier này, không tự tính toán.
class RegistrationNotifier extends ChangeNotifier {
  static const int minCredits = 14;
  static const int maxCredits = 24;

  // Danh sách các học phần đã đăng ký (private)
  final List<Course> _registered = [];

  // Getter trả về danh sách không thể sửa đổi trực tiếp từ bên ngoài
  List<Course> get registered => List.unmodifiable(_registered);

  // Tổng số tín chỉ của các học phần đã đăng ký
  int get totalCredits => _registered.fold(0, (sum, course) => sum + course.credits);

  // Kiểm tra học phần đã được đăng ký hay chưa dựa trên ID
  bool isRegistered(String courseId) {
    return _registered.any((course) => course.id == courseId);
  }

  // Trạng thái đăng ký hiện tại (chưa đủ hoặc hợp lệ)
  RegistrationStatus get status =>
      totalCredits >= minCredits ? RegistrationStatus.valid : RegistrationStatus.notEnough;

  /// Đăng ký thêm một học phần.
  /// Trả về null nếu thành công, hoặc chuỗi thông báo lỗi nếu không thể đăng ký.
  String? register(Course course) {
    if (isRegistered(course.id)) {
      return 'Học phần "${course.name}" đã được đăng ký trước đó!';
    }

    if (totalCredits + course.credits > maxCredits) {
      return 'Không thể đăng ký: Tổng tín chỉ sẽ vượt quá giới hạn tối đa ($maxCredits tín chỉ)!';
    }

    _registered.add(course);
    notifyListeners(); // Chỉ thông báo khi state thật sự thay đổi
    return null;
  }

  /// Hủy đăng ký một học phần theo ID.
  void unregister(String courseId) {
    final index = _registered.indexWhere((course) => course.id == courseId);
    if (index != -1) {
      _registered.removeAt(index);
      notifyListeners(); // Chỉ thông báo khi state thật sự thay đổi
    }
  }

  /// Hủy đăng ký tất cả các học phần đã chọn.
  void clearAll() {
    if (_registered.isNotEmpty) {
      _registered.clear();
      notifyListeners(); // Chỉ thông báo khi danh sách trước đó có phần tử
    }
  }
}
