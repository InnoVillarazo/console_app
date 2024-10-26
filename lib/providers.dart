import 'package:riverpod/riverpod.dart';
import 'services/student_services.dart';

final studentServiceProvider = Provider<StudentService>((ref) {
  return StudentService();
});
