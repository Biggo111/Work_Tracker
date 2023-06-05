import 'package:flutter/material.dart';
import 'package:work_tracker/app/core/services/firebase_service.dart';
import 'package:work_tracker/app/screens/home_screen/home_screen.dart';
import 'package:work_tracker/app/screens/signup_login_screens/auth_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase services
  await FirebaseService.enableFirebase();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WorkTracker App',
      home: AuthPage(),
    );
  }
}
