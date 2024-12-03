import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../backendUrl.dart';

class UploadTeacherForm extends StatefulWidget {
  @override
  _UploadTeacherFormState createState() => _UploadTeacherFormState();
}

class _UploadTeacherFormState extends State<UploadTeacherForm> {
  final Map<String, String> formData = {
    'district': '',
    'school': '',
    'teacherName': '',
    'mobile': '',
    'password': '',
  };

  // Controllers for each input field
  late TextEditingController _districtController;
  late TextEditingController _schoolController;
  late TextEditingController _teacherNameController;
  late TextEditingController _mobileController;
  late TextEditingController _passwordController;

  final String apiUrl = 'BackendUrl.baseUrl/createTeacher';

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values
    _districtController = TextEditingController(text: formData['district']);
    _schoolController = TextEditingController(text: formData['school']);
    _teacherNameController = TextEditingController(text: formData['teacherName']);
    _mobileController = TextEditingController(text: formData['mobile']);
    _passwordController = TextEditingController(text: formData['password']);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _districtController.dispose();
    _schoolController.dispose();
    _teacherNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void handleUpload() async {
    // Validate required fields
    if (_districtController.text.isEmpty ||
        _schoolController.text.isEmpty ||
        _teacherNameController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      // Show error message if fields are empty
      showErrorMessage("Please provide all required fields.");
      return;
    }

    try {
      // Send the data to the backend
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'district': _districtController.text,
          'School_name': _schoolController.text,
          'Teacher_Name': _teacherNameController.text,
          'mobile_number': _mobileController.text,
          'password': _passwordController.text,
        }),
      );

      // Decode the response
      final responseData = jsonDecode(response.body);
      print(responseData);

      // Check if the response contains the success message
      if (responseData['msg'] == 'Teacher created successfully!') {
        // If the server returns a successful response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Teacher uploaded successfully!')),
        );
      } else {
        // If the server returns an error message
        showErrorMessage("Failed to upload teacher data. Try again later.");
      }
    } catch (e) {
      // Handle any errors (e.g., network issues)
      showErrorMessage("An error occurred: $e");
      print(e);
    }
  }

  // Show error message
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
          title: Text('Upload Teacher Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...[
                  {'label': 'Teacher Name', 'field': 'teacherName', 'controller': _teacherNameController},
                  {'label': 'School Name', 'field': 'school', 'controller': _schoolController},
                  {'label': 'District', 'field': 'district', 'controller': _districtController},
                  {'label': 'Mobile Number', 'field': 'mobile', 'controller': _mobileController},
                  {'label': 'Password', 'field': 'password', 'controller': _passwordController, 'isPassword': true},
                ].map((fieldData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fieldData['label'] as String,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: fieldData['controller'] as TextEditingController,
                          onChanged: (value) {
                            formData[fieldData['field'] as String] = value;
                          },
                          obscureText: fieldData['isPassword'] == true,
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
                Center(
                  child: ElevatedButton(
                    onPressed: handleUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE9967A), // Light orange color
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
