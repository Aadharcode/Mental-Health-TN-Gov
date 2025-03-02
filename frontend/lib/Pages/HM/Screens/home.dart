import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Redflag.dart';

class HomeScreen extends StatefulWidget {
  final String? SCHOOL_NAME;
  final String? District;

  HomeScreen({required this.SCHOOL_NAME, required this.District});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController districtController = TextEditingController();

  Future<void> searchStudents() async {
    try {
      final url = Uri.parse('http://13.232.9.135:3000/api/hsmsFetch');
      final body = jsonEncode({
        'school_name': widget.SCHOOL_NAME,
        'district': widget.District,
      });
      print(body);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Keeping a clean background
      
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Red Flag Students',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(1, 69, 68, 1.0),
                  ),
                ),
                const SizedBox(height: 16),

                // Centered Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(1, 69, 68, 1.0),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'View students flagged for mental health concerns',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: searchStudents,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        ),
                        child: Text(
                          'See Red Flag Students',
                          style: TextStyle(
                            color: Color.fromRGBO(1, 69, 68, 1.0),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
