import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import '../../../backendUrl.dart';

class UploadStudentForm extends StatefulWidget {
  @override
  _UploadStudentFormState createState() => _UploadStudentFormState();
}

class _UploadStudentFormState extends State<UploadStudentForm> {
  final Map<String, String> formData = {
    'school_name': '',
    'student_emis_id': '',
    'student_name': '',
    'date_of_birth': '',
    'gender': '',
    'studentClass': '',
    'group_code': '',
    'group_name': '',
    'medium': '',
    'password': '',
  };

  DateTime? selectedDate;

  Future<void> handleUpload() async {
    final String apiUrl = 'http://13.232.9.135:3000/createStudent';

    // Create the request body
    final Map<String, String> requestBody = {
      'school_name': formData['school_name']!,
      'student_emis_id': formData['student_emis_id']!,
      'student_name': formData['student_name']!,
      'date_of_birth': formData['date_of_birth']!,
      'gender': formData['gender']!,
      'class': formData['studentClass']!,
      'group_code': formData['group_code']!,
      'group_name': formData['group_name']!,
      'medium': formData['medium']!,
      'password': formData['password']!,
    };
    print(requestBody);

    try {
      // Send a POST request to the backend API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // Directly checking for success message
      if (response.body.contains('Student created successfully!')) {
        // If the response contains the success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student created successfully!')),
        );
      } else {
        // If the response doesn't contain the success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create student: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Update the formData when the field changes
  void handleChange(String field, String value) {
    setState(() {
      // Capitalize the first letter of gender
      if (field == 'gender') {
        value = value[0].toUpperCase() + value.substring(1);
      }
      formData[field] = value;
    });
  }

  // Date picker for selecting the date of birth
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Format date to yyyy-mm-dd
        formData['date_of_birth'] = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Upload Student Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Upload Student details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(1, 69, 68, 1.0), // Light orange color
                    ),
                  ),
                ),
                // Form Fields Section
                ...[
                  {'label': 'School Name', 'field': 'school_name'},
                  {'label': 'Student EMIS ID', 'field': 'student_emis_id'},
                  {'label': 'Student Name', 'field': 'student_name'},
                  {'label': 'Date of Birth', 'field': 'date_of_birth'},
                  {'label': 'Gender', 'field': 'gender'},
                  {'label': 'Class', 'field': 'studentClass'},
                  {'label': 'Group Code', 'field': 'group_code'},
                  {'label': 'Group Name', 'field': 'group_name'},
                  {'label': 'Medium', 'field': 'medium'},
                  {'label': 'Password', 'field': 'password'},
                ].map((fieldData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fieldData['label'] as String, // Casting as String
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        fieldData['field'] == 'date_of_birth'
                            ? GestureDetector(
                                onTap: () => _selectDate(context),
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: formData['date_of_birth']),
                                    decoration: InputDecoration(
                                      hintText: 'Select Date of Birth',
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 12.0,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : TextField(
                                onChanged: (value) =>
                                    handleChange(fieldData['field'] as String, value),
                                decoration: InputDecoration(
                                  hintText: fieldData['label'] as String,
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 16),
                // Upload Button
                Center(
                  child: ElevatedButton(
                    onPressed: handleUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(1, 69, 68, 1.0), // Light orange color
                      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Capsule shape
                      ),
                    ),
                    child: Text(
                      'Upload',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
