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
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-type': 'application/json'});

    Logger().i(response.statusCode);
    if (response.statusCode == 201) {
      Logger().i("Success");
      showSuccessMessage("Item added");
      String userId = FirebaseAuth.instance.currentUser!.uid;
      ItemModel itemModel =
          ItemModel(userid: userId, title: title, description: description);
      await storeData(itemModel, userId);
    } else {
      Logger().i("Error");
      showSuccessMessage("Error! Try again later");
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> storeData(ItemModel itemModel, userId) async {
    if (userId != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('User Info')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? userData = snapshot.data();
        String username = userData!['name'];
        Logger().i(username);
        UserRepository userRepository = UserRepository();
        userRepository.addItem(username, itemModel);
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
