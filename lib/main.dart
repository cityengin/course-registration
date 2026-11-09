import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notifiers/registration_notifier.dart';
import 'views/course_list_screen.dart';

void main() {
  runApp(const CourseRegistrationApp());
}

class CourseRegistrationApp extends StatelessWidget {
  const CourseRegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    // [ChangeNotifierProvider]: Bọc ngoài MaterialApp để mọi màn hình
    // (CourseListScreen, RegisteredScreen, ProviderLabScreen) đều dùng chung một instance của RegistrationNotifier.
    return ChangeNotifierProvider(
      create: (_) => RegistrationNotifier(),
      child: MaterialApp(
        title: 'Course Registration',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
        ),
        home: const CourseListScreen(),
      ),
    );
  }
}
