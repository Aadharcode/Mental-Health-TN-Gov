import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RedflagScreen extends StatefulWidget {
  final String studentName;
  final String emisId;

  const RedflagScreen({
    required this.studentName,
    required this.emisId,
    Key? key,
  }) : super(key: key);

  @override
  _RedflagScreenState createState() => _RedflagScreenState();
}

class _RedflagScreenState extends State<RedflagScreen> {
  // List of red flags
  final List<Map<String, dynamic>> redFlags = [
    {'name': 'Anxiety', 'key': 'anxiety', 'isChecked': false},
    {'name': 'Depression', 'key': 'depression', 'isChecked': false},
    {'name': 'Aggression & Violence', 'key': 'aggresion_violence', 'isChecked': false},
    {'name': 'Self-Harm & Suicide', 'key': 'selfharm_suicide', 'isChecked': false},
    {'name': 'Sexual Abuse', 'key': 'sexual_abuse', 'isChecked': false},
    {'name': 'Stress', 'key': 'stress', 'isChecked': false},
    {'name': 'Loss & Grief', 'key': 'loss_grief', 'isChecked': false},
    {'name': 'Relationship Issues', 'key': 'relationship', 'isChecked': false},
    {'name': 'Body Image & Self-Esteem', 'key': 'bodyimage_selflisten', 'isChecked': false},
    {'name': 'Sleep Issues', 'key': 'sleep', 'isChecked': false},
    {'name': 'Conduct & Delinquency', 'key': 'conduct_delinquency', 'isChecked': false},
  ];

  // Function to handle form submission
  Future<void> handleSubmit() async {
    Map<String, bool> updates = {
      for (var flag in redFlags)
        if (flag['isChecked'] == true) flag['key']: true,
    };

    if (updates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one red flag.')),
      );
      return;
    }

    final url = Uri.parse('http://13.232.9.135:3000/api/redflags');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_emis_id': widget.emisId,
          'updates': updates,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Red flags updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        final message = jsonDecode(response.body)['msg'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Failed to update red flags.')),
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
      backgroundColor: Colors.white, // Clean background
      appBar: AppBar(
        title: const Text(
          'Red Flag Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(1, 69, 68, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Name & EMIS ID
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(1, 69, 68, 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${widget.studentName} - ${widget.emisId}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(1, 69, 68, 1.0),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Title
            const Text(
              'Select Red Flags:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // Checkbox Container
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100], // Light background for separation
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  children: redFlags.map((flag) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        flag['name'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      activeColor: const Color.fromRGBO(1, 69, 68, 1.0),
                      value: flag['isChecked'],
                      onChanged: (bool? value) {
                        setState(() {
                          flag['isChecked'] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(1, 69, 68, 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
