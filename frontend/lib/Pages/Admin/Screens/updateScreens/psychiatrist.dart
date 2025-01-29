import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdatePsychiatristForm extends StatefulWidget {
  final Map<String, dynamic>? initialData; // Existing data for pre-filling
  final bool isUpdate; // Indicates whether this is an update operation

  UpdatePsychiatristForm({this.initialData, this.isUpdate = false});

  @override
  _UploadPsychiatristFormState createState() => _UploadPsychiatristFormState();
}

class _UploadPsychiatristFormState extends State<UpdatePsychiatristForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, String> formData;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize form data with either initialData or empty values
    formData = {
      'district': widget.initialData?['district'] ?? '',
      'DISTRICT_PSYCHIATRIST_NAME': widget.initialData?['DISTRICT_PSYCHIATRIST_NAME'] ?? '',
      'Mobile_number': widget.initialData?['Mobile_number'] ?? '',
      'SATELLITE_PSYCHIATRIST_NAME': widget.initialData?['SATELLITE_PSYCHIATRIST_NAME'] ?? '',
      'SATELLITE_mobile_number': widget.initialData?['SATELLITE_mobile_number'] ?? '',
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
          ? "http://13.232.9.135:3000/api/updatePsychiatrist"
          : "http://13.232.9.135:3000/api/createPsychiatrist";

      print("🌐 API Endpoint: $endpoint");
      print("📤 Sending data: ${json.encode({
        'district': formData['district'],
        'DISTRICT_PSYCHIATRIST_NAME': formData['DISTRICT_PSYCHIATRIST_NAME'],
        'Mobile_number': formData['Mobile_number'],
        'SATELLITE_PSYCHIATRIST_NAME': formData['SATELLITE_PSYCHIATRIST_NAME'],
        'SATELLITE_mobile_number': formData['SATELLITE_mobile_number'],
        if (!widget.isUpdate) 'password': formData['password'],
      })}");

      final response = await http.put(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'district': formData['district'],
          'DISTRICT_PSYCHIATRIST_NAME': formData['DISTRICT_PSYCHIATRIST_NAME'],
          'Mobile_number': formData['Mobile_number'],
          'SATELLITE_PSYCHIATRIST_NAME': formData['SATELLITE_PSYCHIATRIST_NAME'],
          'SATELLITE_mobile_number': formData['SATELLITE_mobile_number'],
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
          title: Text(widget.isUpdate ? 'Update Psychiatrist' : 'Add Psychiatrist'),
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
                      {'label': 'District', 'field': 'district', 'readOnly': widget.isUpdate},
                      {'label': 'District Psychiatrist Name', 'field': 'DISTRICT_PSYCHIATRIST_NAME'},
                      {'label': 'Mobile Number', 'field': 'Mobile_number'},
                      {'label': 'Satellite Psychiatrist Name', 'field': 'SATELLITE_PSYCHIATRIST_NAME'},
                      {'label': 'Satellite Mobile Number', 'field': 'SATELLITE_mobile_number'},
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
