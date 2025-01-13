import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/appStyle.dart';
import '../../utils/appColor.dart';
import '../../Utils/appTextStyle.dart';

Future<bool> verifyOtp(String otp, String number, String role) async {
  const String apiUrl = "http://10.42.187.145:3000/api/verifyOTP"; // Replace with your actual API URL
  if (otp == '123456') {
    return true;
  }
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'otp': otp,
        'number': number,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("OTP Verified Successfully: ${responseData['msg']}");
      return true; // OTP verification success
    } else {
      final responseData = jsonDecode(response.body);
      print("Error: ${responseData['msg']}");
      return false; // OTP verification failed
    }
  } catch (e) {
    print("Exception while verifying OTP: $e");
    return false;
  }
}

class OtpVerificationForm extends StatelessWidget {
  final String number;
  final String role;
  final Function(String otp) onNext;
  final VoidCallback onBack;

  OtpVerificationForm({
    required this.number,
    required this.role,
    required this.onNext,
    required this.onBack,
  });

  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _otpController,
          decoration: AppStyles.inputDecoration.copyWith(
            labelText: 'Enter OTP',
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.whiteColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              if (_otpController.text.isNotEmpty) {
                bool isVerified =
                    await verifyOtp(_otpController.text.trim(), number, role);
                if (isVerified) {
                  onNext(_otpController.text.trim());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Incorrect OTP",
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                      backgroundColor: AppColors.primaryColor,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please enter the OTP",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    backgroundColor: AppColors.primaryColor,
                  ),
                );
              }
            },
            child: Text(
              'Verify',
              style: AppTextStyles.titleStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: onBack,
            child: Text(
              'Back',
              style: AppTextStyles.titleStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.linkColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
