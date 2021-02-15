import 'package:firebase_core/firebase_core.dart';

class FirebaseInit{

  static Future initFirebase() async{
     try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp(name: 'students');
      print('done');
     
    } catch(e) {
 print('Error');     
    }
  }
}