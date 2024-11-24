import 'package:flutter/material.dart';
import './Components/TextFields.dart';
import '../utils/appColor.dart';
import '../utils/navigation.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView( // Added to enable scrolling if necessary
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 20),
              TextFieldComponent(hintText: 'Name'),
              SizedBox(height: 10),
              TextFieldComponent(hintText: 'School/Company'),
              SizedBox(height: 10),
              TextFieldComponent(hintText: 'Mail Id'),
              SizedBox(height: 10),
              TextFieldComponent(hintText: 'Password', obscureText: true),
              SizedBox(height: 10),
              TextFieldComponent(hintText: 'Confirm Password', obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  NavigationUtils.showComingSoonDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text('Register'),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Center(
                  child: Text(
                    'Back to Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
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
