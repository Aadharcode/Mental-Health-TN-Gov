import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateCIFForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isUpdate;

  UpdateCIFForm({this.initialData, this.isUpdate = false});

  @override
  _UpdateCIFFormState createState() => _UpdateCIFFormState();
}

class _UpdateCIFFormState extends State<UpdateCIFForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, String> formData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    formData = {
      'mobile_number': widget.initialData?['mobile_number'] ?? '',
      'School_Name': widget.initialData?['School_Name'] ?? '',
      'CIF_Name': widget.initialData?['CIF_Name'] ?? '',
      'Phase': widget.initialData?['Phase'] ?? '',
      'RC': widget.initialData?['RC'] ?? '',
      'Willing_to_join_CUG': widget.initialData?['Willing_to_join_CUG'] ?? '',
      'CIF_Mail_id': widget.initialData?['CIF_Mail_id'] ?? '',
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
            ? "http://your-api-endpoint/updateCIF"
            : "http://your-api-endpoint/createCIF";

        final response = await http.put(
          Uri.parse(endpoint),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(formData),
        );

        final responseData = json.decode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['msg'] ?? 'Operation successful!')),
        );

        if (!widget.isUpdate) {
          _formKey.currentState!.reset();
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
          title: Text(widget.isUpdate ? 'Update CIF' : 'Add CIF'),
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
                    widget.isUpdate ? 'Update CIF Details' : 'Add CIF Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(1, 69, 68, 1.0),
                    ),
                  ),
                  ...[
                    {'label': 'Mobile Number', 'field': 'mobile_number'},
                    {'label': 'School Name', 'field': 'School_Name'},
                    {'label': 'CIF Name', 'field': 'CIF_Name'},
                    {'label': 'Phase', 'field': 'Phase'},
                    {'label': 'RC', 'field': 'RC'},
                    {'label': 'Willing to Join CUG', 'field': 'Willing_to_join_CUG'},
                    {'label': 'CIF Mail ID', 'field': 'CIF_Mail_id', 'readOnly': widget.isUpdate},
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
                        backgroundColor: Color.fromRGBO(1, 69, 68, 1.0),
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
