import 'package:flutter/material.dart';

class UploadStudentForm extends StatefulWidget {
  @override
  _UploadStudentFormState createState() => _UploadStudentFormState();
}

class _UploadStudentFormState extends State<UploadStudentForm> {
  final Map<String, String> formData = {
    'name': '',
    'school': '',
    'district': '',
    'emisNo': '',
    'grade': '',
    'gender': '',
    'groupCode': '',
    'groupName': '',
    'medium': '',
  };

  void handleUpload() {
    print('Form data: $formData');
    // Handle upload logic here
  }

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
          title: Text('Upload Student Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...[
                  {'label': 'Name', 'field': 'name'},
                  {'label': 'School', 'field': 'school'},
                  {'label': 'District', 'field': 'district'},
                  {'label': 'EMIS No.', 'field': 'emisNo'},
                  {'label': 'Grade', 'field': 'grade'},
                  {'label': 'Gender', 'field': 'gender'},
                  {'label': 'Group Code', 'field': 'groupCode'},
                  {'label': 'Group Name', 'field': 'groupName'},
                  {'label': 'Medium', 'field': 'medium'},
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
