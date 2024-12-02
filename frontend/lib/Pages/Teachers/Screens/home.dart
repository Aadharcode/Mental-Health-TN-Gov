import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
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
                'Attendance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),
              _buildSection(
                'School name',
                'District',
                'Grade',
                'Group Code',
              ),
              SizedBox(height: 20),
              Text(
                'Redflag Identification',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),
              _buildSection(
                'Name',
                'EMIS',
                null,
                null,
              ),
              Spacer(),
              _buildNavBar(),
            ],
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
              primary: Color(0xFFE9967A),
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

  Widget _buildInputField(String? placeholder) {
    return TextField(
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
    );
  }

  Widget _buildNavBar() {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Color(0xFF8B3DFF)),
              onPressed: () {
                // Handle Home navigation
              },
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Color(0xFF666666)),
              onPressed: () {
                // Handle Settings navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}
