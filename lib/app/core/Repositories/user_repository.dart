import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:work_tracker/app/Models/user_model.dart';

class UserRepository{
  final _db = FirebaseFirestore.instance;
  createUser(UserModel user)async{
   await  _db.collection("User Info").add(user.toJson()).whenComplete((){
    Logger().i("Signup Successful");
    });
  }
}