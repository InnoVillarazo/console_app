import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../providers.dart';

class StudentManagementPage extends ConsumerWidget {
  final String classroomName;

  const StudentManagementPage({super.key, required this.classroomName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentService = ref.watch(studentServiceProvider);
    final students = studentService.getStudentsInClassroom(classroomName);

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Management for $classroomName'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_student_management.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(student.name,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            'ID: ${student.id}, Year & Section: ${student.yearAndSection}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            final success = studentService
                                .removeStudentFromClassroom(
                                    classroomName, student.id);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Student removed!')),
                              );
                              // Refresh the list by calling setState
                              ref.refresh(studentServiceProvider);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => showAddStudentDialog(context, ref),
                child: const Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAddStudentDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final yearController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Student'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'Student ID'),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Student Name'),
                ),
                TextFormField(
                  controller: yearController,
                  decoration: const InputDecoration(
                      labelText: 'Year & Section'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final student = User(
                    id: idController.text,
                    name: nameController.text,
                    yearAndSection: yearController.text,
                  );

                  ref.read(studentServiceProvider).addStudentToClassroom(
                      classroomName, student);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
