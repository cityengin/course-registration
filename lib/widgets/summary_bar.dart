import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/registration_notifier.dart';

class SummaryBar extends StatelessWidget {
  const SummaryBar({super.key});

  @override
  Widget build(BuildContext context) {
    // [Consumer<RegistrationNotifier>]: Lắng nghe RegistrationNotifier và chỉ rebuild
    // khối UI bên trong builder mỗi khi có thông báo thay đổi, giúp cô lập phạm vi vẽ lại giao diện.
    return Consumer<RegistrationNotifier>(
      builder: (context, notifier, child) {
        final totalCredits = notifier.totalCredits;
        final isValid = notifier.status == RegistrationStatus.valid;
        final progress = (totalCredits / RegistrationNotifier.maxCredits).clamp(0.0, 1.0);

        final statusColor = isValid ? Colors.green.shade700 : Colors.deepOrange.shade700;
        final statusBg = isValid ? Colors.green.shade50 : Colors.deepOrange.shade50;
        final statusBorder = isValid ? Colors.green.shade300 : Colors.deepOrange.shade200;

        final statusText = isValid
            ? 'Hợp lệ (${RegistrationNotifier.minCredits}–${RegistrationNotifier.maxCredits} TC)'
            : 'Chưa đủ tối thiểu (Cần thêm ${RegistrationNotifier.minCredits - totalCredits} TC)';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, -3),
                blurRadius: 8,
              ),
            ],
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tổng tín chỉ:',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$totalCredits / ${RegistrationNotifier.maxCredits} TC',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isValid ? Icons.check_circle : Icons.warning_amber_rounded,
                              size: 16,
                              color: statusColor,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                statusText,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isValid ? Colors.green : Colors.deepOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tối thiểu: ${RegistrationNotifier.minCredits} TC',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    Text(
                      'Tối đa: ${RegistrationNotifier.maxCredits} TC',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
