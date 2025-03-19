import 'package:flutter/material.dart';
import 'Screens/dashboardScreen.dart';
import 'Screens/setting.dart';  
import './component/bottom-nav.dart';
import '../Teachers/Screens/victim_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../others/about.dart';
import '../others/terms.dart';
import '../Login/Login.dart';

class RCScreen extends StatefulWidget {
  @override
  _MSState createState() => _MSState();
}

class _MSState extends State<RCScreen> {
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

  void navigateToMarkVictimScreen(BuildContext context) {
    
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarkVictimScreen(
            // studentName: selectedEmis!,
            // emisId: selectedEmis!,
          ),
        ),
      );
   
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
              } else if (value == 'Logout') {
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'About', child: Text('About')),
              PopupMenuItem(value: 'Terms', child: Text('Terms and Conditions')),
              // PopupMenuItem(value: 'Attendance', child: Text('Psychiatrist Attendance')),
              PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 80), // Margin from top
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: _screens[_currentIndex], 
            ),
          ),
          SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => navigateToMarkVictimScreen(context),
                  child: Text("Mark as Victim", style: TextStyle(fontSize: 16)),
                ),
              ),
        ],
      ),
      bottomNavigationBar: PsychiatristBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
