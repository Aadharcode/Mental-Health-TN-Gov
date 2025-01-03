import 'package:flutter/material.dart';
import './Pages/Login/Login.dart';
// import './Pages/Register/Register.dart';
import './Pages/Admin/admin.dart';
import 'Pages/Teachers/Teachears.dart';
import 'Pages/HM/HM.dart';
import 'Pages/MS/MS.dart';
import './Pages/Psychiatrist/Psychiatrist.dart';
import './Pages/SkipPage/skip.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: OnboardingScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        // '/register': (context) => RegisterScreen(),
        '/admin': (context) =>AdminScreen(),
        '/teachers': (context) => TeacherScreen(),
        '/hm': (context) => HMScreen(),
        '/ms': (context) => MSScreen(),
        '/psychiatrist': (context) => PsychiatristScreen(),
      },
    );
  }
}
