import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:student_side/ui/views/home/home_screen.dart';
import 'package:student_side/util/constants.dart';
import 'auth_page.dart';
class WelcomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
  return _State();
  }



}

class _State extends State<WelcomeScreen>{
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();



@override
  void initState() {
    // TODO: implement initState
    super.initState();

 _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
    //    _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
   //     _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
     //   _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        getStorage.write('token', token);
        "Push Messaging token: $token";
      });
      print(token);
    });
    startTimer();
      }
    
    
    
      @override
      Widget build(BuildContext context) {
       
    
       return Container(
         color: Colors.white,
                child: Center(
    child: Image.asset('assets/images/user.png' ,
    
    width:  250 ,
    height: 250 ,
    
    ),
    
         ),
       );
      }
    
      void Function() navaigate(BuildContext context) {




      }



 void startTimer() {
    Timer(Duration(seconds: 5), () {
      checkIfuserLoggedIn(); //It will redirect  after 3 seconds
    });
  }
  checkIfuserLoggedIn()  {


  var state  =  getStorage.read('islogged') ?? false;
print('check if logged in');
print(getStorage.read('islogged'));
print(state);
if(state){
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Material(child: HomeView())));

}else{
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Material(child: Auth())));


}
}
}