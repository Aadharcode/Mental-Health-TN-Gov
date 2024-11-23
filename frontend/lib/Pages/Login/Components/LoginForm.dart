import 'package:flutter/material.dart';
import '../../utils/appStyle.dart';
import '../../utils/appColor.dart';
import '../../utils/navigation.dart'; 

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _selectedRole = 'Admin'; // Default role

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: AppStyles.inputDecoration.copyWith(hintText: 'Email'),
        ),
        SizedBox(height: 10),
        TextField(
          obscureText: true,
          decoration: AppStyles.inputDecoration.copyWith(hintText: 'Password'),
        ),
        SizedBox(height: 20),
        Text(
          'Select Role:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        ListTile(
          title: Text('Admin'),
          leading: Radio<String>(
            value: 'Admin',
            groupValue: _selectedRole,
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('Teachers'),
          leading: Radio<String>(
            value: 'Teachers',
            groupValue: _selectedRole,
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('HS and MS'),
          leading: Radio<String>(
            value: 'HS and MS',
            groupValue: _selectedRole,
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('Psychiatrist'),
          leading: Radio<String>(
            value: 'Psychiatrist',
            groupValue: _selectedRole,
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.whiteColor,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {
            // Navigate based on the selected role
            switch (_selectedRole) {
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
              default:
                NavigationUtils.showComingSoonDialog(context);
            }
          },
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                NavigationUtils.showComingSoonDialog(context);
              },
              child: Text(
                'Forget Password?',
                style: TextStyle(
                  color: AppColors.linkColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
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
              child: Text(
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
