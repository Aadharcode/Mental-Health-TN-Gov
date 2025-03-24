import 'package:flutter/material.dart';
import '../utils/appStyle.dart';
import '../utils/appColor.dart';
import 'Components/LoginForm.dart';
import 'Components/forgotPasswordForm.dart';
// import './widgets/otpVerification.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _currentIndex = 0; // 0: Login Form, 1: Forgot Password Form

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

  // void _showOtpVerification() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) => OtpVerificationPopup(),
  //   );
  // }

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
                  width: 120,
                  height: 120,
                  child: Image.asset("assets/Logo/logo_TNMS.png"),
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Icon(Icons.lock, color: AppColors.primaryColor, size: 24),
                    const SizedBox(width: 5),
                    Text(
                      _currentIndex == 0 ? 'Login' : 'Forgot Password',
                      style: AppStyles.headerText,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_currentIndex == 0)
                  LoginForm(onForgetPasswordTap: _switchToForgetPasswordForm),
                if (_currentIndex == 1)
                  ForgotPasswordForm(
                    onBackToLogin: _switchToLoginForm,
                    // onOtpSent: _showOtpVerification,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
