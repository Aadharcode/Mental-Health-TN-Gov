import 'package:flutter/material.dart';
import './Pages/Login/Login.dart';
// import './Pages/Register/Register.dart';
import './Pages/Admin/admin.dart';
import 'Pages/Teachers/Teachears.dart';
import './Pages/HS-MS/HSMS.dart';
import './Pages/Psychiatrist/Psychiatrist.dart';

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
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        // '/register': (context) => RegisterScreen(),
        '/admin': (context) =>AdminScreen(),
        '/teachers': (context) => TeacherScreen(),
        '/hs-ms': (context) => HSMSScreen(),
        '/psychiatrist': (context) => PsychiatristScreen(),
      },
    );
  }
}
