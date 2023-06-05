import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:work_tracker/app/Models/item_model.dart';
import 'package:work_tracker/app/core/Repositories/user_repository.dart';
import 'package:work_tracker/app/screens/home_screen/home_screen.dart';

class ItemRepository {
  BuildContext context;
  ItemRepository({required this.context});

  Future<void> submitData(title, description) async {
    final body = {
      "title": title,
      "body": description,
    };
    const url = "https://jsonplaceholder.typicode.com/posts";

    final uri = Uri.parse(url);

    // Send a POST request to the specified URL with the body containing title and description
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-type': 'application/json'});

    Logger().i(response.statusCode);
    if (response.statusCode == 201) {
      Logger().i("Success");
      showSuccessMessage("Item added");

      // Get the user ID of the current authenticated user
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Create an ItemModel object with the provided title, description, and user ID
      ItemModel itemModel =
          ItemModel(userid: userId, title: title, description: description);

      // Store the item data in Firestore
      await storeData(itemModel, userId);
    } else {
      Logger().i("Error");
      showSuccessMessage("Error! Try again later");
    }
  }

  void showSuccessMessage(String message) {

    // Show a snackbar with the given message
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> storeData(ItemModel itemModel, userId) async {
    if (userId != null) {
      // Retrieve the user's data from Firestore using the user ID
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('User Info')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        // Get the username from the user's data
        Map<String, dynamic>? userData = snapshot.data();
        String username = userData!['name'];
        Logger().i(username);

        // Create a UserRepository instance
        UserRepository userRepository = UserRepository();

        // Add the item to the user's data in Firestore
        userRepository.addItem(username, itemModel);

        // Navigate to the HomeScreen
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      }
    } else {
      Logger().i("Problem is here!");
    }
  }

}
