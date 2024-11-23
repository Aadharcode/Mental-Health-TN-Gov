import 'package:flutter/material.dart';
import '../../utils/navigation.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person_outline,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'y*****@gmail.com',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  NavigationUtils.showComingSoonDialog(context);
                },
                child: Text('Terms and Conditions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[100],
                  foregroundColor: Colors.deepPurple,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  NavigationUtils.showComingSoonDialog(context);
                },
                child: Text('About'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[100],
                  foregroundColor: Colors.deepPurple,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Navigates to the login page
                },
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
