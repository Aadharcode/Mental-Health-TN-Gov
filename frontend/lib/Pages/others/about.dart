import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About",
          style: TextStyle(color: Colors.blue), // 🔹 Blue text
        ),
        backgroundColor: Colors.white,
        elevation: 4, // 🔹 Adds a shadow effect
        shadowColor: Colors.grey.withOpacity(0.5), // 🔹 Soft grey shadow
        iconTheme: IconThemeData(color: Colors.blue), // 🔹 Blue back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Welcome to the Emotional Well-Being App designed specifically for students in grades 9- 12 in Tamil Nadu. This app aims to support the mental health of students by facilitating communication between teachers, headmasters, and psychiatrists. The app allows teachers to identify students who may need assistance, track their mental health status, and ensure they receive the necessary support. ",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
