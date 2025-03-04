import 'package:flutter/material.dart';
import 'Screens/dashboardScreen.dart';
import 'Screens/setting.dart';  
import './component/bottom-nav.dart';
import '../Teachers/Screens/victim_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
