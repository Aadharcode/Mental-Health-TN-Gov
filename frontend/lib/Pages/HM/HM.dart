import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/home.dart';
import 'Screens/setting.dart';
import 'component/bottom-nav.dart';


// Redirect to login on logout

class HMScreen extends StatefulWidget {
  @override
  _HSMSState createState() => _HSMSState();
}

class _HSMSState extends State<HMScreen> {
  int _currentIndex = 0;
  String? schoolName;
  String? district;

  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    schoolName = prefs.getString('School_name');
    district = prefs.getString('district');

    setState(() {});
  }

  

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

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
