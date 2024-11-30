import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/student_services.dart';

final studentServiceProvider = Provider<StudentService>((ref) {
  return StudentService();
});
