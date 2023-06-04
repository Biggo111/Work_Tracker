import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:work_tracker/app/Models/item_model.dart';
import 'package:work_tracker/app/Models/user_model.dart';

class UserRepository{
  String? userId = FirebaseAuth.instance.currentUser!.uid;
  final _db = FirebaseFirestore.instance;
  createUser(UserModel user)async{
   await  _db.collection("User Info").doc(userId).set(user.toJson()).whenComplete((){
    Logger().i("Signup Successful");
    });
  }
  addItem(String username, ItemModel itemModel)async{
    await _db.collection(username).doc().set(itemModel.toMap());
  }
}