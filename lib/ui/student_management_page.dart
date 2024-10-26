import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../providers.dart';

class StudentManagementPage extends StatelessWidget {
  const StudentManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: StudentList()),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () => showAddStudentDialog(context),
                  tooltip: 'Add Student',
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () => showStudentListDialog(context),
                  tooltip: 'List of Students',
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.list),
                ),
                FloatingActionButton(
                  onPressed: () => showRemoveStudentDialog(context),
                  tooltip: 'Remove Student',
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showAddStudentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddStudentForm();
      },
    );
  }

  void showStudentListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('List of Students'),
          content: StudentListContent(),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showRemoveStudentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return RemoveStudentForm();
      },
    );
  }
}

class StudentList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentService = ref.watch(studentServiceProvider);
    final students = studentService.getStudents();

    return ListView.builder(
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
                studentService.removeStudent(student.id);
              },
            ),
          ),
        );
      },
    );
  }
}

class AddStudentForm extends ConsumerWidget {
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
              final success = ref.read(studentServiceProvider).addStudent(student);
              if (success) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student added successfully!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student ID already exists.')),
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

class StudentListContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentService = ref.watch(studentServiceProvider);
    final students = studentService.getStudents();

    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text('ID: ${student.id}, Age: ${student.age}'),
          );
        },
      ),
    );
  }
}

class RemoveStudentForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController idController = TextEditingController();

    return AlertDialog(
      title: const Text('Remove Student'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: idController,
          decoration: const InputDecoration(labelText: 'Enter Student ID to Remove'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an ID';
            }
            return null;
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final success = ref.read(studentServiceProvider).removeStudent(idController.text);
              if (success) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student removed successfully!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No student found with that ID.')),
                );
              }
            }
          },
          child: const Text('Remove'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
