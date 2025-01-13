import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateSchoolForm extends StatefulWidget {
  final Map<String, dynamic>? initialData; // Existing data for pre-filling
  final bool isUpdate; // Indicates whether this is an update operation

  UpdateSchoolForm({this.initialData, this.isUpdate = false});

  @override
  _UploadSchoolFormState createState() => _UploadSchoolFormState();
}

class _UploadSchoolFormState extends State<UpdateSchoolForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, String> formData;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize form data with either initialData or empty values
    formData = {
      'udise_no': widget.initialData?['udise_no'] ?? '',
      'SCHOOL_NAME': widget.initialData?['SCHOOL_NAME'] ?? '',
      'DISTRICT': widget.initialData?['DISTRICT'] ?? '',
      'HM_MOBILE_NO': widget.initialData?['HM_MOBILE_NO'] ?? '',
      'HM_NAME': widget.initialData?['HM_NAME'] ?? '',
      'SCHOOL_MAIL_ID': widget.initialData?['SCHOOL_MAIL_ID'] ?? '',
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
          ? "http://192.168.10.250:3000/api/updateSchool"
          : "http://192.168.10.250:3000/api/createSchool";

      print("🌐 API Endpoint: $endpoint");
      print("📤 Sending data: ${json.encode({
        'udise_no': formData['udise_no'],
        'District': formData['District'],
        'SCHOOL_NAME': formData['SCHOOL_NAME'],
        'HM_MOBILE_NO': formData['HM_MOBILE_NO'],
        'HM_NAME': formData['HM_NAME'],
        'SCHOOL_MAIL_ID': formData['SCHOOL_MAIL_ID'],
        if (!widget.isUpdate) 'password': formData['password'],
      })}");

      final response = await http.put(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'udise_no': formData['udise_no'],
          'SCHOOL_NAME': formData['SCHOOL_NAME'],
          'DISTRICT': formData['DISTRICT'],
          'HM_MOBILE_NO': formData['HM_MOBILE_NO'],
          'HM_NAME': formData['HM_NAME'],
          'SCHOOL_MAIL_ID': formData['SCHOOL_MAIL_ID'],
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
          title: Text(widget.isUpdate ? 'Update School' : 'Add School'),
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
                    widget.isUpdate ? 'Update School Details' : 'Add School Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE9967A),
                    ),
                  ),
                  ...[ 
                      {'label': 'udise_no', 'field': 'udise_no', 'readOnly': widget.isUpdate},
                      {'label': 'School Name', 'field': 'SCHOOL_NAME'},
                      {'label': 'district', 'field': 'DISTRICT'},
                      {'label': 'Mobile Number', 'field': 'HM_MOBILE_NO'},
                      {'label': ' Name', 'field': 'HM_NAME'},
                      {'label': 'Mail Id', 'field': 'SCHOOL_MAIL_ID'},
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
