import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Redflag.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lists to hold schools and districts
  List<Map<String, String>> schools = [];
  List<String> districts = [];

  // Selected school and district
  String? selectedSchool;
  String? selectedDistrict;

  // Fetch schools and districts from the API
 Future<void> fetchSchoolsAndDistricts() async {
  try {
    final url = Uri.parse('http://192.168.10.250:3000/api/getSchool');
    print('🌐 Sending GET request to $url');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('📥 Response received with status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      print('✅ Data successfully fetched: ${data.length} items');

      // Parse schools and districts
      setState(() {
        schools = (data as List).map<Map<String, String>>((item) {
          return {
            'school_name': item['SCHOOL_NAME'].toString(),
            'district': item['DISTRICT'].toString(),
          };
        }).toList();

        districts = schools.map((school) => school['district']!).toSet().toList();
        print('🏫 Schools list: ${schools.map((s) => s['school_name']).toList()}');
        print('🌍 Districts list: $districts');
      });
    } else {
      print('❌ Failed to fetch schools and districts. Status code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch schools and districts')),
      );
    }
  } catch (e) {
    print('🚨 Error occurred during fetch: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
}



  @override
  void initState() {
    super.initState();
    fetchSchoolsAndDistricts();
  }

  // Function to search for students based on selected school and district
  Future<void> searchStudents() async {
    if (selectedSchool == null || selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both school and district')),
      );
      return;
    }

    try {
      final url = Uri.parse('http://13.232.9.135:3000/api/hsmsFetch');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'school_name': selectedSchool,
          'district': selectedDistrict,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> students = data['data'];

        // Navigate to RedflagScreen with students
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RedflagScreen(students: students),
          ),
        );
      } else {
        final message = jsonDecode(response.body)['msg'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Failed to fetch students')),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Redflag list',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // School Dropdown
                    DropdownButtonFormField<String>(
                        value: selectedSchool,
                        onChanged: (value) {
                          setState(() {
                            selectedSchool = value;
                            selectedDistrict = schools.firstWhere(
                                (school) => school['school_name'] == value)['district'];
                          });
                        },
                        items: schools
                            .map<DropdownMenuItem<String>>((school) => DropdownMenuItem<String>(
                                  value: school['school_name'],
                                  child: Text(
                                    school['school_name']!,
                                    overflow: TextOverflow.ellipsis, // Prevents overflow
                                  ),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          hintText: 'Select School',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        isExpanded: true, // Ensures dropdown matches container width
                      ),
                    SizedBox(height: 12),
                    // District Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedDistrict,
                      onChanged: (value) {
                        setState(() {
                          selectedDistrict = value;
                        });
                      },
                      items: districts
                          .map<DropdownMenuItem<String>>(
                              (district) => DropdownMenuItem<String>(
                                    value: district,
                                    child: Text(district),
                                  ))
                          .toList(),
                      decoration: InputDecoration(
                        hintText: 'Select District',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: searchStudents,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Search'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
