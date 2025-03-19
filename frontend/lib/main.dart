import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './Pages/Login/Login.dart';
// import './Pages/Register/Register.dart';
import './Pages/Admin/admin.dart';
import 'Pages/Teachers/Teachears.dart';
import 'Pages/HM/HM.dart';
import 'Pages/MS/MS.dart';
import 'Pages/RC/MS.dart';
import './Pages/Psychiatrist/Psychiatrist.dart';
import './Pages/SkipPage/skip.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  runApp(MyApp());
}

Future<void> requestPermissions() async {
  // Check and request Internet permission

  // Check and request Location permission
  if (await Permission.location.request().isGranted) {
    print('Location permission granted');
  } else if (await Permission.location.isPermanentlyDenied) {
    // If permanently denied, open app settings
    await openAppSettings();
  }
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
        '/admin': (context) => AdminScreen(),
        '/teacher': (context) => TeacherScreen(),
        '/hs-ms': (context) => HMScreen(),
        '/ms': (context) => MSScreen(),
        '/rc': (context) => RCScreen(),
        '/psychiatrist': (context) => PsychiatristScreen(),
      },
    );
  }
}
