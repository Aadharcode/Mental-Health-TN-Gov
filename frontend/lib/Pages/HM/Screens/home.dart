import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'Redflag.dart';
// import '../../../backendUrl.dart';

class HomeScreen extends StatefulWidget {
  final String? SCHOOL_NAME;
  final String? District;

   HomeScreen({required this.SCHOOL_NAME, required this.District});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controllers for School Name and District
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController districtController = TextEditingController(); // For district

  // Function to search for students based on school name and district
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

        // Modify the student data to include only the redflags that are true
        for (var student in students) {
          List<String> redflags = [];
          
          // Add redflags that are true to the redflags list
          if (student['sexual_abuse'] == true) redflags.add('Sexual Abuse');
          if (student['stress'] == true) redflags.add('Stress');
          if (student['loss_grief'] == true) redflags.add('Loss/Grief');
          if (student['relationship'] == true) redflags.add('Relationship');
          
          // You can add other conditions for redflags as needed, for example:
          if (student['anxiety'] == true) redflags.add('Anxiety');
          if (student['depression'] == true) redflags.add('Depression');
          if (student['aggresion_violence'] == true) redflags.add('Aggression/Violence');
          if (student['selfharm_suicide'] == true) redflags.add('Self-harm/Suicide');
          if (student['bodyimage_selflisten'] == true) redflags.add('Body Image/Self-esteem');
          if (student['sleep'] == true) redflags.add('Sleep Issues');
          if (student['conduct_delinquency'] == true) redflags.add('Conduct/Delinquency');
          
          // Add the redflags list to the student data
          student['redflags'] = redflags;
        }

        // Navigate to the RedflagScreen with the modified student data
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 24),
              Text(
                'Redflag list',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: searchStudents,  // Trigger the search
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('See Red Flag Students'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
