import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'redflag.dart';
import '../../../backendUrl.dart'; 

class HomeScreen extends StatelessWidget {
  final TextEditingController emisController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Redflag Identification',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 15),
                _buildRedflagSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String? field1, String? field2, String? field3, String? field4) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildInputField(field1),
          if (field2 != null) _buildInputField(field2),
          if (field3 != null) _buildInputField(field3),
          if (field4 != null) _buildInputField(field4),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE9967A),
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // Add search functionality here
            },
            child: Text(
              'Search',
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildRedflagSection(BuildContext context) {
  final TextEditingController nameController = TextEditingController();

  return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Color(0xFFF0F0F0),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Enter Name',
              hintStyle: TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: emisController,
            decoration: InputDecoration(
              hintText: 'Enter EMIS ID',
              hintStyle: TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            final name = nameController.text.trim();
            final emisId = emisController.text.trim();

            if (emisId.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter a valid EMIS ID')),
              );
              return;
            }

            fetchStudentDetails(context, emisId);
          },
          child: Text(
            'Search',
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}


 Future<void> fetchStudentDetails(BuildContext context, String emisId) async {
  if (emisId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter a valid EMIS ID')),
    );
    return;
  }

  try {
    // Replace with your backend endpoint
    final url = Uri.parse('http://13.232.9.135:3000/getStudent');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'student_emis_id': emisId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final studentName = data['data']['student_name'];
      final emisId = data['data']['student_emis_id'];

      //Navigate to the RedflagScreen with the fetched details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RedflagScreen(
            studentName: studentName,
            emisId: emisId,
          ),
        ),
      );
    } else {
      final message = jsonDecode(response.body)['msg'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Failed to fetch student details')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
}


  Widget _buildInputField(String? placeholder) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}
