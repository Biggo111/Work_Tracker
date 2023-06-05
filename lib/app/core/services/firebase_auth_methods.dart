import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:work_tracker/app/Models/user_model.dart';
import 'package:work_tracker/app/core/Repositories/user_repository.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
// String userName;
// String email;
// String password;
  FirebaseAuthMethods(this._auth);

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {

      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final userData = UserModel(name: name, email: email);
      UserRepository userRepository = UserRepository();
      userRepository.createUser(userData);

      _auth.currentUser!.sendEmailVerification();

    } on FirebaseAuthException catch (e) {
      Logger().i(e);
      return false;
    }
    return true;
  }


  Future<bool>login({
    required String email, 
    required String password
  })async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if(user!=null){
        if(!user.emailVerified){
          Logger().i("You need to verify through your email");
          return false;
        }
      }
      return true;
    } on FirebaseAuthException catch (e){
      Logger().i(e);
    }
    return false;
  }



  Future<void> forgotPassword({
    required String email,
  }) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
