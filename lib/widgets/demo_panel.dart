import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/course_catalog.dart';
import '../notifiers/registration_notifier.dart';

/// DemoPanel: Bảng điều khiển demo kịch bản thuyết trình nhanh.
/// Đặt ở đầu màn hình danh sách học phần, mặc định thu gọn trong ExpansionTile.
class DemoPanel extends StatelessWidget {
  const DemoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.indigo.shade100),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        dense: true,
        leading: Icon(Icons.tune, color: Colors.indigo.shade700, size: 22),
        title: const Text(
          'Bảng điều khiển demo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: const Text(
          'Kịch bản thuyết trình & quan sát notifyListeners',
          style: TextStyle(fontSize: 11, color: Colors.black54),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Kịch bản thao tác nhanh:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          const SizedBox(height: 6),

          // Wrap các nút kịch bản để không tràn trên màn hình hẹp (360dp)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              // Kịch bản a: Đăng ký đủ tối thiểu (>= 14 tín chỉ)
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
                icon: const Icon(Icons.done_all, size: 15),
                label: const Text('Đăng ký đủ tối thiểu', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  // [context.read]: Lấy instance RegistrationNotifier để gọi kịch bản mà không rebuild nút này
                  final notifier = context.read<RegistrationNotifier>();
                  for (final course in courseCatalog) {
                    if (notifier.totalCredits >= RegistrationNotifier.minCredits) {
                      break;
                    }
                    if (!notifier.isRegistered(course.id)) {
                      notifier.register(course);
                    }
                  }
                },
              ),

              // Kịch bản b: Thử vượt giới hạn (> 24 tín chỉ)
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
                icon: const Icon(Icons.warning_amber_outlined, size: 15),
                label: const Text('Thử vượt giới hạn', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  // [context.read]: Đăng ký liên tục cho đến khi hàm register trả lỗi
                  final notifier = context.read<RegistrationNotifier>();
                  String? lastError;
                  for (final course in courseCatalog) {
                    if (!notifier.isRegistered(course.id)) {
                      final error = notifier.register(course);
                      if (error != null) {
                        lastError = error;
                        break;
                      }
                    }
                  }
                  if (lastError != null && context.mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(lastError),
                        backgroundColor: Colors.red.shade700,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),

              // Kịch bản c: Thử đăng ký trùng (chứng minh không gọi notifyListeners khi state không đổi)
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
                icon: const Icon(Icons.copy_outlined, size: 15),
                label: const Text('Thử đăng ký trùng', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  // [context.read]: Đăng ký môn đầu tiên, sau đó đăng ký lại chính môn đó
                  final notifier = context.read<RegistrationNotifier>();
                  final firstCourse = courseCatalog.first;

                  // Đảm bảo môn đã có trong danh sách
                  if (!notifier.isRegistered(firstCourse.id)) {
                    notifier.register(firstCourse);
                  }

                  // Thử đăng ký lại đúng môn đã có
                  final error = notifier.register(firstCourse);
                  if (error != null && context.mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        backgroundColor: Colors.orange.shade800,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),

              // Kịch bản d: Hủy tất cả
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade300),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
                icon: const Icon(Icons.delete_sweep_outlined, size: 15),
                label: const Text('Hủy tất cả', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  // [context.read]: Gọi phương thức clearAll() để hủy toàn bộ học phần
                  context.read<RegistrationNotifier>().clearAll();
                },
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Khu nhật ký notifyListeners
          const _NotifyLog(),
        ],
      ),
    );
  }
}

/// Widget riêng theo dõi sự kiện notifyListeners() nguyên bản của ChangeNotifier
class _NotifyLog extends StatefulWidget {
  const _NotifyLog();

  @override
  State<_NotifyLog> createState() => _NotifyLogState();
}

class _NotifyLogState extends State<_NotifyLog> {
  late final RegistrationNotifier _notifier;
  int _notifyCount = 0;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    // [addListener]: Provider thực chất dùng chính cơ chế addListener của ChangeNotifier
    // bên dưới để đăng ký lắng nghe và kích hoạt rebuild widget khi có notifyListeners().
    _notifier = context.read<RegistrationNotifier>();
    _notifier.addListener(_onNotified);
  }

  @override
  void dispose() {
    // Luôn hủy đăng ký listener khi widget bị hủy để tránh memory leak
    _notifier.removeListener(_onNotified);
    super.dispose();
  }

  void _onNotified() {
    if (!mounted) return;
    setState(() {
      _notifyCount++;
      _logs.insert(
        0,
        '#$_notifyCount · ${_notifier.registered.length} môn · ${_notifier.totalCredits} TC',
      );
      // Giữ tối đa 5 dòng mới nhất
      if (_logs.length > 5) {
        _logs.removeLast();
      }
    });
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
      _notifyCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.history, size: 15, color: Colors.indigo.shade800),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'Nhật ký notifyListeners (Tổng: $_notifyCount lần)',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.indigo.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_logs.isNotEmpty)
                InkWell(
                  onTap: _clearLogs,
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    child: Text(
                      'Xóa nhật ký',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.grey.shade700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),

          // Ghi chú cơ chế ChangeNotifier
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 13, color: Colors.amber.shade900),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    "Bấm 'Thử đăng ký trùng': state không đổi nên không có dòng mới → notifier chỉ notify khi state thật sự thay đổi.",
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Danh sách log
          if (_logs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                'Chưa có sự kiện notify (bấm các nút kịch bản ở trên để thử).',
                style: TextStyle(
                  fontSize: 10.5,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                ),
              ),
            )
          else
            ..._logs.map(
              (log) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_right, size: 13, color: Colors.indigo),
                    Text(
                      log,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
