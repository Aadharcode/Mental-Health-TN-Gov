import 'package:flutter/material.dart';
import '../../utils/appStyle.dart';
import '../../utils/appColor.dart';
import '../../utils/navigation.dart'; 

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: AppStyles.inputDecoration.copyWith(hintText: 'Email'),
        ),
        SizedBox(height: 10),
        TextField(
          obscureText: true,
          decoration: AppStyles.inputDecoration.copyWith(hintText: 'Password'),
        ),
        SizedBox(height: 10),
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
           NavigationUtils.showComingSoonDialog(context); 
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
