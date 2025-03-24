import 'package:flutter/material.dart';
import './Screens/setting.dart';
import './Screens/DashboardScreen.dart';
import './Screens/PsychiatristAttendanceScreen.dart';
import './Screens/DetailScreen.dart';
import './Component/bottom-nav.dart';
import './Component/module_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../others/about.dart';
import '../others/terms.dart';
import '../Login/Login.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;
  final List<String> menuItems = [
    'Teacher', 'HM', 'Psychiatrist', 'Students', 'ASA', 'CIF', 'RC', 'Warden'
  ];

  List<Widget> _getScreens() {
    return [DashboardScreen(), SettingsScreen()];
  }

  void openModules() {
    ModuleModal.show(context, menuItems, (selectedRole) {
      String collectionName = getCollectionName(selectedRole);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(
            title: '$selectedRole Details',
            collectionName: collectionName,
          ),
        ),
      );
    });
  }

  String getCollectionName(String role) {
    switch (role) {
      case 'Admin': return 'admins';
      case 'Teacher': return 'teachers';
      case 'Psychiatrist': return 'psychiatrists';
      case 'Students': return 'students';
      case 'HM': return 'schools';
      case 'MS': return 'ms';
      case 'ASA': return 'asa';
      case 'CIF': return 'cif';
      case 'RC': return 'rc';
      case 'Warden': return 'warden';
      default: return 'unknown';
    }
  }

  void onTabSelected(int index) {
  if (index == 2) { 
    index =1;
  } 
    setState(() {
      _currentIndex = index;
    });
  
}

Future<void> _logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Erase stored login data

    // Navigate to Login Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screens = _getScreens();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE3F2FD),
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/Logo/logo_TNMS.png', height: 30),
            const SizedBox(width: 10),
            Text(
              'TNMSS',
              style: TextStyle(color: Color(0xFF014544), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'About') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              } else if (value == 'Terms') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsScreen()),
                );
              } else if (value == 'Attendance') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PsychiatristAttendanceScreen()),
                );
              } else if (value == 'Logout') {
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'About', child: Text('About')),
              PopupMenuItem(value: 'Terms', child: Text('Terms and Conditions')),
              PopupMenuItem(value: 'Attendance', child: Text('Psychiatrist Attendance')),
              PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            
            Expanded(child: screens[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: PsychiatristBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: onTabSelected,
        onModulesTapped: openModules, // Open modal on "Modules" tap
      ),
    );
  }
}
