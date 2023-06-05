import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_tracker/app/constants/constants.dart';
import 'package:work_tracker/app/screens/signup_login_screens/auth_page.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Things to do"),
      centerTitle: true,
      backgroundColor: scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showLogoutMenu(context);
          },
        ),
      ],
    );
  }

  void showLogoutMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, kToolbarHeight, 0, 0),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {

              // Sign out the user
              FirebaseAuth.instance.signOut();

              // Close the menu
              Navigator.pop(context);

              // Navigate to the authentication page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
            },
          ),
        ),
      ],
    );
  }
}
