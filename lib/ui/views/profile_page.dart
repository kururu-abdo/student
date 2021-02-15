import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/model/student.dart';

import '../../util/constants.dart';
class ProfilePage extends StatefulWidget{
ProfilePage();
  @override
  State<StatefulWidget> createState() {
    return _State();
  }


}

class _State extends State<ProfilePage>{
String image;
String name;
String email;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
   // fetchUser();
   fetchStudnet();
  }
Department dept;
Level level;

fetchStudnet() async {
    var future = await showLoadingDialog();

var data =  getStorage.read('student');
var student=  Student.fromJson( json.decode(data) );
print(student.name);
var user_image =   await   downloadURLExample(student.profile_image)  ;
 setState(()  {
    
     name =student.name;
    email= student.email;
    image= user_image;
   
    dept = Department.fromJson(student.department.toJson());
    level= Level.fromJson(student.level.toJson());
  });


  future.dismiss();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(title: Text('User Profile' ,) ,centerTitle: true,),
body: Column(

  children:[
Center(child: Hero(
  tag: 'image',
  child: Image.network(image?? 'https://th.bing.com/th/id/OIP.3wMJFpWlVPMNerfbxhKJTgHaHa?pid=Api&rs=1'),
),),

SizedBox(height:30) ,

Text(name ??'') ,
Text(email ??'')
  ]
),

    );
  }



Future<String> downloadURLExample(String imageUrl) async {
  String downloadURL = await FirebaseStorage.instance
       .ref('${imageUrl}')
      .getDownloadURL();

      print('kdkjdfldkfldk;fk;dkf;d;fkd;fk;dfk;dkf;');
      print(downloadURL);


return downloadURL;
  // Within your widgets:
  // Image.network(downloadURL);
}

}