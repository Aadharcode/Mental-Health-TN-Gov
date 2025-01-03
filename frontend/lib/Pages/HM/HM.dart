import 'package:flutter/material.dart';
import 'Screens/home.dart';
import 'Screens/setting.dart';  
import './component/bottom-nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HMScreen extends StatefulWidget {

  @override
  _HSMSState createState() => _HSMSState();
}

class _HSMSState extends State<HMScreen> {
  int _currentIndex = 0;
  String? schoolName; // Declare as class-level variables
  String? district;

  Future<void> _getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final role = prefs.getString('role');
  schoolName = prefs.getString('School_name');
  district = prefs.getString('district');

  print('Token: $token');
  print('Role: $role');
  print('School Name: $schoolName');
  print('District: $district');

  setState(() {});
}

@override
  void initState() {
    super.initState();
    _getUserData(); // Fetch user data when the screen is initialized
  }

  // Initialize the screens list in the build method
  List<Widget> _getScreens() {
    return [
      HomeScreen(SCHOOL_NAME: schoolName, District: district),
      SettingsScreen(),
    ];
  }

  void onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screens dynamically, so widget.SCHOOL_NAME is accessible
    final screens = _getScreens();

    return Scaffold(
      body: screens[_currentIndex],  
      bottomNavigationBar: PsychiatristBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
