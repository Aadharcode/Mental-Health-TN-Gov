import 'package:flutter/material.dart';
import './Components/LoginForm.dart';
// import '../../../assets/Logo/logo_TNMS.png';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               SizedBox(
                width: 192,
                height: 192,
                child: Image.asset(
                  "assets/Logo/logo_TNMS.png", // Replace with your asset path
                  fit: BoxFit.contain,
                  // height:20,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
