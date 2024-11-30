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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Path to your background image
            fit: BoxFit.cover, // Ensures the image covers the whole background
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Add a semi-transparent background for the input field
              Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent black
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter Classroom Name',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white), // Adjust color for readability
                  ),
                  style: const TextStyle(color: Colors.white), // Input text color
                ),
              ),
              const SizedBox(height: 10),
              // Add a semi-transparent background for the button
              Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent black
                child: ElevatedButton(
                  onPressed: _addClassroom,
                  child: const Text('Add Classroom', style: TextStyle(color: Colors.white)), // Button text color
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _classrooms.length,
                  itemBuilder: (context, index) {
                    final classroom = _classrooms[index];
                    return ListTile(
                      title: Text(
                        classroom,
                        style: const TextStyle(color: Colors.white), // Adjust color for readability
                      ),
                      onTap: () => _navigateToStudentManagement(classroom),
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
