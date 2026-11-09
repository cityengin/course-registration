import 'package:flutter/material.dart';
import '../data/course_catalog.dart';
import '../lab/provider_lab_screen.dart';
import '../widgets/course_tile.dart';
import '../widgets/credit_badge.dart';
import '../widgets/summary_bar.dart';
import 'registered_screen.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đăng ký học phần',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // CreditBadge hiển thị tổng số tín chỉ hiện tại (dùng context.watch)
          const CreditBadge(),
          // Icon điều hướng sang màn hình học phần đã đăng ký
          IconButton(
            icon: const Icon(Icons.assignment_turned_in_outlined),
            tooltip: 'Học phần đã đăng ký',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisteredScreen(),
                ),
              );
            },
          ),
          // Icon điều hướng sang màn hình Provider Lab
          IconButton(
            icon: const Icon(Icons.science_outlined),
            tooltip: 'Provider Lab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProviderLabScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: courseCatalog.length,
              itemBuilder: (context, index) {
                final course = courseCatalog[index];
                return CourseTile(course: course);
              },
            ),
          ),
          // Thanh tổng kết tín chỉ ở cuối màn hình (dùng Consumer)
          const SummaryBar(),
        ],
      ),
    );
  }
}
