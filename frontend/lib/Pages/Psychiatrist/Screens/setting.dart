import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../others/about.dart';
import '../../others/terms.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? userEmail;
  String? userRole;
  String? district;
  String? contact;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      final user = Map<String, dynamic>.from(jsonDecode(userJson));

      setState(() {
        userEmail = user['DISTRICT_PSYCHIATRIST_NAME'] ?? "Not Available";
        userRole = user['Role'] ?? "Unknown Role";
        district = user['district'] ?? "No District";
        contact = user['Mobile_number'] ?? "No School";
      });
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 🔹 Clears all stored preferences

    Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        elevation: 5, // Adds shadow to AppBar
        automaticallyImplyLeading: false, 
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, size: 50, color: Colors.blue[800]),
            ),
            const SizedBox(height: 10),

            // User Name & Role
            Text(userEmail ?? "Loading...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(userRole ?? "Loading...", style: TextStyle(color: Colors.grey[700])),

            const SizedBox(height: 20),

            // Basic Details Section
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Basic Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 10),
                  _infoField("District", district),
                  const SizedBox(height: 10),
                  _infoField("Contact Details", contact),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Navigation Buttons
            _settingsButton(Icons.info_outline, "About", () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );}),
            _settingsButton(Icons.description_outlined, "Terms & Conditions", () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsScreen()),
                );}),
            _settingsButton(Icons.logout, "Logout", () => _handleLogout(context), isLogout: true),

            const SizedBox(height: 20),
            Text("TNMSS Version 1.0", style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  // Helper method for info fields
  Widget _infoField(String title, String? value) {
  return SizedBox(
    width: double.infinity, // Full width
    // height:70, // Fixed height
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white, // Background color
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, // Center align text
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 5),
          Text(
            value ?? "Not Available",
            style: TextStyle(fontSize: 16, color: Colors.black),
            // overflow: TextOverflow.ellipsis, // Prevents text overflow issues
            softWrap: true,
          ),
        ],
      ),
    ),
  );
}



  // Helper method for navigation buttons
  Widget _settingsButton(IconData icon, String text, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.blue),
      title: Text(text, style: TextStyle(fontSize: 16, color: isLogout ? Colors.red : Colors.black)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isLogout ? Colors.red : Colors.black),
      onTap: onTap,
    );
  }
}
