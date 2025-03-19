import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/appStyle.dart';
// import '../../utils/appColor.dart';

class OtpVerificationPopup extends StatefulWidget {
  final String phoneNumber;
  final String role;

  OtpVerificationPopup({required this.phoneNumber, required this.role});

  @override
  _OtpVerificationPopupState createState() => _OtpVerificationPopupState();
}

class _OtpVerificationPopupState extends State<OtpVerificationPopup> {
  List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;

  /// Function to verify OTP
  Future<void> _verifyOtp() async {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a 6-digit OTP"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    bool isVerified = await verifyOtp(otp, widget.phoneNumber, widget.role);

    setState(() => _isLoading = false);

    if (isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP Verified Successfully"), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Close the modal on success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP. Please try again."), backgroundColor: Colors.red),
      );
    }
  }

  /// Function to resend OTP (Placeholder)
  void _resendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Resending OTP..."), backgroundColor: Colors.blue),
    );
    // Call API to resend OTP
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('OTP Verification', style: AppStyles.headerText),
            const SizedBox(height: 10),
            Text(
              'We have sent a 6-digit verification code',
              style: AppStyles.labelText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: AppStyles.inputDecoration(),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus(); // Move to next field
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Verify Button
            ElevatedButton(
              style: AppStyles.buttonStyle,
              onPressed: _isLoading ? null : _verifyOtp,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Verify', style: AppStyles.buttonText),
            ),
            const SizedBox(height: 10),

            // Resend OTP
            GestureDetector(
              onTap: _resendOtp,
              child: Text('Didn’t receive it? Resend OTP', style: AppStyles.linkText),
            ),
          ],
        ),
      ),
    );
  }
}

/// Function to verify OTP
Future<bool> verifyOtp(String otp, String number, String role) async {
  const String apiUrl = "http://13.232.9.135:3000/api/verifyOTP";
  
  if (otp == '123456') {
    return true; // For testing, always verify '123456'
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
      return true;
    } else {
      final responseData = jsonDecode(response.body);
      print("Error: ${responseData['msg']}");
      return false;
    }
  } catch (e) {
    print("Exception while verifying OTP: $e");
    return false;
  }
}
