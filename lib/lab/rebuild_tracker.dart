import 'package:flutter/material.dart';

/// [RebuildTracker]: Bộ theo dõi và ghi nhận số lần phương thức build() của widget được gọi.
/// Sử dụng static Map để lưu trữ lượt build theo định danh [key] duy nhất.
class RebuildTracker {
  static final Map<String, int> _counts = {};

  /// Ghi nhận 1 lần build cho [key] và trả về số lần build tích lũy hiện tại.
  /// Gọi hàm này trực tiếp trong phương thức build() của widget cần đo.
  static int hit(String key) {
    final count = (_counts[key] ?? 0) + 1;
    _counts[key] = count;
    return count;
  }

  /// Lấy số lần build hiện tại của [key] mà không làm tăng bộ đếm.
  static int get(String key) => _counts[key] ?? 0;

  /// Xóa toàn bộ dữ liệu đếm build về 0.
  static void resetAll() {
    _counts.clear();
  }
}

/// [BuildCountChip]: Widget nhỏ hiển thị số lần build trực quan dạng badge/chip.
/// Giúp người học nhìn thấy tức thì số lần một widget được vẽ lại (rebuild).
class BuildCountChip extends StatelessWidget {
  final int count;
  final String? label;

  const BuildCountChip({
    super.key,
    required this.count,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isRebuilt = count > 1;
    final bgColor = isRebuilt ? Colors.amber.shade50 : Colors.indigo.shade50;
    final borderColor = isRebuilt ? Colors.amber.shade700 : Colors.indigo.shade300;
    final textColor = isRebuilt ? Colors.amber.shade900 : Colors.indigo.shade800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRebuilt ? Icons.autorenew_rounded : Icons.fiber_manual_record,
            size: 13,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            label != null ? '$label: Build $count' : 'Build: $count',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

