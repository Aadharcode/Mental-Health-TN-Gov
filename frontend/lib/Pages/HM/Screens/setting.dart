import 'package:flutter/material.dart';
import '../../utils/navigation.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person_outline,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'y*****@gmail.com',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  NavigationUtils.showComingSoonDialog(context);
                },
                child: const Text('Terms and Conditions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[100],
                  foregroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  NavigationUtils.showComingSoonDialog(context);
                },
                child: const Text('About'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[100],
                  foregroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Navigates to the login page
                },
                child: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
