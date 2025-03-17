import 'package:flutter/material.dart';
import './dashboardScreen.dart';

class CategoryListScreen extends StatelessWidget {
  final String category;
  final List<dynamic> students;

  CategoryListScreen({required this.category, required this.students});

  void _navigateToStudentList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentListScreen(students: students),
      ),
    );
  }

  void _navigateToGraphScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GraphScreen(students: students),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(students[index]["student_name"] ?? "Unknown"));
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _navigateToStudentList(context),
                child: const Text("View Students"),
              ),
              
              ElevatedButton(
                onPressed: () => _navigateToGraphScreen(context),
                child: const Text("View Graph"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
