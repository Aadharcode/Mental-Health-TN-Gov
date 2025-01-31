import 'package:flutter/material.dart';
import './Screens/setting.dart';
import './Screens/DashboardScreen.dart';
import './Screens/PsychiatristAttendanceScreen.dart';
import './Components/Hamburger.dart'; // Import the HamburgerMenu
import './Screens/DetailScreen.dart'; // Import the DetailScreen

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final List<String> menuItems = [
    'Admin',
    'Teacher',
    'HM',
    'MS',
    'Psychiatrist',
    'Students',
    'ASA',
    'CIF',
    'RC',
    'Warden'
  ];

  void toggleMenu() {
    HamburgerMenu.show(context, menuItems, (index) {
      String selectedRole = menuItems[index];
      print("Selected Role: $selectedRole");

      // Map the selected role to a collection name
      String collectionName = getCollectionName(selectedRole);

      // Navigate to the DetailScreen with the appropriate collection name
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

  // Function to map selected role to collection name
  String getCollectionName(String role) {
    switch (role) {
      case 'Admin':
        return 'admins';
      case 'Teacher':
        return 'teachers';
      case 'Psychiatrist':
        return 'psychiatrists';
      case 'Students':
        return 'students';
      case 'HM':
        return 'schools';
      case 'MS':
        return 'ms';
      case 'ASA':
        return 'asa';
      case 'CIF':
        return 'cif';
      case 'RC':
        return 'rc';
      case 'Warden':
        return 'warden';
      default:
        return 'unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: toggleMenu, // Open hamburger menu
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PsychiatristAttendanceScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'See Psychiatrist Attendance',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
