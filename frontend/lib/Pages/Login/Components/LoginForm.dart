import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/appStyle.dart';
import '../../utils/appColor.dart';
import '../../utils/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onForgetPasswordTap;

  LoginForm({required this.onForgetPasswordTap});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'Admin'; // Default role
  final List<String> _roles = ['Admin', 'Teacher', 'SC','HM', 'MS', 'Psychiatrist', 'Students', 'ASA', 'CIF', 'RC', 'Warden'];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role');

    if (token != null && role != null) {
      // Navigate based on the saved role
      switch (role) {
        case 'admin':
          Navigator.pushReplacementNamed(context, '/admin');
          break;
        case 'teacher':
          Navigator.pushReplacementNamed(context, '/teachers');
          break;
        case 'warden':
          Navigator.pushReplacementNamed(context, '/teachers');
          break;
        case 'asa':
          Navigator.pushReplacementNamed(context, '/teachers');
          break;
        case 'cif':
          Navigator.pushReplacementNamed(context, '/teachers');
          break;
        case 'hs-ms':
          Navigator.pushReplacementNamed(context, '/hm');
          break;
        case 'ms':
          Navigator.pushReplacementNamed(context, '/ms');
          break;
        case 'sc':
          Navigator.pushReplacementNamed(context, '/ms');
          break;
        case 'rc':
          Navigator.pushReplacementNamed(context, '/rc');
          break;
        case 'psychiatrist':
          Navigator.pushReplacementNamed(context, '/psychiatrist');
          break;
        case 'students':
          Navigator.pushReplacementNamed(context, '/students');
          break;
        default:
          NavigationUtils.showSnackBar(context, "Invalid role saved.");
      }
    }
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    var role = _selectedRole.toLowerCase();
    if (role == 'hm') {
      role = 'hs-ms';
    }

    try {
      final response = await http.post(
        Uri.parse('http://13.232.9.135:3000/api/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'role': role, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        final user = responseData['user'];

        if (token != null) {
          // Store the token and role in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('role', role);

          if (role == 'hs-ms') {
            await prefs.setString('School_name', user['SCHOOL_NAME']);
            await prefs.setString('district', user['DISTRICT']);
          } else if (role == 'psychiatrist') {
            await prefs.setString('DISTRICT_PSYCHIATRIST_NAME', user['DISTRICT_PSYCHIATRIST_NAME']);
          }else if( role == 'rc'){
            await prefs.setString('Zone', user['Zone']);
          }else if(role == 'teachers'){
            await prefs.setString('district', user['district']);
          }else if(role == 'psychiatrist'){
            await prefs.setString('district', user['district']);
          }

          // Navigate based on the role
          switch (role) {
            case 'admin':
              Navigator.pushNamed(context, '/admin');
              break;
            case 'teacher':
              Navigator.pushNamed(context, '/teachers');
              break;
            case 'warden':
              Navigator.pushNamed(context, '/teachers');
              break;
            case 'asa':
              Navigator.pushNamed(context, '/teachers');
              break;
            case 'cif':
              Navigator.pushNamed(context, '/teachers');
              break;
            case 'hs-ms':
              Navigator.pushNamed(context, '/hm');
              break;
            case 'ms':
              Navigator.pushNamed(context, '/ms');
              break;
            case 'rc':
              Navigator.pushNamed(context, '/rc');
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
      NavigationUtils.showSnackBar(context, "An error occurred. Please try again");
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
              onTap: widget.onForgetPasswordTap,
              child: const Text(
                'Forget Password?',
                style: TextStyle(color: Colors.blue),
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
