import 'package:flutter/material.dart';
import 'package:work_tracker/app/core/services/firebase_service.dart';
import 'package:work_tracker/app/screens/signup_login_screens/auth_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.enableFirebase();
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
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: const AuthPage(),
    );
  }
}
