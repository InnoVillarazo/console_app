import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/classroom_selection_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ClassroomSelectionPage(), // Starting page
    );
  }
}
