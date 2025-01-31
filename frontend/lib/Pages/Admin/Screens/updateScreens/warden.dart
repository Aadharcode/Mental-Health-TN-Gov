import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateWardenForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isUpdate;

  UpdateWardenForm({this.initialData, this.isUpdate = false});

  @override
  _UpdateWardenFormState createState() => _UpdateWardenFormState();
}

class _UpdateWardenFormState extends State<UpdateWardenForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, String> formData;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    formData = {
      'DISTRICT': widget.initialData?['DISTRICT'] ?? '',
      'NAME': widget.initialData?['NAME'] ?? '',
      'GENDER': widget.initialData?['GENDER'] ?? '',
      'DESIGNATION': widget.initialData?['DESIGNATION'] ?? '',
      'mobile_number': widget.initialData?['mobile_number'] ?? '',
      'Email': widget.initialData?['Email'] ?? '',
    };
  }

  Future<void> handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        String endpoint = widget.isUpdate
            ? "http://13.232.9.135:3000/api/updateWarden"
            : "http://13.232.9.135:3000/api/createWarden";

        final response = await http.put(
          Uri.parse(endpoint),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(formData),
        );

        final responseData = json.decode(response.body);

        if (response.statusCode == 200 || responseData.containsKey('msg')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['msg'] ?? 'Operation successful!')),
          );
          if (!widget.isUpdate) {
            _formKey.currentState!.reset();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['msg'] ?? 'Operation failed!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
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
          title: Text(widget.isUpdate ? 'Update Warden' : 'Add Warden'),
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
                    widget.isUpdate ? 'Update Warden Details' : 'Add Warden Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE9967A),
                    ),
                  ),
                  ...[ 
                    {'label': 'District', 'field': 'DISTRICT'},
                    {'label': 'Name', 'field': 'NAME'},
                    {'label': 'Gender', 'field': 'GENDER'},
                    {'label': 'Designation', 'field': 'DESIGNATION'},
                    {'label': 'Mobile Number', 'field': 'mobile_number', 'readOnly': widget.isUpdate},
                    {'label': 'Email', 'field': 'Email'},
                    if (!widget.isUpdate) {'label': 'Password', 'field': 'password'},
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
                          TextFormField(
                            initialValue: formData[fieldData['field']] ?? '',
                            readOnly: fieldData['readOnly'] as bool? ?? false, // Safely cast as bool
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
