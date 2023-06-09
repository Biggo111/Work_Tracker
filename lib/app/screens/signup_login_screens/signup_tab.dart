import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_tracker/app/constants/constants.dart';
import 'package:work_tracker/app/screens/signup_login_screens/login_tab.dart';

import '../../core/services/firebase_auth_methods.dart';

class SignupTab extends StatefulWidget {
  const SignupTab({super.key});

  @override
  State<SignupTab> createState() => _SignupTabState();
}

class _SignupTabState extends State<SignupTab> {
  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmpasswordController = TextEditingController();

  Future<bool> signupUser() async {

    // Sign up user using FirebaseAuthMethods
    return FirebaseAuthMethods(FirebaseAuth.instance).signUp(
      email: signupEmailController.text.trim(),
      password: signupPasswordController.text.trim(),
      name: signupNameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(
          height: 30,
        ),
        TextField(
          decoration: const InputDecoration(
            enabled: true,
            suffixIcon: Icon(Icons.person),
            hintText: "Enter Username",
            hintStyle: TextStyle(
              color: Colors.black38,
              fontFamily: 'Ubuntu',
              fontSize: 20,
            ),
          ),
          controller: signupNameController,
          onChanged: (String value) {},
        ),
        const SizedBox(
          height: 30,
        ),
        TextField(
          decoration: const InputDecoration(
            enabled: true,
            suffixIcon: Icon(Icons.email),
            hintText: "Enter your email",
            hintStyle: TextStyle(
              color: Colors.black38,
              fontFamily: 'Ubuntu',
              fontSize: 20,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          controller: signupEmailController,
          onChanged: (String value) {},
        ),
        const SizedBox(
          height: 30,
        ),
        TextField(
          decoration: const InputDecoration(
            enabled: true,
            suffixIcon: Icon(Icons.lock),
            hintText: "Enter password",
            hintStyle: TextStyle(
              color: Colors.black38,
              fontFamily: 'Ubuntu',
              fontSize: 20,
            ),
          ),
          controller: signupPasswordController,
          onChanged: (String value) {},
        ),
        const SizedBox(
          height: 30,
        ),
        TextField(
          decoration: const InputDecoration(
            enabled: true,
            suffixIcon: Icon(Icons.lock),
            hintText: "Confirm password",
            hintStyle: TextStyle(
              color: Colors.black38,
              fontFamily: 'Ubuntu',
              fontSize: 20,
            ),
          ),
          controller: signupConfirmpasswordController,
          onChanged: (String value) {},
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          height: 45,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (signupNameController.text.isEmpty ||
                  signupEmailController.text.isEmpty ||
                  signupPasswordController.text.isEmpty ||
                  signupConfirmpasswordController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Alert!!'),
                      content: const Text('Fill up all the fields'),
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
              } else if (signupPasswordController.text !=
                  signupConfirmpasswordController.text) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Alert!!'),
                      content: const Text(
                          'Password and confirm password is not matching'),
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
                bool check = await signupUser(); //Calling the Method to Signup
                if (check == true) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Signed Up successfully'),
                        content: const Text('Please verify before login!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginTab()),
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error!'),
                        content: const Text('Please Try Again'),
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
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: const Text(
              "Signup",
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
