import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../backendUrl.dart';

class UploadSchoolForm extends StatefulWidget {
  @override
  _UploadSchoolFormState createState() => _UploadSchoolFormState();
}

class _UploadSchoolFormState extends State<UploadSchoolForm> {
  final Map<String, String> formData = {
    'schoolName': '',
    'district': '',
    'udiseNo': '',
    'schoolMailID': '',
    'hmName': '',
    'hmMobile': '',
  };

  bool _isLoading = false;

  // Function to handle form submission
  Future<void> handleUpload() async {
    // Check if all fields are filled
    if (formData.values.any((value) => value.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading spinner
    });

    try {
      // Endpoint for your API
      const String endpoint = "BackendUrl.baseUrl/createSchool"; // Replace with your backend URL

      // Send a POST request
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'SCHOOL_NAME': formData['schoolName'],
          'DISTRICT': formData['district'],
          'udise_no': formData['udiseNo'],
          'SCHOOL_MAIL_ID': formData['schoolMailID'],
          'HM_NAME': formData['hmName'],
          'HM_MOBILE_NO': formData['hmMobile'],
          'password': 'defaultPassword', // You may want to handle password input too
        }),
      );

      final responseData = json.decode(response.body);

      // Handle the response
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['msg'] ?? 'School created successfully!')),
        );
        // Optionally, clear the form or reset
        setState(() {
          formData.forEach((key, value) {
            formData[key] = ''; // Reset the form
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['msg'] ?? 'Failed to create school')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading spinner
      });
    }
  }

  // Function to handle text field changes
  void handleChange(String field, String value) {
    setState(() {
      formData[field] = value;
    });
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
          title: Text('Upload School Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Upload School details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE9967A), // Light orange color
                    ),
                  ),
                ),
                // Form Fields Section
                ...[
                  {'label': 'School Name', 'field': 'schoolName'},
                  {'label': 'District', 'field': 'district'},
                  {'label': 'UDISE NO.', 'field': 'udiseNo'},
                  {'label': 'School mailID', 'field': 'schoolMailID'},
                  {'label': 'HM Name', 'field': 'hmName'},
                  {'label': 'HM Mobile No', 'field': 'hmMobile'},
                ].map((fieldData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fieldData['label']!,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          onChanged: (value) =>
                              handleChange(fieldData['field']!, value),
                          decoration: InputDecoration(
                            hintText: fieldData['label'],
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
                    onPressed: _isLoading ? null : handleUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE9967A), // Light orange color
                      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Capsule shape
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
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
