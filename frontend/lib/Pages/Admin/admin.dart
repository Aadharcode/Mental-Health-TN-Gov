import 'package:flutter/material.dart';
import './Screens/StudentDetailForm.dart';
import './Screens/TeacherDetailForm.dart';
import './Screens/SchoolDetailForm.dart';
import './Screens/PsychiatristDetailForm.dart';
import './Screens/setting.dart'; 

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _isMenuOpen = false; // Track menu state

  void handleSearch() {
    print('Search pressed');
  }

  void toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void closeMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isMenuOpen ? closeMenu : null, // Close menu on outside tap
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Main Content
              Column(
                children: [
                  // Header with menu and settings icons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: toggleMenu, // Toggle menu on press
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          onPressed: () {
                            // Navigate to the Setting screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SettingsScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Content Section
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            // Logo Section
                            Image.asset(
                              "assets/Logo/logo_TNMS.png", // Replace with your asset path
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 40),

                            // Input Fields and Search Button
                            Column(
                              children: [
                                // Name Input
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Name',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 12.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // School/Company Input
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'School/Company',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 12.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Search Button
                                ElevatedButton(
                                  onPressed: handleSearch,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange.shade400,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                      vertical: 12.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Hamburger Menu Overlay
              if (_isMenuOpen)
                Positioned(
                  top: 0,
                  left: 0,
                  child: GestureDetector(
                    onTap: closeMenu, // Close menu when clicking outside
                    child: Container(
                      color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 250,
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.deepOrange.shade300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => UploadStudentForm()),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    'Upload Student details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => UploadTeacherForm()),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    'Upload Teacher details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => UploadSchoolForm()),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    'Upload School details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => UploadPsychiatristForm()),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    'Upload Psychiatrist details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
