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

  Widget buildRow(String label, dynamic value) {
    String displayValue = value != null ? value.toString() : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Expanded(
            child: Text(
              displayValue,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Keep clean white background
      appBar: AppBar(
        title: const Text(
          'Red Flag Students',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(105, 128, 136, 1.0)),
        ),
        backgroundColor: const Color.fromRGBO(1, 69, 68, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: students.isEmpty
            ? const Center(
                child: Text(
                  "No Red Flag Students Found",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildRow('Name', student['student_name']),
                          buildRow('School', student['school_name']),
                          buildRow('Gender', student['gender']),
                          buildRow('EMIS No', student['student_emis_id']),
                          buildRow('Red Flags', (student['redflags'] ?? []).join(', ')),

                          const SizedBox(height: 12),
                          // Buttons in a Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.check, color: Colors.white),
                                  label: const Text('Approve'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    handleApproval(student['student_emis_id'], true);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.cancel, color: Colors.white),
                                  label: const Text('Decline'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final rejectReason = await showDeclineReasonForm(context);
                                    if (rejectReason != null && rejectReason.isNotEmpty) {
                                      handleApproval(student['student_emis_id'], false);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                         SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                            height: 56, // Increased height for better tap area
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.local_hospital, color: Colors.white),
                              label: const Text(
                                'Emergency',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                final result = await showCuredForm(context, student['student_emis_id']);
                                if (result != null) {
                                  handleEmergency(student['student_emis_id'], result);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<String?> showDeclineReasonForm(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String reason = "";

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Decline Reason'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Enter reason for decline'),
              onChanged: (value) {
                reason = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Reason is required';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop(reason);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
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

   Future<void> handleEmergency(String emisId, Map<String, dynamic> formData) async {
    try {
      final url = Uri.parse('http://13.232.9.135:3000/api/cured');
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
}
