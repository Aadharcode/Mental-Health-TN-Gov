import 'package:flutter/material.dart';
import '../../utils/appColor.dart';

class OtpVerificationForm extends StatelessWidget {
  final Function(String otp) onNext;
  final VoidCallback onBack;

  OtpVerificationForm({required this.onNext, required this.onBack});

  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _otpController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter OTP',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.whiteColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed:  () {
            if (_otpController.text.isNotEmpty) {
              onNext(_otpController.text.trim());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please enter the OTP")),
              );
            }
          },
          child:Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: onBack,
          child: Text('Back'),
        ),
      ],
    );
  }
}
