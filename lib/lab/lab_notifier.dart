import 'package:flutter/foundation.dart';

/// [LabNotifier]: Quản lý trạng thái độc lập phục vụ riêng cho màn hình Provider Lab.
/// Kế thừa [ChangeNotifier] để cung cấp khả năng phát thông báo (notifyListeners) khi dữ liệu đổi.
/// Được cung cấp cục bộ trong ProviderLabScreen thông qua ChangeNotifierProvider,
/// tự động giải phóng (dispose) khi người dùng thoát khỏi màn hình Lab.
class LabNotifier extends ChangeNotifier {
  int _countA = 0;
  int _countB = 0;

  int get countA => _countA;
  int get countB => _countB;

  /// Tăng giá trị countA và phát tín hiệu cho các widget đang lắng nghe
  void incrementA() {
    _countA++;
    notifyListeners(); // Thông báo cho tất cả widget đang watch/listen
  }

  /// Tăng giá trị countB và phát tín hiệu cho các widget đang lắng nghe
  void incrementB() {
    _countB++;
    notifyListeners(); // Thông báo cho tất cả widget đang watch/listen
  }

  /// Đặt lại cả countA và countB về 0
  void reset() {
    if (_countA != 0 || _countB != 0) {
      _countA = 0;
      _countB = 0;
      notifyListeners();
    }
  }
}

