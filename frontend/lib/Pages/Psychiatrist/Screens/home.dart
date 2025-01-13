import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> redFlaggedStudents = [];

  @override
  void initState() {
    super.initState();
    fetchRedFlaggedStudents();
  }

  Future<void> fetchRedFlaggedStudents() async {
    try {
      final url = Uri.parse('http://13.232.9.135:3000/approvedStudents');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          redFlaggedStudents = data['data'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No red-flagged students found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> handleCure(String emisId, Map<String, dynamic> formData) async {
  try {
    print("🔄 Sending cure request for student with EMIS ID: $emisId...");
    print("📤 Request data: ${jsonEncode({
      'student_emis_id': emisId,
      'approve': false,
      'case_status': formData['case_status'],
      'medicine_bool': formData['medicine_bool'],
      'medicine': formData['medicine'],
      'referal_bool': formData['referal_bool'],
      'referal': formData['referal'],
    })}");

    if(formData['referal'].isEmpty){
      formData['referal'] = null;    }

    final url = Uri.parse('http://192.168.10.250:3000/api/cured');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'student_emis_id': emisId,
        'approve': false,
        'case_status': formData['case_status'],
        'medicine_bool': formData['medicine_bool'],
        'medicine': formData['medicine'],
        'referal_bool': formData['referal_bool'],
        'referal': formData['referal'],
      }),
    );

    if (response.statusCode == 200) {
      print("✅ Cure request successful for student EMIS ID: $emisId.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student cured')),
      );
      setState(() {
        redFlaggedStudents.removeWhere((student) => student['student_emis_id'] == emisId);
      });
    } else {
      final message = jsonDecode(response.body)['msg'];
      print("❌ Cure request failed. Response: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Failed to update student status')),
      );
    }
  } catch (e) {
    print("⚠️ An error occurred while sending the cure request: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
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
                            medicine = null; // Reset medicine details if unchecked
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
                            referal = null; // Reset referral details if unchecked
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



  Future<void> markAttendance() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('DISTRICT_PSYCHIATRIST_NAME');

      final url = Uri.parse('http://192.168.10.250:3000/api/attendance');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'psychiatristName': name,
          'latitude': position.latitude,
          'longitude': position.longitude,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance marked successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark attendance')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Red-Flagged Students'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: markAttendance,
              child: Text('Mark Attendance'),
            ),
            redFlaggedStudents.isEmpty
                ? Center(child: Text('No red-flagged students found.'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: redFlaggedStudents.length,
                      itemBuilder: (context, index) {
                        final student = redFlaggedStudents[index];
                        return ListTile(
                          title: Text(student['student_name']),
                          subtitle: Text('School: ${student['school_name']}'),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              final formData = await showCuredForm(context, student['student_emis_id']);
                              if (formData != null) {
                                await handleCure(student['student_emis_id'], formData);
                              }
                            },
                            child: Text('Cured'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
