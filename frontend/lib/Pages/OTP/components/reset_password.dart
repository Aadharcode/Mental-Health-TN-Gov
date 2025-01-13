import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/appColor.dart';

class ResetPasswordForm extends StatelessWidget {
  final String role;
  final String uniqueField;
  final VoidCallback onSubmit;

  ResetPasswordForm({
    required this.role,
    required this.uniqueField,
    required this.onSubmit,
  });

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<bool> updatePassword(String password) async {
    const String apiUrl = "http://10.42.187.145:3000/api/updatePassword"; // Replace with your actual API URL
    print(jsonEncode({
          'role': role,
          'uniqueField': uniqueField,
          'password': password,
        }),);
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'role': role,
          'uniqueField': uniqueField,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Password updated successfully: ${responseData['msg']}");
        return true; // Password updated successfully
      } else {
        final responseData = jsonDecode(response.body);
        print("Error: ${responseData['msg']}");
        return false; // Error in updating password
      }
    } catch (e) {
      print("Exception while updating password: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'New Password',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Confirm New Password',
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
          onPressed: () async {
            if (_passwordController.text == _confirmPasswordController.text &&
                _passwordController.text.isNotEmpty) {
              bool isUpdated = await updatePassword(_passwordController.text.trim());
              if (isUpdated) {
                onSubmit();  // Call the callback on success
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to update password")),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Passwords do not match or are empty")),
              );
            }
          },
          child: Text(
            'Update Password',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
