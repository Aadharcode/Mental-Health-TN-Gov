import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/appStyle.dart';
import '../../utils/appColor.dart';
import '../../utils/navigation.dart';
import '../../../backendUrl.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'Admin'; // Default role
  final List<String> _roles = ['Admin', 'Teacher', 'HS and MS', 'psychiatrist', 'Students'];

  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final role = _selectedRole.toLowerCase().replaceAll(' ', '-'); 

    try {
      final response = await http.post(
        Uri.parse('BackendUrl.baseUrl/api/signin'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'role': role, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        // final user = responseData['user'];

        if (token != null) {
          // Store the token if necessary (e.g., shared_preferences)
          // Navigate based on the role
          switch (role) {
            case 'admin':
              Navigator.pushNamed(context, '/admin');
              break;
            case 'teacher':
              Navigator.pushNamed(context, '/teachers');
              break;
            case 'hs-and-ms':
              Navigator.pushNamed(context, '/hs-ms');
              break;
            case 'psychiatrist':
              Navigator.pushNamed(context, '/psychiatrist');
              break;
            case 'students':
              Navigator.pushNamed(context, '/students');
              break;
            default:
              NavigationUtils.showSnackBar(context, "Role navigation not configured.");
          }
        } else {
          NavigationUtils.showSnackBar(context, "Token missing in response.");
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        NavigationUtils.showSnackBar(context, errorResponse['msg'] ?? 'Login failed.');
      }
    } catch (error) {
      NavigationUtils.showSnackBar(context, "An error occurred. Please try again.");
      print("Error during login: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _emailController,
          decoration: AppStyles.inputDecoration.copyWith(hintText: 'Email / UDISE / EMIS ID'),
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
          onPressed: _isLoading ? null : _handleLogin,
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
