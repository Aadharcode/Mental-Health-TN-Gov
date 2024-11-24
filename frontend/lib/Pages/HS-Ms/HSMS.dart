import 'package:flutter/material.dart';
import './Screens/home.dart';
import './Screens/setting.dart';
import './Screens/redflag.dart';   
import './component/bottom-nav.dart';

class HSMSScreen extends StatefulWidget {
  @override
  _HSMSState createState() => _HSMSState();
}

class _HSMSState extends State<HSMSScreen> {
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

  void navigateToRedflag() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ApprovalScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? _screens[_currentIndex]
          : _screens[_currentIndex],  
      bottomNavigationBar: PsychiatristBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
