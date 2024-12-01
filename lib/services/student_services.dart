import '../models/user.dart';

class StudentService {
  final Map<String, List<User>> _classroomStudents = {};

  // Get all students in a specific classroom
  List<User> getStudentsInClassroom(String classroomName) {
    return _classroomStudents[classroomName] ?? [];
  }

  // Add a student to a specific classroom
  bool addStudentToClassroom(String classroomName, User student) {
    if (!_classroomStudents.containsKey(classroomName)) {
      _classroomStudents[classroomName] = [];
    }

    if (_classroomStudents[classroomName]!.any((s) => s.id == student.id)) {
      return false; // Student already exists
    }

    _classroomStudents[classroomName]!.add(student);
    return true;
  }

  // Remove a student from a specific classroom
  bool removeStudentFromClassroom(String classroomName, String studentId) {
    final classroomList = _classroomStudents[classroomName];
    if (classroomList == null) {
      return false; // Classroom doesn't exist
    }

    classroomList.removeWhere((s) => s.id == studentId);
    return true;
  }
}
