import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../backendUrl.dart';

class RedflagScreen extends StatefulWidget {
  final List<dynamic> students; // A list of students (from the backend)

  RedflagScreen({required this.students});

  @override
  _RedflagScreenState createState() => _RedflagScreenState();
}

class _RedflagScreenState extends State<RedflagScreen> {
  List<dynamic> students = [];

  @override
  void initState() {
    super.initState();
    students = widget.students; // Initialize the list with the students passed from the HomeScreen
  }

  // Handle approval or cancellation
  Future<void> handleApproval(String emisId, bool approve) async {
    try {
      final url = Uri.parse('http://13.232.9.135:3000/api/approval');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_emis_id': emisId,
          'approve': approve,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['msg'])),
        );

        // Remove the approved/canceled student from the list
        setState(() {
          students.removeWhere((student) => student['student_emis_id'] == emisId);
        });
      } else {
        final message = jsonDecode(response.body)['msg'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Failed to update approval')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  // Utility method to build label-value rows, handling null values
  Widget buildRow(String label, dynamic value) {
    String displayValue = value != null ? value.toString() : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: Text(displayValue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redflag Students'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
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
                    buildRow('Name', student['student_name']),
                    buildRow('School', student['school_name']),
                    buildRow('Gender', student['gender']),
                    buildRow('EMIS No', student['student_emis_id']),
                    buildRow('Redflags', (student['redflags'] ?? []).join(', ')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            handleApproval(student['student_emis_id'], true);
                          },
                          child: Text('Approve'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            handleApproval(student['student_emis_id'], false);
                          },
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        ),
                      ],
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
