import 'package:flutter/material.dart';
import '../../Rc/models/student.dart';
import '../../Rc/Screens/StudentDetailScreen.dart';

class ReferralListScreen extends StatelessWidget {
  final String title;
  final List<Student> students;

  const ReferralListScreen({
    required this.title,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: students.isEmpty
          ? const Center(child: Text("No students available"))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(student.studentName),
                    subtitle: Text("Class: ${student.classLevel}"),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDetailsScreen(student: student),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

