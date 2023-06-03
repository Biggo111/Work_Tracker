import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:work_tracker/app/constants/constants.dart';
import 'package:work_tracker/app/screens/home_screen/home_screen.dart';

import '../../core/services/firebase_auth_methods.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  String? userType;

  Future<bool> loginUser() async {
    bool isLogin = await FirebaseAuthMethods(FirebaseAuth.instance).login(
      email: loginEmailController.text.trim(),
      password: loginPasswordController.text.trim(),
    );
    return isLogin;
  }

  void passwordReset() {
    FirebaseAuthMethods(FirebaseAuth.instance).forgotPassword(
      email: loginEmailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          TextFormField(
            decoration: InputDecoration(
              enabled: true,
              suffixIcon: Icon(Icons.person),
              hintText: "Enter Email",
              hintStyle: TextStyle(
                color: Colors.black38,
                fontFamily: 'Ubuntu',
                fontSize: 20,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            controller: loginEmailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            onChanged: (String value) {},
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              enabled: true,
              suffixIcon: Icon(Icons.lock),
              hintText: "Enter Password",
              hintStyle: TextStyle(
                color: Colors.black38,
                fontFamily: 'Ubuntu',
                fontSize: 20,
              ),
            ),
            controller: loginPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            onChanged: (String value) {},
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 125,
            ),
            child: TextButton(
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    color: Colors.black45,
                  ),
                ),
                onPressed: () {
                  if (loginEmailController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Email Field Empty!'),
                          content: const Text('Please Enter Your Email!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    passwordReset();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Please Verify!'),
                          content: const Text(
                              'Reset Password Email is sent. Please reset your password'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }),
          ),
          const SizedBox(
            height: 120,
          ),
          SizedBox(
            height: 45,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (loginEmailController.text.isEmpty ||
                    loginPasswordController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Empty fields'),
                        content:
                            const Text('Please Enter Your Email and Password!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  bool check = await loginUser();
                  if (check == true) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  } else {
                    Logger().i("Wrong email or password");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
