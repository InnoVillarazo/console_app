import '../models/user.dart';

class StudentService {
  final List<User> _students = [];

  bool addStudent(User student) {
    final studentExists = _students.any((s) => s.id == student.id);
    if (studentExists) {
      return false; 
    }
    _students.add(student);
    return true;
  }

  bool removeStudent(String id) {
    final originalLength = _students.length;
    _students.removeWhere((student) => student.id == id);
    return _students.length < originalLength;
  }

  List<User> getStudents() {
    return List.unmodifiable(_students); 
  }
}
