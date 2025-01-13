import 'package:flutter/material.dart';
import 'Screens/dashboardScreen.dart';
import 'Screens/setting.dart';  
import './component/bottom-nav.dart';

class MSScreen extends StatefulWidget {
  @override
  _MSState createState() => _MSState();
}

class _MSState extends State<MSScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    SettingsScreen(),
  ];

  void onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
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
