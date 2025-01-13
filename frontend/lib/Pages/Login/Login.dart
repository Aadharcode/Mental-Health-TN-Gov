import 'package:flutter/material.dart';
import './Components/LoginForm.dart';
import '../OTP/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _currentIndex = 0; // 0: Login Form, 1: Forget Password Form

  void _switchToForgetPasswordForm() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _switchToLoginForm() {
    setState(() {
      _currentIndex = 0;
    });
  }

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
                  _currentIndex == 0 ? 'Login' : 'Forget Password',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (_currentIndex == 0) 
                  LoginForm(onForgetPasswordTap: _switchToForgetPasswordForm),
                if (_currentIndex == 1) 
                  ForgetPasswordForm(onBackToLoginTap: _switchToLoginForm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
