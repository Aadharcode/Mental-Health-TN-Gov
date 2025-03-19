import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Teachers/Screens/victim_screen.dart';
import '../../utils/appStyle.dart';
import '../../utils/appColor.dart';
import '../../others/about.dart';
import '../../others/terms.dart';
import '../../Login/Login.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> redFlaggedStudents = [];
  bool isEntryMarked = false;
  bool isLoading = false;
  bool isButtonLoading = false;
  String? emisID;

  @override
  void initState() {
    super.initState();
    checkEntryStatus();
    fetchRedFlaggedStudents();
  }

   Future<void> _logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Erase stored login data

    // Navigate to Login Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> checkEntryStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isEntryMarked = prefs.containsKey('entry_latitude') && prefs.containsKey('entry_longitude');
    });
  }

  Future<void> fetchRedFlaggedStudents() async {
    setState(() => isLoading = true);
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
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> markEntryTime() async {
    setState(() => isButtonLoading = true);
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('DISTRICT_PSYCHIATRIST_NAME');

      final url = Uri.parse('http://13.232.9.135:3000/api/attendance');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'psychiatristName': name,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'entryExit': "entry",
        }),
      );

      if (response.statusCode == 201) {
        await prefs.setDouble('entry_latitude', position.latitude);
        await prefs.setDouble('entry_longitude', position.longitude);
        await prefs.setString('entry_time', DateTime.now().toIso8601String());

        setState(() {
          isEntryMarked = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entry marked successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark entry time')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() => isButtonLoading = false);
    }
  }

  void navigateToMarkVictimScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MarkVictimScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Color(0xFFE3F2FD),
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/Logo/logo_TNMS.png', height: 30),
            const SizedBox(width: 10),
            Text(
              'TNMSS',
              style: TextStyle(color: Color(0xFF014544), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'About') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              } else if (value == 'Terms') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsScreen()),
                );
              } else if (value == 'Logout') {
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'About', child: Text('About')),
              PopupMenuItem(value: 'Terms', child: Text('Terms and Conditions')),
              PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Section Title
              Row(
                children: [
                  const Icon(Icons.flag, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  const Text(
                    'Red Flagged Students',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Loading Indicator for Student List
              if (isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (redFlaggedStudents.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No red-flagged students found.',
                      style: TextStyle(color: AppColors.hintColor, fontSize: 16),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: redFlaggedStudents.length,
                    itemBuilder: (context, index) {
                      final student = redFlaggedStudents[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person_outline, color: AppColors.primaryColor),
                                  const SizedBox(width: 8),
                                  Text(student['student_name'], style: AppStyles.labelText),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.badge, color: AppColors.iconColor),
                                  const SizedBox(width: 8),
                                  Text("EMIS ID: ${student['student_emis_id']}", style: AppStyles.hintText),
                                ],
                              ),
                              const SizedBox(height: 4),
                             Row(
                                children: [
                                  const Icon(Icons.school, color: AppColors.iconColor),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "School: ${student['school_name']}",
                                      style: AppStyles.hintText,
                                      softWrap: true,
                                      // overflow: TextOverflow.ellipsis, // Add ellipsis if text is too long
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // SizedBox(
                              //   width: double.infinity,
                              //   child: ElevatedButton.icon(
                              //     style: AppStyles.buttonStyle,
                              //     onPressed: () {},
                              //     icon: const Icon(Icons.remove_red_eye, color: Colors.white),
                              //     label: const Text("View Details"),
                              //   ),
                              // ),
                              Row(
                                  children: [
                                    
                                    const SizedBox(width: 8),
                                    
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Emergency Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.local_hospital, color: Colors.white),
                                    label: const Text('Cured', style: TextStyle(fontSize: 16),),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      final result = await showCuredForm(context, student['student_emis_id']);
                                      if (result != null) {
                                        handleEmergency(student['student_emis_id'], result);
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 12),

              // Mark Entry/Exit & Report Incident Buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isButtonLoading ? null : (isEntryMarked ? markEntryTime : markEntryTime),
                  style: AppStyles.buttonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all(isEntryMarked ? Colors.red : Colors.blue),
                  ),
                  child: isButtonLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEntryMarked ? 'Mark Exit Time' : 'Mark Entry Time', style: AppStyles.buttonText),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => navigateToMarkVictimScreen(context),
                  style: AppStyles.buttonStyle.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text("Report Incident", style: AppStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleEmergency(String emisId, Map<String, dynamic> formData) async {
  try {
    final url = Uri.parse('http://13.232.9.135:3000/api/cured');
    print("🚀 Sending request to: $url");
    print("📨 Request Data: ${jsonEncode({'student_emis_id': emisId, ...formData})}");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'student_emis_id': emisId,
        ...formData,
      }),
    );

    print("📩 Response Status: ${response.statusCode}");
    print("📩 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("✅ Success: ${data['msg']}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['msg'])),
      );

      setState(() {
        redFlaggedStudents.removeWhere((student) => student['student_emis_id'] == emisId);
        print("🗑️ Removed student with EMIS ID: $emisId from redFlaggedStudents");
      });
    } else {
      final message = jsonDecode(response.body)['msg'];
      print("❌ Error: $message");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Failed to update emergency data')),
      );
    }
  } catch (e) {
    print("⚠️ Exception occurred: $e");

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
                    'edicine_bool': medicineBool,
                    'Medicine': medicine ?? "",
                    'referal_bool': referalBool,
                    'referal': referal ?? "null",
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
}
