import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import '../../../backendUrl.dart';

class UploadPsychiatristForm extends StatefulWidget {
  @override
  _UploadPsychiatristFormState createState() => _UploadPsychiatristFormState();
}

class _UploadPsychiatristFormState extends State<UploadPsychiatristForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> formData = {
    'district': '',
    'DISTRICT_PSYCHIATRIST_NAME': '',
    'Mobile_number': '',
    'SATELLITE_PSYCHIATRIST_NAME': '',
    'SATELLITE_mobile_number': '',
    'password': '',
  };

  bool _isLoading = false;

  Future<void> handleUpload() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      const String endpoint = "http://13.232.9.135:3000/createPsychiatrist"; 

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "district": formData['district'],
          "DISTRICT_PSYCHIATRIST_NAME": formData['DISTRICT_PSYCHIATRIST_NAME'],
          "Mobile_number": formData['Mobile_number'],
          "SATELLITE_PSYCHIATRIST_NAME": formData['SATELLITE_PSYCHIATRIST_NAME'],
          "SATELLITE_mobile_number": formData['SATELLITE_mobile_number'],
          "password": formData['password'],
        }),
      );

      final responseData = json.decode(response.body);
      
      
      if (responseData.containsKey('msg')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['msg'] ?? 'Psychiatrist added successfully!')),
        );
        _formKey.currentState!.reset(); 
      } else {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add psychiatrist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          title: Text('Upload Psychiatrist Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Upload Psychiatrist details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(1, 69, 68, 1.0), // Light orange color
                      ),
                    ),
                  ),

                  // Form Fields Section
                  ...[
                    {'label': 'District', 'field': 'district'},
                    {'label': 'District Psychiatrist Name', 'field': 'DISTRICT_PSYCHIATRIST_NAME'},
                    {'label': 'Mobile Number', 'field': 'Mobile_number'},
                    {'label': 'Satellite Psychiatrist Name', 'field': 'SATELLITE_PSYCHIATRIST_NAME'},
                    {'label': 'Satellite Mobile Number', 'field': 'SATELLITE_mobile_number'},
                    {'label': 'Password', 'field': 'password'},
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
                          TextFormField(
                            obscureText: fieldData['field'] == 'password',
                            onSaved: (value) => formData[fieldData['field']!] = value ?? '',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '${fieldData['label']} is required';
                              }
                              return null;
                            },
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

                  // Centered Upload Button with Capsule Border Radius
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : handleUpload,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(1, 69, 68, 1.0), // Light orange color
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
      ),
    );
  }
}