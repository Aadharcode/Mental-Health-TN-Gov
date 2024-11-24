import 'package:flutter/material.dart';
import '../../utils/appStyle.dart';
import '../../utils/appColor.dart';
import '../../utils/navigation.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'Admin'; // Default role
  final List<String> _roles = ['Admin', 'Teachers', 'HS and MS', 'Psychiatrist', 'Students'];

  bool _isLoading = false;

  void _navigateBasedOnRole() {
    final role = _selectedRole;

    // Navigate to the appropriate page based on the role
    switch (role) {
      case 'Admin':
        Navigator.pushNamed(context, '/admin');
        break;
      case 'Teachers':
        Navigator.pushNamed(context, '/teachers');
        break;
      case 'HS and MS':
        Navigator.pushNamed(context, '/hs-ms');
        break;
      case 'Psychiatrist':
        Navigator.pushNamed(context, '/psychiatrist');
        break;
      case 'Students':
        Navigator.pushNamed(context, '/students');
        break;
      default:
        NavigationUtils.showComingSoonDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _emailController,
          decoration: AppStyles.inputDecoration.copyWith(hintText: 'Email'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: AppStyles.inputDecoration.copyWith(hintText: 'Password'),
        ),
        const SizedBox(height: 20),
        Text(
          'Select Role:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedRole,
          decoration: AppStyles.inputDecoration.copyWith(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: _roles.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(role),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedRole = value!;
            });
          },
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
          onPressed: _isLoading ? null : _navigateBasedOnRole,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                NavigationUtils.showComingSoonDialog(context);
              },
              child: const Text(
                'Forget Password?',
                style: TextStyle(
                  color: AppColors.linkColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(color: AppColors.textColor),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                'Register',
                style: TextStyle(
                  color: AppColors.linkColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
