import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'redflag.dart';
import '../../../backendUrl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    if (selectedDistrict == null) return;
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("http://13.232.9.135:3000//getAllStudent"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'collectionName': 'students'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            studentsList = (data['data'] as List)
                .where((item) => selectedDistrict == "All" ||
                    item['school_name'].trim().toLowerCase() ==
                        selectedDistrict!.trim().toLowerCase())
                .map((item) => {
                      'emis': item['student_emis_id'].toString(),
                      'name': item['student_name'].toString()
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

  Future<void> fetchStudentDetails(BuildContext context, String emisId) async {
    try {
      final response = await http.post(
        Uri.parse('http://13.232.9.135:3000/getStudent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'student_emis_id': emisId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RedflagScreen(
              studentName: data['data']['student_name'],
              emisId: data['data']['student_emis_id'],
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Redflag Identification',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),
              _buildDropdownSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSection() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(border: OutlineInputBorder()),
          hint: Text("Select School"),
          value: selectedDistrict,
          items: districtList.map((district) {
            return DropdownMenuItem(
              value: district,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  district,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
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
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: "Enter Student Name",
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (value) {
            setState(() {
              studentNameQuery = value;
              filterStudents();
            });
          },
        ),
        SizedBox(height: 10),
        isFiltering
            ? SizedBox(height: 50, child: Center(child: CircularProgressIndicator()))
            : filteredStudents.isEmpty
                ? Text("No student in database")
                : DropdownButtonFormField<String>(
  decoration: InputDecoration(border: OutlineInputBorder()),
  hint: Text("Select EMIS ID"),
  value: selectedEmis,
  isExpanded: true,  // Prevents horizontal overflow
  items: filteredStudents.map((student) {
    return DropdownMenuItem(
      value: student['emis'],
      child: Text(
        '${student['name']} (${student['emis']})',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(fontSize: 14),
      ),
    );
  }).toList(),
  onChanged: (value) {
    setState(() => selectedEmis = value);
  },
),

        SizedBox(height: 10),
        ElevatedButton(
          onPressed: selectedEmis != null
              ? () => fetchStudentDetails(context, selectedEmis!)
              : null,
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text('Search'),
        ),
      ],
    );
  }
}
