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
  // Updated list of red flags and their states (selected or not)
  final List<Map<String, dynamic>> redFlags = [
    {'name': 'Anxiety', 'key': 'anxiety', 'isChecked': false},
    {'name': 'Depression', 'key': 'depression', 'isChecked': false},
    {'name': 'Aggresion + Violence', 'key': 'aggresion_violence', 'isChecked': false},
    {'name': 'SelfHarm + Suicide', 'key': 'selfharm_suicide', 'isChecked': false},
    {'name': 'Sexual Abuse', 'key': 'sexual_abuse', 'isChecked': false},
    {'name': 'Stress', 'key': 'stress', 'isChecked': false},
    {'name': 'Loss + Grief', 'key': 'loss_grief', 'isChecked': false},
    {'name': 'Relationship', 'key': 'relationship', 'isChecked': false},
    {'name': 'Body image + selflisten', 'key': 'bodyimage_selflisten', 'isChecked': false},
    {'name': 'Sleep', 'key': 'sleep', 'isChecked': false},
    {'name': 'Conduct + Delinquency', 'key': 'conduct_delinquency', 'isChecked': false},
  ];

  // Function to handle form submission
  Future<void> handleSubmit() async {
    // Collect selected red flags
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

    // API endpoint
    final url = Uri.parse('http://192.168.162.250:3000/api/redflags');

    try {
      // Make the POST request
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
        Navigator.pop(context); // Navigate back on success
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
      appBar: AppBar(
        title: Text('Redflag Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.studentName} - ${widget.emisId}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Select Redflags:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: ListView(
                children: redFlags.map((flag) {
                  return CheckboxListTile(
                    title: Text(flag['name']),
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
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Center(
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
