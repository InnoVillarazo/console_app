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
      body: Padding(
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
                      title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('ID: ${student.id}, Age: ${student.age}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          final success = studentService.removeStudentFromClassroom(classroomName, student.id);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Student removed successfully!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to remove student.')),
                            );
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
    );
  }

  void showAddStudentDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AddStudentForm(classroomName: classroomName);
      },
    );
  }
}

class AddStudentForm extends ConsumerWidget {
  final String classroomName;

  const AddStudentForm({super.key, required this.classroomName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();

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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Student Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Student Age'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an age';
                }
                return null;
              },
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
                age: int.parse(ageController.text),
              );

              final success = ref.read(studentServiceProvider).addStudentToClassroom(classroomName, student);
              if (success) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student added successfully!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student ID already exists in this classroom.')),
                );
              }
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
  }
}
  