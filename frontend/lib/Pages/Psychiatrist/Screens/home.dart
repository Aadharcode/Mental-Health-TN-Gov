import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../backendUrl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> redFlaggedStudents = [];

  @override
  void initState() {
    super.initState();
    fetchRedFlaggedStudents();
  }

  // Fetch red-flagged students
  Future<void> fetchRedFlaggedStudents() async {
    try {
      final url = Uri.parse('BackendUrl.baseUrl/approvedStudents');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          redFlaggedStudents = data['data'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No red-flagged students found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  // Handle curing (canceling) a red-flagged student
  Future<void> handleCure(String emisId) async {
    try {
      final url = Uri.parse('BackendUrl.baseUrl/api/approval');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_emis_id': emisId,
          'approve': false, 
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('student cured')),
        );

        // Reload the student list after curing and update the UI
        setState(() {
          redFlaggedStudents.removeWhere((student) => student['student_emis_id'] == emisId);
        });

        // Optionally, call fetchRedFlaggedStudents again to get fresh data from server
        fetchRedFlaggedStudents();
      } else {
        final message = jsonDecode(response.body)['msg'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Failed to update student status')),
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
      appBar: AppBar(
        title: Text('Red-Flagged Students'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: SafeArea(
        child: redFlaggedStudents.isEmpty
            ? Center(
                child: Text('No red-flagged students found.'),
              )
            : ListView.builder(
                itemCount: redFlaggedStudents.length,
                itemBuilder: (context, index) {
                  final student = redFlaggedStudents[index];

                  // Generate redflags based on the boolean fields
                  List<String> redFlags = [];
                  if (student['anxiety'] == true) redFlags.add('Anxiety');
                  if (student['depression'] == true) redFlags.add('Depression');
                  if (student['aggresion_violence'] == true) redFlags.add('Aggression/Violence');
                  if (student['selfharm_suicide'] == true) redFlags.add('Self-harm/Suicide');
                  if (student['sexual_abuse'] == true) redFlags.add('Sexual Abuse');
                  if (student['stress'] == true) redFlags.add('Stress');
                  if (student['loss_grief'] == true) redFlags.add('Loss/Grief');
                  if (student['relationship'] == true) redFlags.add('Relationship Issues');
                  if (student['bodyimage_selflisten'] == true) redFlags.add('Body Image/Self-listen');
                  if (student['sleep'] == true) redFlags.add('Sleep Issues');
                  if (student['conduct_delnquency'] == true) redFlags.add('Conduct/Delinquency');

                  // Join the redflags as a comma-separated string
                  final redFlagsText = redFlags.isNotEmpty ? redFlags.join(', ') : 'No red flags';

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${student['student_name']}'),
                          Text('School: ${student['school_name']}'),
                          Text('EMIS No: ${student['student_emis_id']}'),
                          Text('Redflags: $redFlagsText'),
                          ElevatedButton(
                            onPressed: () {
                              handleCure(student['student_emis_id']);
                            },
                            child: Text('Cured'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
