import 'package:flutter/material.dart';
import './Screens/home.dart';
import './Screens/setting.dart';  // Import the Settings screen
import './component/bottom-nav.dart';

class TeacherScreen extends StatefulWidget {
  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // Directly use HomeScreen without passing the callback
    SettingsScreen(),
  ];

  // Function to change selected tab
  void onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Show the current screen based on tab selection
      bottomNavigationBar: PsychiatristBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
