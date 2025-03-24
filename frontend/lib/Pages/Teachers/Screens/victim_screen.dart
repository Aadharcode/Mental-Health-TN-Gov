import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class MarkVictimScreen extends StatefulWidget {
  @override
  _MarkVictimScreenState createState() => _MarkVictimScreenState();
}

class _MarkVictimScreenState extends State<MarkVictimScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _studentName;
  String? _incidentDate;
  String? _incidentTime;
  String? _incidentLocation;
  String? _abuseType;
  String? _otherAbuseType;
  String? _severityLevel;
  String? _victimAge;
  String? _victimSex;
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


void alertPolice() async {
  const String policeNumber = "+919626916789";
  final Uri phoneUri = Uri.parse('tel:$policeNumber');

  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint("Could not launch the dialer");
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({String? label, String? hintText, IconData? icon, bool readOnly = false, VoidCallback? onTap}) {
    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        suffixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Incident", style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Basic Information", Icons.info),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Select School",
                ),
                value: selectedDistrict,
                items: districtList.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7, // Constrain width
                      child: Text(
                        district,
                        softWrap: true, // Prevent text from overflowing
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() { selectedDistrict = value; fetchStudents();} ),
              ),
              SizedBox(height: 10),
              _buildStudentSearchField(),

              SizedBox(height: 20),
              _buildSectionHeader("Victim Details", Icons.person),
              SizedBox(height: 10),
              _buildTextField(label: "Age", hintText: "Enter Victim's Age"),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Sex"),
                items: ["Male", "Female", "Other"].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                onChanged: (value) => setState(() => _victimSex = value),
              ),

              SizedBox(height: 20),
              _buildSectionHeader("Incident Details", Icons.report),
              SizedBox(height: 10),
              _buildTextField(label: "Incident Date", hintText: "Select Date", icon: Icons.calendar_today, readOnly: true, onTap: () => _selectDate(context)),
              SizedBox(height: 10),
              _buildTextField(label: "Incident Time", hintText: "Select Time", icon: Icons.access_time, readOnly: true, onTap: () => _selectTime(context)),
              SizedBox(height: 10),
              _buildTextField(label: "Incident Location", hintText: "Location of incident"),
              SizedBox(height: 10),
              _buildTextField(label: "Describe the Incident", hintText: "Enter Description"),
              
              SizedBox(height: 10),
              CheckboxListTile(
                title: Text("Keep my identity anonymous"),
                value: _keepAnonymous,
                onChanged: (value) => setState(() => _keepAnonymous = value!),
              ),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => print("Submit Report"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Submit", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: alertPolice,
                icon: Icon(Icons.call, color: Colors.white),
                label: Text("Alert Police"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
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
        print(data);
        if (data['data'] is List) {
          setState(() {
            districtList = (data['data'] as List)
                .map((item) => item['SCHOOL_NAME'] as String)
                .toList();
            districtList.insert(0, "All");
          });
        }
      }
      // fetchStudents();
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

  

  TextEditingController _studentController = TextEditingController();

Widget _buildStudentSearchField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: _studentController, // Keeps text editable
        onChanged: (value) {
          setState(() {
            studentNameQuery = value;
            filterStudents();
          });
        },
        decoration: InputDecoration(
          labelText: "Search Student by Name",
          hintText: "Enter student's name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      if (filteredStudents.isNotEmpty) // Show dropdown only if students are available
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: filteredStudents.length,
            itemBuilder: (context, index) {
              final student = filteredStudents[index];
              final displayText = "${student['name']} (${student['emis']})"; // Name + EMIS

              return ListTile(
                title: Text(displayText, softWrap: true, overflow: TextOverflow.ellipsis),
                onTap: () {
                  setState(() {
                    _studentController.text = student['name']!; // Fill text field
                    selectedEmis = student['emis']; // Store selected EMIS
                    _studentController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _studentController.text.length),
                    ); // Keep cursor at the end
                    filteredStudents.clear(); // Hide dropdown after selection
                  });
                },
              );
            },
          ),
        ),
    ],
  );
}

}



