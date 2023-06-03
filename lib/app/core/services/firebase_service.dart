import 'package:firebase_core/firebase_core.dart';

import '../../../firebase_options.dart';

class FirebaseService{
  static Future<void> enableFirebase () {
    return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  }
}