import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/appStyle.dart';
import '../../utils/appColor.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onForgetPasswordTap;

  LoginForm({required this.onForgetPasswordTap});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _selectedRole = '';
  final List<String> _roles = [
    'Admin', 'Teacher', 'SC', 'HM', 'MS', 'Psychiatrist',
    'Students', 'ASA', 'CIF', 'RC', 'Warden'
  ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Auto-login check when screen loads
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
        case 'warden':
        case 'asa':
        case 'cif':
          Navigator.pushReplacementNamed(context, '/teacher');
          break;
        case 'hs-ms':
          Navigator.pushReplacementNamed(context, '/hs-ms');
          break;
        case 'ms':
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid role saved.")),
          );
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

    try {
      if (role == 'hm') {
        role = 'hs-ms';
      }

      final response = await http.post(
        Uri.parse('http://13.232.9.135:3000/api/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'role': role, 'email': email, 'password': password}),
      );

      final responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('token') && responseBody.containsKey('user')) {
        final token = responseBody['token'];
        final user = responseBody['user'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(user));
        await prefs.setString('token', token);
        await prefs.setString('role', role);
         if (role == 'hs-ms') {
            await prefs.setString('School_name', user['SCHOOL_NAME']);
            await prefs.setString('district', user['DISTRICT']);
          } else if (role == 'psychiatrist') {
            await prefs.setString('DISTRICT_PSYCHIATRIST_NAME', user['DISTRICT_PSYCHIATRIST_NAME']);
          }else if( role == 'rc'){
            await prefs.setString('Zone', user['Zone']);
          }else if(role == 'teacher'){
            await prefs.setString('district', user['district']);
          }else if(role == 'psychiatrist'){
            await prefs.setString('district', user['district']);
          }
        Navigator.pushReplacementNamed(context, '/$role');
      } else {
        final errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorResponse['msg'] ?? 'Login failed.')),
        );
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
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
        Text('Role', style: AppStyles.labelText),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: _selectedRole.isEmpty ? null : _selectedRole,
          decoration: AppStyles.inputDecoration(hintText: 'Select Role'),
          items: _roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
          onChanged: (value) => setState(() => _selectedRole = value!),
        ),
        const SizedBox(height: 10),

        Text('Email / UDISE / EMIS ID', style: AppStyles.labelText),
        const SizedBox(height: 5),
        TextField(
          controller: _emailController,
          decoration: AppStyles.inputDecoration(
            hintText: 'Enter Email / UDISE / EMIS ID',
            prefixIcon: Icon(Icons.email, color: AppColors.iconColor),
          ),
        ),
        const SizedBox(height: 10),

        Text('Password', style: AppStyles.labelText),
        const SizedBox(height: 5),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: AppStyles.inputDecoration(
            hintText: 'Enter Password',
            prefixIcon: Icon(Icons.lock, color: AppColors.iconColor),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.iconColor,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: widget.onForgetPasswordTap,
            child: Text('Forgot your password?', style: AppStyles.linkText),
          ),
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          style: AppStyles.buttonStyle,
          onPressed: _isLoading ? null : _handleLogin,
          child: _isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text('Login', style: AppStyles.buttonText),
        ),

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account? ", style: TextStyle(color: AppColors.textColor)),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/register'),
              child: Text('Register', style: AppStyles.linkText),
            ),
          ],
        ),
      ],
    );
  }
}
