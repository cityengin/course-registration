import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/registration_notifier.dart';

class CreditBadge extends StatelessWidget {
  const CreditBadge({super.key});

  @override
  Widget build(BuildContext context) {
    // [context.watch]: Lắng nghe sự thay đổi của RegistrationNotifier.
    // Khi tổng tín chỉ thay đổi và notifyListeners() được gọi, widget CreditBadge sẽ tự động rebuild.
    final notifier = context.watch<RegistrationNotifier>();
    final totalCredits = notifier.totalCredits;
    final isValid = notifier.status == RegistrationStatus.valid;

    final badgeColor = isValid ? Colors.green.shade700 : Colors.amber.shade900;
    final badgeBg = isValid ? Colors.green.shade50 : Colors.amber.shade50;
    final borderColor = isValid ? Colors.green.shade300 : Colors.amber.shade400;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: badgeBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isValid ? Icons.verified_outlined : Icons.hourglass_top_outlined,
              size: 16,
              color: badgeColor,
            ),
            const SizedBox(width: 4),
            Text(
              '$totalCredits/${RegistrationNotifier.maxCredits} TC',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: badgeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
