import 'package:flutter/material.dart';
import './Pages/Login/Login.dart';
import './Pages/Register/Register.dart';
import './Pages/Admin/Admin.dart';
// import './Pages/Teachers/TeacherScreen.dart';
// import './Pages/HSMS/HSMScreen.dart';
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
        '/register': (context) => RegisterScreen(),
        '/admin': (context) => AppNavigator(),
        // '/teachers': (context) => TeacherScreen(),
        // '/hs-ms': (context) => HSMScreen(),
        '/psychiatrist': (context) => PsychiatristScreen(),
      },
    );
  }
}
