import 'package:flutter/material.dart';
import '../../utils/appColor.dart';

class ResetPasswordForm extends StatelessWidget {
  final VoidCallback onSubmit;

  ResetPasswordForm({required this.onSubmit});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
          onPressed: () {
            if (_passwordController.text == _confirmPasswordController.text &&
                _passwordController.text.isNotEmpty) {
              onSubmit();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Passwords do not match or are empty")),
              );
            }
          },
          child:  Text(
                  'Login',
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
