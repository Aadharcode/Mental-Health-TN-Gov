import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'redflag.dart';
import 'victim_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../others/about.dart';
import '../../others/terms.dart';
import '../../Login/Login.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedSchool;
  String studentNameQuery = "";
  String? selectedEmis;
  List<String> schoolList = [];
  List<Map<String, String>> studentsList = [];
  List<Map<String, String>> filteredStudents = [];
  bool isLoading = false;
  bool isFiltering = false;

  @override
  void initState() {
    super.initState();
    fetchSchools();
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

  Future<void> fetchSchools() async {
    setState(() => isLoading = true);
    try {
      final uri = Uri.parse("http://13.232.9.135:3000/api/getSchool");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List) {
          setState(() {
            schoolList = (data['data'] as List)
                .map((item) => item['SCHOOL_NAME'] as String)
                .toList();
          });
        }
      }
    } catch (e) {
      print("Error fetching schools: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchStudents() async {
    if (selectedSchool == null) return;
    setState(() => isLoading = true);
    try {
      final url = Uri.parse("http://13.232.9.135:3000/getStudentsBySchool");
      final body = json.encode({'school_name': selectedSchool});
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['msg'] == "Students fetched successfully.") {
          setState(() {
            studentsList = (data['data'] as List)
                .map((item) => {
                      'emis': item['student_emis_id'].toString(),
                      'name': item['student_name'].toString(),
                    })
                .toList();
            filterStudents();
          });
        }
      }
    } catch (e) {
      print("Error fetching students: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterStudents() {
    setState(() {
      filteredStudents = studentsList
          .where((student) => student['name']!
              .toLowerCase()
              .contains(studentNameQuery.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchStudentDetails(BuildContext context, String emisId) async {
    try {
      final response = await http.post(
        Uri.parse('http://13.232.9.135:3000/getStudent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'student_emis_id': selectedEmis}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RedflagScreen(
              studentName: data['data']['student']['student_name'],
              emisId: data['data']['student']['student_emis_id'],
            ),
          ),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.blue),
                  ),
                ),
                icon: Icon(Icons.flag, color: Colors.blue),
                label: Text("Red Flag Identification", style: TextStyle(color: Colors.blue)),
                onPressed: () {},
              ),
              SizedBox(height: 20),
              _buildDropdownSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSection() {
  return Expanded(
    child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select School Dropdown
            Text(
              "Select School",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              ),
              hint: Text("Choose a school"),
              value: selectedSchool,
              isExpanded: true,
              items: schoolList.map((school) {
                return DropdownMenuItem(
                  value: school,
                  child: Text(
                    school,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSchool = value;
                  studentNameQuery = "";
                  selectedEmis = null;
                  studentsList.clear();
                  filteredStudents.clear();
                });
                fetchStudents();
              },
            ),
            SizedBox(height: 15),

            // Search Student by Name
            Text(
              "Search Student by Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter student’s name",
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
            SizedBox(height: 15),

            // EMIS ID Dropdown
            Text(
              "EMIS ID",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            isFiltering
                ? Center(child: CircularProgressIndicator())
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
                      setState(() => selectedEmis = value);
                    },
                  ),

            SizedBox(height: 20),

            // Search Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: selectedEmis != null
                    ? () => fetchStudentDetails(context, selectedEmis!)
                    : null,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Search", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            SizedBox(height: 15),

            // Report Incident Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => navigateToMarkVictimScreen(context),
                child: Text("Report Incident", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


     void navigateToMarkVictimScreen(BuildContext context) {
    
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarkVictimScreen(
            // studentName: selectedEmis!,
            // emisId: selectedEmis!,
          ),
        ),
      );
   
  }
}
