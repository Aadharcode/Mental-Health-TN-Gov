import 'package:flutter/material.dart';
import './Screens/home.dart';
import './Screens/setting.dart';
import './Screens/attendance.dart';  // Import the Attendance screen
import './Screens/redflag.dart';    // Import the Redflag screen
import './component/bottom-nav.dart';

class TeacherScreen extends StatefulWidget {
  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SettingsScreen(),
  ];

  void onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void navigateToAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AttendanceScreen()),
    );
  }

  void navigateToRedflag() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RedflagScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? _screens[_currentIndex]
          : _screens[_currentIndex],  // Keep logic for Home and Settings screen
      bottomNavigationBar: PsychiatristBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
