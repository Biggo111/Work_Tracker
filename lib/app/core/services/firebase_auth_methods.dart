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

      // Create a user using email and password
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Create a UserModel object with the provided name and email
      final userData = UserModel(name: name, email: email);

      // Create a UserRepository instance
      UserRepository userRepository = UserRepository();

      // Call the createUser method of UserRepository to save the user data
      userRepository.createUser(userData);

      // Send email verification to the user
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
      // Sign in the user with email and password
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
    // Send a password reset email to the provided email address
    await _auth.sendPasswordResetEmail(email: email);
  }
}
