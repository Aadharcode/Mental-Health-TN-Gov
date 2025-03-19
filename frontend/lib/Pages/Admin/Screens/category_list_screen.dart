import 'package:flutter/material.dart';
import './studentList.dart';
import 'graphScreen.dart';

class CategoryListScreen extends StatelessWidget {
  final String category;
  final List<dynamic> students;

  CategoryListScreen({required this.category, required this.students});

  void _navigateToGraphScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GraphScreen(students: students),
      ),
    );
  }

    void _navigateToStudentList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentListScreen(students: students),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        title: Text(
          category,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Name Section
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
              ),
              child: Row(
                children: [
                  Icon(Icons.category, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    category,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Student List
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                ),
                child: ListView.builder(
                  itemCount: students.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          students[index]["student_name"]?.substring(0, 1) ?? "U",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        students[index]["student_name"] ?? "Unknown",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 12),

            // Buttons
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space between buttons
  children: [
    ElevatedButton(
      onPressed: () => _navigateToGraphScreen(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Match theme
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text("View Graph", style: TextStyle(fontSize: 14, color: Colors.white)),
    ),
    ElevatedButton(
      onPressed: () => _navigateToStudentList(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Match theme
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text("View Students", style: TextStyle(fontSize: 14, color: Colors.white)),
    ),
  ],
),

            SizedBox(height: 12),
          ],

        ),
      ),
    );
  }
}
