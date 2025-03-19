import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/otpVerification.dart';
import '../../utils/appStyle.dart';
import '../../utils/appColor.dart';

class ForgotPasswordForm extends StatefulWidget {
  final VoidCallback onBackToLogin;
  // final VoidCallback onOtpSent;

  ForgotPasswordForm({required this.onBackToLogin});

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _udiseController = TextEditingController();
  String _selectedRole = 'Teacher';
  final List<String> _roles = ['Teacher', 'hs-ms', 'Psychiatrist', 'asa', 'cif', 'rc', 'warden'];
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    if (_udiseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter your UDISE / EMIS ID"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    const String apiUrl = "http://13.232.9.135:3000/api/sendOTP";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'role': _selectedRole, 'uniqueField': _udiseController.text.trim()}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("OTP sent successfully: ${responseData['msg']}");
        // widget.onOtpSent();
        String phoneNumber = responseData['number']; // Extract phone number from API response

      // Navigate to OTP Verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationPopup(
            phoneNumber: phoneNumber,
            role: _selectedRole,
          ),
        ),
      );
      } else {
        final responseData = jsonDecode(response.body);
        print("Error: ${responseData['msg']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['msg']), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print("Exception while sending OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send OTP. Please try again."), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Role', style: AppStyles.labelText),
        DropdownButtonFormField<String>(
          value: _selectedRole,
          decoration: AppStyles.inputDecoration(hintText: 'Choose Role'),
          items: _roles.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(role, style: AppStyles.labelText),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedRole = value!),
        ),
        const SizedBox(height: 15),

        TextField(
          controller: _udiseController,
          decoration: AppStyles.inputDecoration(
            hintText: 'Enter UDISE / EMIS ID',
            prefixIcon: Icon(Icons.account_circle, color: AppColors.iconColor),
          ),
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          style: AppStyles.buttonStyle,
          onPressed: _isLoading ? null : _sendOtp,
          child: _isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text('Send OTP', style: AppStyles.buttonText),
        ),
        const SizedBox(height: 15),

        GestureDetector(
          onTap: widget.onBackToLogin,
          child: Text('Back to Login', style: AppStyles.linkText),
        ),
      ],
    );
  }
}
