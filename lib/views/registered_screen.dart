import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/registration_notifier.dart';

class RegisteredScreen extends StatelessWidget {
  const RegisteredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // [context.watch]: Đọc và lắng nghe toàn bộ danh sách đã đăng ký từ RegistrationNotifier.
    // Khi người dùng hủy học phần tại màn hình này (hoặc ở màn hình khác), giao diện sẽ tự động cập nhật.
    final notifier = context.watch<RegistrationNotifier>();
    final registeredList = notifier.registered;
    final totalCredits = notifier.totalCredits;
    final isValid = notifier.status == RegistrationStatus.valid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Học phần đã đăng ký'),
        actions: [
          // Nút "Hủy tất cả" chỉ bật khi có ít nhất 1 học phần
          if (registeredList.isNotEmpty)
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade700,
              ),
              icon: const Icon(Icons.delete_sweep_outlined),
              label: const Text('Hủy tất cả'),
              onPressed: () {
                _showClearAllDialog(context);
              },
            ),
        ],
      ),
      body: registeredList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.playlist_remove_outlined,
                    size: 72,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Chưa có học phần nào được đăng ký',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Hãy chọn các môn học ở màn hình danh sách.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Banner thông tin tổng số môn và tín chỉ
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: isValid ? Colors.green.shade50 : Colors.amber.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đã chọn: ${registeredList.length} môn',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Tổng: $totalCredits / ${RegistrationNotifier.maxCredits} TC',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isValid ? Colors.green.shade900 : Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: registeredList.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final course = registeredList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade50,
                          child: Text(
                            '${course.credits}',
                            style: TextStyle(
                              color: Colors.indigo.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          course.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${course.code} • ${course.lecturer}',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          tooltip: 'Hủy môn này',
                          onPressed: () {
                            // [context.read]: Gọi phương thức unregister khi người dùng bấm nút xóa môn
                            context.read<RegistrationNotifier>().unregister(course.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận hủy tất cả'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa toàn bộ học phần đã đăng ký không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // [context.read]: Gọi clearAll() để hủy toàn bộ học phần trong notifier
              context.read<RegistrationNotifier>().clearAll();
              Navigator.pop(dialogContext);
            },
            child: const Text('Hủy tất cả'),
          ),
        ],
      ),
    );
  }
}
