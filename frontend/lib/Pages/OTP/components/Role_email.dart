import 'package:flutter/material.dart';
import '../../utils/appStyle.dart';
import '../../utils/appColor.dart';
import '../../Utils/appTextStyle.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendOtp(String role, String uniqueField) async {
  const String apiUrl = "http://10.42.187.145:3000/api/sendOTP"; // Replace with your actual API URL
  print(jsonEncode({'role': role, 'uniqueField': uniqueField}));

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'role': role, 'uniqueField': uniqueField}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("OTP sent successfully: ${responseData['msg']}");
      // You can store sessionId or proceed as required
    } else {
      final responseData = jsonDecode(response.body);
      print("Error: ${responseData['msg']}");
    }
  } catch (e) {
    print("Exception while sending OTP: $e");
  }
}

class RoleAndUdiseForm extends StatelessWidget {
  final Function(String emailOrUdise, String role, String number) onNext;

  RoleAndUdiseForm({required this.onNext});

  final TextEditingController _emailController = TextEditingController();
  final List<String> _roles = ['Teacher', 'HM', 'Psychiatrist'];
  String _selectedRole = 'Teacher';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedRole,
          decoration: AppStyles.inputDecoration.copyWith(
            labelText: 'Role',
          ),
          items: _roles.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(
                role,
                style: AppTextStyles.titleStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            _selectedRole = value!;
          },
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _emailController,
          decoration: AppStyles.inputDecoration.copyWith(
            labelText: 'UDISE/ District',
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
              if (_emailController.text.isNotEmpty) {
                String number = ""; // Add logic to extract number from the API response.
                // await sendOtp(_selectedRole, _emailController.text.trim());
                onNext(_emailController.text.trim(), _selectedRole, number);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please enter your District or UDISE ID",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    backgroundColor: AppColors.primaryColor,
                  ),
                );
              }
            },
            child: Text(
              'Next',
              style: AppTextStyles.titleStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
