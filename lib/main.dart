import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:load/load.dart';
import 'package:student_side/ui/views/welcome_screen.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
  await GetStorage.init();

  runApp(LoadingProvider(child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    @override
    void initState() { 
      super.initState();
      
    }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      locale: Locale('ar' ,'AR')  ,

      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        primaryColor:Colors.green
      ),
      home:  WelcomeScreen()
    );
  }
}