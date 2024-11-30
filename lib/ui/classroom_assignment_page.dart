import 'package:flutter/material.dart';

class ClassroomAssignmentPage extends StatefulWidget {
  const ClassroomAssignmentPage({super.key});

  @override
  _ClassroomAssignmentPageState createState() =>
      _ClassroomAssignmentPageState();
}

class _ClassroomAssignmentPageState extends State<ClassroomAssignmentPage> {
  final _classroomController = TextEditingController();
  final List<String> _assignedClassrooms = [];

  void _assignClassroom() {
    final classroom = _classroomController.text.trim();
    if (classroom.isNotEmpty) {
      setState(() {
        _assignedClassrooms.add(classroom);
        _classroomController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Classroom "$classroom" assigned successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid classroom name.')),
      );
    }
  }

  @override
  void dispose() {
    _classroomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classroom Assignment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _classroomController,
              decoration: const InputDecoration(
                labelText: 'Classroom Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _assignClassroom,
              child: const Text('Assign Classroom'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _assignedClassrooms.length,
                itemBuilder: (context, index) {
                  final classroom = _assignedClassrooms[index];
                  return ListTile(
                    title: Text(classroom),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
