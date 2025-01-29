import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateTeacherForm extends StatefulWidget {
  final Map<String, dynamic>? initialData; // Existing data for pre-filling
  final bool isUpdate; // Indicates whether this is an update operation

  UpdateTeacherForm({this.initialData, this.isUpdate = false});

  @override
  _UploadTeacherFormState createState() => _UploadTeacherFormState();
}

class _UploadTeacherFormState extends State<UpdateTeacherForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, String> formData;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize form data with either initialData or empty values
    formData = {
      'district': widget.initialData?['district'] ?? '',
      'School_name': widget.initialData?['School_name'] ?? '',
      'Mobile_number': widget.initialData?['Mobile_number'] ?? '',
      'Teacher_Name': widget.initialData?['Teacher_Name'] ?? '',
      'password': '',
    };
  }

 Future<void> handleSubmit() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    print("📝 Form validated and saved. Preparing to submit...");

    try {
      String endpoint = widget.isUpdate
          ? "http://13.232.9.135:3000/api/updateTeacher"
          : "http://13.232.9.135:3000/api/createTeacher";

      print("🌐 API Endpoint: $endpoint");
      print("📤 Sending data: ${json.encode({
        'district': formData['district'],
        'School_name': formData['School_name'],
        'Mobile_number': formData['Mobile_number'],
        'Teacher_Name': formData['Teacher_Name'],
        if (!widget.isUpdate) 'password': formData['password'],
      })}");

      final response = await http.put(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'district': formData['district'],
          'School_name': formData['School_name'],
          'Mobile_number': formData['Mobile_number'],
          'Teacher_Name': formData['Teacher_Name'],
          
          if (!widget.isUpdate) 'password': formData['password'],
        }),
      );

      print("📥 Received response: ${response.body}");

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || responseData.containsKey('msg')) {
        print("✅ Operation successful!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['msg'] ?? 'Operation successful!')),
        );
        if (!widget.isUpdate) {
          _formKey.currentState!.reset(); // Reset form for new entry
          print("🔄 Form reset for new entry.");
        }
      } else {
        print("❌ Operation failed with message: ${responseData['msg']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['msg'] ?? 'Operation failed!')),
        );
      }
    } catch (e) {
      print("⚠️ An error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      print("🚀 Request complete. Loading state set to false.");
    }
  } else {
    print("❌ Form validation failed.");
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
          title: Text(widget.isUpdate ? 'Update Teacher' : 'Add Teacher'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isUpdate ? 'Update Psychiatrist Details' : 'Add Psychiatrist Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE9967A),
                    ),
                  ),
                  ...[ 
                      {'label': 'teacher Name', 'field': 'Teacher_Name'},
                      {'label': 'District', 'field': 'district', 'readOnly': widget.isUpdate},
                      {'label': 'School Name', 'field': 'School_name'},
                      {'label': 'Mobile Number', 'field': 'Mobile_number'},
                      if (!widget.isUpdate) {'label': 'Password', 'field': 'password'},
                    ].map((fieldData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fieldData['label']! as String, // Cast to String
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              initialValue: formData[fieldData['field'] as String] ?? '', // Safely access as String
                              readOnly: fieldData['readOnly'] as bool? ?? false, // Safely cast as bool
                              obscureText: fieldData['field'] == 'password',
                              onSaved: (value) => formData[fieldData['field'] as String] = value ?? '',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '${fieldData['label']} is required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: fieldData['label'] as String,
                                filled: true,
                                fillColor: (fieldData['readOnly'] as bool? ?? false)
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade200,
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
                      onPressed: _isLoading ? null : handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE9967A),
                        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.isUpdate ? 'Update' : 'Add',
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
