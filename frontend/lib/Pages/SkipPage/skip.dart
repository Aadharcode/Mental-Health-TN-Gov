import 'package:flutter/material.dart';
import '../Utils/appColor.dart'; // Import the AppColors class

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // Use primary theme color
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Centers content vertically
              children: [
                Image.asset(
                  'assets/splashScreenImage.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.4,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                const Text(
                  'This application is intended for school academicians, educators, '
                  'and teachers looking to enhance mental well-being in educational settings.',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.whiteColor, // Use theme's text color
                    height: 1.5,
                    fontFamily: 'System',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40), // Adjust spacing
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.whiteColor.withOpacity(0.8), // Light white shade
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.primaryColor, // Primary color for text
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
