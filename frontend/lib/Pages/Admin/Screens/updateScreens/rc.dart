import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateRCForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isUpdate;

  UpdateRCForm({this.initialData, this.isUpdate = false});

  @override
  _UpdateRCFormState createState() => _UpdateRCFormState();
}

class _UpdateRCFormState extends State<UpdateRCForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, String> formData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    formData = {
      'Zone': widget.initialData?['Zone'] ?? '',
      'Name': widget.initialData?['Name'] ?? '',
      'mobile_number': widget.initialData?['mobile_number'] ?? '',
      'email': widget.initialData?['email'] ?? '',
      'password': '',
    };
  }

  Future<void> handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        String endpoint = widget.isUpdate
            ? "http://13.232.9.135:3000/api/updateRC"
            : "http://13.232.9.135:3000/api/createRC";

        final response = await http.put(
          Uri.parse(endpoint),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'Zone': formData['Zone'],
            'Name': formData['Name'],
            'mobile_number': formData['mobile_number'],
            'email': formData['email'],
            if (!widget.isUpdate) 'password': formData['password'],
          }),
        );

        final responseData = json.decode(response.body);

        if (response.statusCode == 200 || responseData.containsKey('msg')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['msg'] ?? 'Operation successful!')),
          );
          if (!widget.isUpdate) _formKey.currentState!.reset();
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
        setState(() => _isLoading = false);
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
          title: Text(widget.isUpdate ? 'Update RC' : 'Add RC'),
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
                    widget.isUpdate ? 'Update RC Details' : 'Add RC Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE9967A)),
                  ),
                  ...[
                    {'label': 'Zone', 'field': 'Zone'},
                    {'label': 'Name', 'field': 'Name'},
                    {'label': 'Mobile Number', 'field': 'mobile_number'},
                    {'label': 'Email', 'field': 'email', 'readOnly': widget.isUpdate},
                    if (!widget.isUpdate) {'label': 'Password', 'field': 'password'},
                  ].map((fieldData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fieldData['label']! as String,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            initialValue: formData[fieldData['field'] as String] ?? '',
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
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(widget.isUpdate ? 'Update' : 'Add',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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