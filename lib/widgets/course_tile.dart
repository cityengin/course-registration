import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../notifiers/registration_notifier.dart';

class CourseTile extends StatelessWidget {
  final Course course;

  const CourseTile({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    // [context.select]: Chỉ lắng nghe trạng thái đăng ký của riêng học phần này,
    // widget này chỉ rebuild khi trạng thái của môn học này thay đổi.
    final isRegistered = context.select<RegistrationNotifier, bool>(
      (notifier) => notifier.isRegistered(course.id),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: isRegistered ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRegistered ? Colors.indigo.shade400 : Colors.grey.shade200,
          width: isRegistered ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    course.code,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${course.credits} tín chỉ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                if (isRegistered)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        'Đã chọn',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              course.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    course.lecturer,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Nút Đăng ký / Hủy
                isRegistered
                    ? OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade300),
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(Icons.remove_circle_outline, size: 16),
                        label: const Text('Hủy môn'),
                        onPressed: () {
                          // [context.read]: Gọi unregister mà không đăng ký lắng nghe rebuild tại đây.
                          context.read<RegistrationNotifier>().unregister(course.id);
                        },
                      )
                    : FilledButton.icon(
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Đăng ký'),
                        onPressed: () {
                          // [context.read]: Gọi phương thức register() trong callback sự kiện onPressed.
                          // Nếu có lỗi (trùng môn hoặc vượt quá tín chỉ), hiển thị SnackBar thông báo.
                          final error = context.read<RegistrationNotifier>().register(course);
                          if (error != null && context.mounted) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error),
                                backgroundColor: Colors.red.shade700,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
