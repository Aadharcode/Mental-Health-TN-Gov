// mark_victim_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class MarkVictimScreen extends StatefulWidget {
  // final String studentName;
  // final String emisId;

  MarkVictimScreen();

  @override
  _MarkVictimScreenState createState() => _MarkVictimScreenState();
}



class _MarkVictimScreenState extends State<MarkVictimScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _studentName;
  String? _emisId;
  String? _incidentDate;
  String? _incidentTime;
  String? _incidentLocation;
  String? _abuseType;
  String? _otherAbuseType;
  String? _severityLevel;
  String? _victimAge;
  String? _victimSex;
  // String? _victimPhone;
  String? _incidentDetails;
  bool _keepAnonymous = false;
  String? selectedDistrict;
  String studentNameQuery = "";
  String? selectedEmis;
  List<String> districtList = [];
  List<Map<String, String>> studentsList = [];
  List<Map<String, String>> filteredStudents = [];
  bool isLoading = false;
  bool isFiltering = false;

  @override
  void initState() {
    super.initState();
    fetchDistricts();
  }
  void alertPolice() async {
  const String policeNumber = "+919626916789";
  final Uri phoneUri = Uri.parse('tel:$policeNumber');
  
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    print("🚨 Could not launch $phoneUri");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: Unable to make the call")),
    );
  }
}


  Future<void> createVictim() async {
    final url = Uri.parse("http://13.232.9.135:3000/createVictim");
    print("$_studentName, $selectedEmis, $_incidentDate, $_incidentTime,$_victimAge, $_victimSex");

    if (_studentName == null || selectedEmis == null || _incidentDate == null || _incidentTime == null || _victimAge == null || _victimSex == null) {
      print("⚠️ Missing required fields");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    final Map<String, dynamic> requestBody = {
      "name": _studentName,
      "age": _victimAge,
      "sex": _victimSex,
      "emis_id": selectedEmis,
      "Date": _incidentDate,
      "Time": _incidentTime,
      "Location": _incidentLocation ?? "",
      "Details": _incidentDetails ?? "",
      "type": _abuseType != "Others (specify)" ? _abuseType : _otherAbuseType,
      "level": _severityLevel?.toLowerCase() ?? "emergency",
    };

    print("📤 Sending request to: $url");
    print("📨 Request Body: ${jsonEncode(requestBody)}");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);
      print("📬 Response Status Code: ${response.statusCode}");
      print("📥 Response Body: $responseData");

      if (response.statusCode == 200) {
        print("✅ Victim reported successfully.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Victim reported successfully.")),
        );
      } else {
        print("❌ Error: ${responseData['msg']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${responseData['msg']}")),
        );
      }
    } catch (error) {
      print("🔥 Error submitting report: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting report: $error")),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _incidentDate = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _incidentTime = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report Incident")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
          "Select School",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          ),
          hint: Text("Choose a school"),
          value: selectedDistrict,
          isExpanded: true,
          items: districtList.map((district) {
            return DropdownMenuItem(
              value: district,
              child: Text(
                district,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedDistrict = value;
              studentNameQuery = "";
              selectedEmis = null;
              studentsList.clear();
              filteredStudents.clear();
            });
            fetchStudents();
          },
        ),
        const SizedBox(height: 15),

        Text(
          "Search Student by Name",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: _studentName?? "Enter student's name",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          ),
          onChanged: (value) {
            setState(() {
              studentNameQuery = value;
              filterStudents();
            });
          },
        ),
        const SizedBox(height: 15),

        isFiltering
            ? Center(child: CircularProgressIndicator())
            : filteredStudents.isEmpty
                ? Text("No students found.", style: TextStyle(color: Colors.grey))
                : DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    hint: Text("Select EMIS ID"),
                    value: selectedEmis,
                    isExpanded: true,
                    items: filteredStudents.map((student) {
                      return DropdownMenuItem(
                        value: student['emis'],
                        child: Text(
                          '${student['name']} (${student['emis']})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                   onChanged: (value) {
                      setState(() {
                        selectedEmis = value;
                        _studentName = filteredStudents.firstWhere(
                          (student) => student['emis'] == value,
                          orElse: () => {'name': ''}, // Provide a default value to prevent errors
                        )['name'];
                      });
                    },
                  ),

        const SizedBox(height: 20),
        
                SizedBox(height: 10),
                Text("Incident Date"),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(text: _incidentDate),
                  decoration: InputDecoration(
                    hintText: "Select Date",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text("Incident Time"),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(text: _incidentTime),
                  decoration: InputDecoration(
                    hintText: "Select Time",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(context),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text("Incident Location"),
                TextFormField(
                  decoration: InputDecoration(hintText: "Location of incident"),
                  onChanged: (value) => _incidentLocation = value,
                ),
                SizedBox(height: 10),
                Text(
                  "Victim Details",
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),),
                Text("Age"),
                TextFormField(
                  decoration: InputDecoration(hintText: "Enter Victim's Age"),
                  onChanged: (value) => _victimAge = value,
                ),
                SizedBox(height: 10),
                Text("Sex"),
               DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Select Victim's Sex",
                    border: OutlineInputBorder(), // Optional: Adds a border
                  ),
                  items: ["Male", "Female", "Other"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => _victimSex = value,
                ),

                SizedBox(height: 10),
                
                SizedBox(height: 10),
                Text("Incident Details",
                style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),),
                TextFormField(
                  decoration: InputDecoration(hintText: "Describe the Incident"),
                  
                  onChanged: (value) => _incidentDetails = value,
                ),
                SizedBox(height: 10),
                Text("Type of Sexual Abuse"),
                DropdownButtonFormField(
                  items: [
                    "Inappropriate touching",
                    "Sexual advances",
                    "Physical abuse",
                    "Online harassment",
                    "Showing inappropriate content/Body parts",
                    "Others (specify)"
                  ]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                type,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _abuseType = value as String?;
                      if (_abuseType != "Others (specify)") {
                        _otherAbuseType = null;
                      }
                    });
                  },
                  decoration: InputDecoration(hintText: "Type of Sexual Abuse"),
                ),
                if (_abuseType == "Others (specify)") ...[
                  SizedBox(height: 10),
                  Text("Specify Other Type"),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Enter details"),
                    onChanged: (value) => _otherAbuseType = value,
                  ),
                ],
                SizedBox(height: 10),
                Text("Severity Level"),
                DropdownButtonFormField(
                  items: ["Emergency", "NON-Emergency"]
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  onChanged: (value) => _severityLevel = value,
                  decoration: InputDecoration(hintText: "Select severity level"),
                ),
                SizedBox(height: 10),
                CheckboxListTile(
                  title: Text("Keep my identity anonymous"),
                  value: _keepAnonymous,
                  onChanged: (value) => setState(() => _keepAnonymous = value!),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                       createVictim();
                    }
                  },
                  child: Text("Submit Report"),
                ),
                SizedBox(height: 10), // Space between buttons
                ElevatedButton.icon(
                  onPressed: alertPolice, // Call the police function
                  icon: Icon(Icons.call, color: Colors.white),
                  label: Text("Alert Police"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red for emergency
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


   Future<void> fetchDistricts() async {
    setState(() => isLoading = true);
    try {
      final uri = Uri.parse("http://13.232.9.135:3000/api/getSchool");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List) {
          setState(() {
            districtList = (data['data'] as List)
                .map((item) => item['SCHOOL_NAME'] as String)
                .toList();
            districtList.insert(0, "All");
          });
        }
      }
    } catch (e) {
      print("Error fetching districts: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

 Future<void> fetchStudents() async {
  if (selectedDistrict == null) {
    print("⚠️ No district selected. Aborting fetch.");
    return;
  }

  setState(() {
    isLoading = true;
    print("⏳ Fetching students for district: $selectedDistrict...");
  });

  try {
    final url = Uri.parse("http://13.232.9.135:3000/getStudentsBySchool");
    final body = json.encode({'school_name': selectedDistrict});

    print("📡 Sending request to: $url");
    print("📨 Request Body: $body");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print("📬 Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("📥 Response Body: $data");

      if (data['msg'] == "Students fetched successfully.") {
        setState(() {
          studentsList = (data['data'] as List)
              .map((item) => {
                    'emis': item['student_emis_id'].toString(),
                    'name': item['student_name'].toString(),
                  })
              .toList();

          print("✅ Successfully fetched ${studentsList.length} students.");
          filterStudents();
        });
      } else {
        print("⚠️ Fetch failed: ${data['message']}");
      }
    } else {
      print("❌ Failed to fetch students. HTTP Status: ${response.statusCode}");
    }
  } catch (e) {
    print("🔥 Error fetching students: $e");
  } finally {
    setState(() {
      isLoading = false;
      print("✅ Fetch process completed.");
    });
  }
}


  void filterStudents() {
    setState(() => isFiltering = true);
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        filteredStudents = studentsList
            .where((student) => student['name']!
                .toLowerCase()
                .contains(studentNameQuery.toLowerCase()))
            .toList();
        isFiltering = false;
      });
    });
  }

  
}
