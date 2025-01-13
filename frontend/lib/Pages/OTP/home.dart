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
  String _role = "";
  String _number = "";

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
        if (_currentStep == 0)
          RoleAndUdiseForm(onNext: (emailOrUdise, role, number) {
            _emailOrUdise = emailOrUdise;
            _role = role;
            _number = number;
            _nextStep();
          }),
        if (_currentStep == 1)
          OtpVerificationForm(
            number: _number,
            role: _role,
            onNext: (otp) {
              _otp = otp;
              _nextStep();
            },
            onBack: _prevStep,
          ),
        if (_currentStep == 2)
          ResetPasswordForm(
          role: _role,
          uniqueField: _emailOrUdise,
          onSubmit: widget.onBackToLoginTap, // Callback for when the password is updated
        ),
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
