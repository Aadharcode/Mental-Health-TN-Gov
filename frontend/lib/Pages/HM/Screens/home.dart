import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Redflag.dart';
import '../../Teachers/Screens/victim_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../others/about.dart';
import '../../others/terms.dart';
import '../../Login/Login.dart'; 

class HomeScreen extends StatefulWidget {
  final String? SCHOOL_NAME;
  final String? District;

  HomeScreen({required this.SCHOOL_NAME, required this.District});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

Future<void> _logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Erase stored login data

    // Navigate to Login Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

class _HomeScreenState extends State<HomeScreen> {
  Future<void> searchStudents() async {
    try {
      final url = Uri.parse('http://13.232.9.135:3000/api/hsmsFetch');
      final body = jsonEncode({
        'school_name': widget.SCHOOL_NAME,
        'district': widget.District,
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> students = data['data'];

        for (var student in students) {
          List<String> redflags = [];

          if (student['sexual_abuse'] == true) redflags.add('Sexual Abuse');
          if (student['stress'] == true) redflags.add('Stress');
          if (student['loss_grief'] == true) redflags.add('Loss/Grief');
          if (student['relationship'] == true) redflags.add('Relationship');
          if (student['anxiety'] == true) redflags.add('Anxiety');
          if (student['depression'] == true) redflags.add('Depression');
          if (student['aggresion_violence'] == true) redflags.add('Aggression/Violence');
          if (student['selfharm_suicide'] == true) redflags.add('Self-harm/Suicide');
          if (student['bodyimage_selflisten'] == true) redflags.add('Body Image/Self-esteem');
          if (student['sleep'] == true) redflags.add('Sleep Issues');
          if (student['conduct_delinquency'] == true) redflags.add('Conduct/Delinquency');

          student['redflags'] = redflags;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RedflagScreen(students: students),
          ),
        );
      } else {
        final message = jsonDecode(response.body)['msg'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Failed to fetch students')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void navigateToMarkVictimScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MarkVictimScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE3F2FD),
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/Logo/logo_TNMS.png', height: 30),
            const SizedBox(width: 10),
            Text(
              'TNMSS',
              style: TextStyle(color: Color(0xFF014544), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'About') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              } else if (value == 'Terms') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsScreen()),
                );
              } else if (value == 'Logout') {
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'About', child: Text('About')),
              PopupMenuItem(value: 'Terms', child: Text('Terms and Conditions')),
              PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
      backgroundColor: Color(0xFFF5F9FF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // Section Title
            Row(
              children: [
                Icon(Icons.flag, color: Color(0xFF1565C0)), // Dark blue flag icon
                const SizedBox(width: 8),
                Text(
                  'Red Flag Students',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0), // Darker blue
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Information Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.remove_red_eye, color: Colors.black54, size: 30),
                  const SizedBox(height: 10),
                  Text(
                    'View students flagged for mental health concerns',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1565C0), // Vibrant blue
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: searchStudents,
                child: Text('See Red Flag Students', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Strong red
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => navigateToMarkVictimScreen(context),
                child: Text('Report Incident', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
