import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RedflagScreen extends StatefulWidget {
  final List<dynamic> students;

  RedflagScreen({required this.students});

  @override
  _RedflagScreenState createState() => _RedflagScreenState();
}

class _RedflagScreenState extends State<RedflagScreen> {
  List<dynamic> students = [];

  @override
  void initState() {
    super.initState();
    students = widget.students;
  }

  Future<void> handleApproval(String emisId, bool approve) async {
    try {
      final url = Uri.parse('http://13.232.9.135:3000/api/approval');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_emis_id': emisId,
          'approve': approve,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['msg'])),
        );

        setState(() {
          students.removeWhere((student) => student['student_emis_id'] == emisId);
        });
      } else {
        final message = jsonDecode(response.body)['msg'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Failed to update approval')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> handleEmergency(String emisId, Map<String, dynamic> formData) async {
    try {
      final url = Uri.parse('http://192.168.10.250:3000/api/cured');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_emis_id': emisId,
          ...formData,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['msg'])),
        );

        setState(() {
          students.removeWhere((student) => student['student_emis_id'] == emisId);
        });
      } else {
        final message = jsonDecode(response.body)['msg'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Failed to update emergency data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Widget buildRow(String label, dynamic value) {
    String displayValue = value != null ? value.toString() : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                displayValue,
                overflow: TextOverflow.visible,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> showCuredForm(BuildContext context, String emisId) async {
    final _formKey = GlobalKey<FormState>();
    String? caseStatus = "completed";
    bool medicineBool = false;
    String? medicine;
    bool referalBool = false;
    String? referal;

    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cure Student'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: caseStatus,
                        items: ['completed', 'ongoing']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            caseStatus = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Case Status'),
                      ),
                      SwitchListTile(
                        title: Text('Medicine Required?'),
                        value: medicineBool,
                        onChanged: (value) {
                          setState(() {
                            medicineBool = value;
                            if (!medicineBool) {
                              medicine = null;
                            }
                          });
                        },
                      ),
                      if (medicineBool)
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Medicine Details'),
                          onChanged: (value) {
                            medicine = value;
                          },
                          validator: (value) {
                            if (medicineBool && (value == null || value.isEmpty)) {
                              return 'Please provide medicine details';
                            }
                            return null;
                          },
                        ),
                      SwitchListTile(
                        title: Text('Referral Required?'),
                        value: referalBool,
                        onChanged: (value) {
                          setState(() {
                            referalBool = value;
                            if (!referalBool) {
                              referal = null;
                            }
                          });
                        },
                      ),
                      if (referalBool)
                        DropdownButtonFormField<String>(
                          value: referal,
                          items: ["district", "others"]
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            referal = value;
                          },
                          validator: (value) {
                            if (referalBool && (value == null || value.isEmpty)) {
                              return 'Please select a referral type';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Referral Details'),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    'case_status': caseStatus,
                    'medicine_bool': medicineBool,
                    'medicine': medicine ?? "",
                    'referal_bool': referalBool,
                    'referal': referal ?? "",
                  });
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redflag Students'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildRow('Name', student['student_name']),
                    buildRow('School', student['school_name']),
                    buildRow('Gender', student['gender']),
                    buildRow('EMIS No', student['student_emis_id']),
                    buildRow('Redflags', (student['redflags'] ?? []).join(', ')),
                    Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Flexible(
      child: ElevatedButton(
        onPressed: () {
          handleApproval(student['student_emis_id'], true);
        },
        child: FittedBox(
          child: Text('Approve'),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: Size(100, 40),
        ),
      ),
    ),
    SizedBox(width: 8), // Adds spacing between buttons
    Flexible(
      child: ElevatedButton(
        onPressed: () {
          handleApproval(student['student_emis_id'], false);
        },
        child: FittedBox(
          child: Text('Cancel'),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          minimumSize: Size(100, 40),
        ),
      ),
    ),
    SizedBox(width: 8), // Adds spacing between buttons
    Flexible(
      child: ElevatedButton(
        onPressed: () async {
          final result = await showCuredForm(context, student['student_emis_id']);
          if (result != null) {
            handleEmergency(student['student_emis_id'], result);
          }
        },
        child: FittedBox(
          child: Text('Emergency'),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          minimumSize: Size(100, 40),
        ),
      ),
    ),
  ],
),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
