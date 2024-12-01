import 'package:flutter/material.dart';
import './Screens/home.dart';
import './Screens/setting.dart';
import './Components/bottom-nav.dart';

class PsychiatristScreen extends StatefulWidget {
  @override
  _PsychiatristScreenState createState() => _PsychiatristScreenState();
}

class _PsychiatristScreenState extends State<PsychiatristScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: PsychiatristBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
