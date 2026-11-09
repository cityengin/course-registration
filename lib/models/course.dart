import 'package:flutter/foundation.dart';

@immutable
class Course {
  final String id;
  final String code;
  final String name;
  final int credits;
  final String lecturer;

  const Course({
    required this.id,
    required this.code,
    required this.name,
    required this.credits,
    required this.lecturer,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
