import 'package:flutter/material.dart';


class StudentListScreen extends StatelessWidget {
  final List<dynamic> students;

  StudentListScreen({required this.students});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      appBar: AppBar(
        title: const Text(
          "Flagged Students",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            var student = students[index];

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              color: Colors.white, // Card Background
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🧑‍🎓 Student Name
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            student["student_name"] ?? "Unknown",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // 🆔 EMIS ID
                    Row(
                      children: [
                        const Icon(Icons.badge, color: Colors.grey, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "EMIS ID: ${student["emis_id"] ?? "N/A"}",
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // 🏫 School Name
                    Row(
                      children: [
                        const Icon(Icons.school, color: Colors.orange, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            student["school_name"] ?? "Unknown",
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 📌 View Details Button
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle View Details Action
                        },
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text("View Details"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}





