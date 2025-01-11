import 'package:flutter/material.dart';
import './components/Role_email.dart';
import './components/reset_password.dart';
import './components/otp.dart';

class ForgetPasswordForm extends StatefulWidget {
  final VoidCallback onBackToLoginTap;

  ForgetPasswordForm({required this.onBackToLoginTap});

  @override
  _ForgetPasswordFormState createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  int _currentStep = 0; // 0: Role & Email, 1: OTP Verification, 2: Reset Password
  String _emailOrUdise = "";
  String _otp = "";

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _prevStep() {
    setState(() {
      _currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_currentStep == 0) RoleAndUdiseForm(onNext: (emailOrUdise) {
          _emailOrUdise = emailOrUdise;
          _nextStep();
        }),
        if (_currentStep == 1) OtpVerificationForm(onNext: (otp) {
          _otp = otp;
          _nextStep();
        }, onBack: _prevStep),
        if (_currentStep == 2) ResetPasswordForm(onSubmit: () {
          // Handle reset password submission
          print("Email: $_emailOrUdise, OTP: $_otp, Password Reset Done");
          widget.onBackToLoginTap();
        }),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: widget.onBackToLoginTap,
            child: Text(
              'Back to Login',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
