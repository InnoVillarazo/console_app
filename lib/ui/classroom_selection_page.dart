import 'package:flutter/material.dart';
import 'student_management_page.dart';

class ClassroomSelectionPage extends StatefulWidget {
  const ClassroomSelectionPage({super.key});

  @override
  State<ClassroomSelectionPage> createState() => _ClassroomSelectionPageState();
}

class _ClassroomSelectionPageState extends State<ClassroomSelectionPage> {
  final List<String> _classrooms = [];
  final TextEditingController _controller = TextEditingController();

  void _addClassroom() {
    final classroom = _controller.text.trim();
    if (classroom.isNotEmpty) {
      setState(() {
        _classrooms.add(classroom);
        _controller.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Classroom "$classroom" added successfully!')),
      );
    }
  }

  void _deleteClassroom(String classroom) {
    setState(() {
      _classrooms.remove(classroom);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Classroom "$classroom" deleted successfully!')),
    );
  }

  void _navigateToStudentManagement(String classroom) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentManagementPage(classroomName: classroom),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classroom Selection'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter Classroom Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addClassroom,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Add Classroom'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _classrooms.length,
                  itemBuilder: (context, index) {
                    final classroom = _classrooms[index];
                    return Card(
                      color: Colors.pink[100],
                      child: ListTile(
                        title: Text(classroom),
                        onTap: () => _navigateToStudentManagement(classroom),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteClassroom(classroom),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
