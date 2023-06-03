import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

import '../../../firebase_options.dart';

class FirebaseService{
  static Future<void> enableFirebase () {
    return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp app){
    Logger().i("Firebase Initialized");
    return app;
  });
  }
}