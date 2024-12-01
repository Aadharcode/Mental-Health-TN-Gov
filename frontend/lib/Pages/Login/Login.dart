import 'package:flutter/material.dart';
import './Components/LoginForm.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                  ),
                ),
                const SizedBox(height: 17.0),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
