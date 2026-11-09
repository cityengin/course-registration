import 'package:flutter_test/flutter_test.dart';
import 'package:course_registration/main.dart';
import 'package:course_registration/models/course.dart';
import 'package:course_registration/notifiers/registration_notifier.dart';

void main() {
  group('RegistrationNotifier Unit Tests', () {
    late RegistrationNotifier notifier;

    setUp(() {
      notifier = RegistrationNotifier();
    });

    test('Trạng thái khởi tạo: 0 tín chỉ, notEnough', () {
      expect(notifier.totalCredits, 0);
      expect(notifier.registered.isEmpty, isTrue);
      expect(notifier.status, RegistrationStatus.notEnough);
    });

    test('Đăng ký học phần thành công và tính tổng tín chỉ', () {
      const course1 = Course(
        id: 'c1',
        code: 'IT001',
        name: 'Môn 1',
        credits: 3,
        lecturer: 'GV A',
      );
      final error = notifier.register(course1);
      expect(error, isNull);
      expect(notifier.totalCredits, 3);
      expect(notifier.isRegistered('c1'), isTrue);
    });

    test('Báo lỗi khi đăng ký trùng môn', () {
      const course1 = Course(
        id: 'c1',
        code: 'IT001',
        name: 'Môn 1',
        credits: 3,
        lecturer: 'GV A',
      );
      notifier.register(course1);
      final duplicateError = notifier.register(course1);
      expect(duplicateError, isNotNull);
      expect(notifier.registered.length, 1);
    });

    test('Báo lỗi khi đăng ký vượt quá 24 tín chỉ', () {
      // Đăng ký 6 môn x 4 tín chỉ = 24 tín chỉ
      for (int i = 1; i <= 6; i++) {
        final err = notifier.register(Course(
          id: 'c$i',
          code: 'IT00$i',
          name: 'Môn $i',
          credits: 4,
          lecturer: 'GV',
        ));
        expect(err, isNull);
      }
      expect(notifier.totalCredits, 24);
      expect(notifier.status, RegistrationStatus.valid);

      // Đăng ký môn thứ 7 (thêm 2 tín chỉ = 26 > 24) -> Báo lỗi
      final exceedErr = notifier.register(const Course(
        id: 'c7',
        code: 'IT007',
        name: 'Môn 7',
        credits: 2,
        lecturer: 'GV',
      ));
      expect(exceedErr, isNotNull);
      expect(notifier.totalCredits, 24);
    });

    test('Hủy môn và Hủy tất cả hoạt động đúng', () {
      const course1 = Course(
        id: 'c1',
        code: 'IT001',
        name: 'Môn 1',
        credits: 3,
        lecturer: 'GV A',
      );
      notifier.register(course1);
      expect(notifier.registered.length, 1);

      notifier.unregister('c1');
      expect(notifier.registered.isEmpty, isTrue);
      expect(notifier.totalCredits, 0);

      notifier.register(course1);
      notifier.clearAll();
      expect(notifier.registered.isEmpty, isTrue);
    });
  });

  group('Widget Tests', () {
    testWidgets('Khởi chạy ứng dụng hiển thị đúng tiêu đề và danh sách', (WidgetTester tester) async {
      await tester.pumpWidget(const CourseRegistrationApp());
      expect(find.text('Đăng ký học phần'), findsOneWidget);
    });
  });
}
