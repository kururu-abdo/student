
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/model/student.dart';
import 'package:student_side/ui/views/home/consults/new_consult.dart';
import 'package:student_side/ui/views/logout/logout_view.dart';
import 'package:student_side/ui/views/welcome_screen.dart';
import 'package:student_side/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase_storage;
import '../courses_page.dart';
import '../profile_page.dart';





class HomeView extends StatefulWidget{

  final String user_id;

  const HomeView({Key key, this.user_id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
return  _State();  }



}

class _State extends State<HomeView>{

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String image;
String name;
String email;
Department dept;
Level level;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  fetchStudnet();

 //subscribe();
  print(getStorage.read('student'));

  print(getStorage.read('student').runtimeType);
  regUser();
  getToken();
  }
  regUser() async{
try {
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: "barry.allen@example.com",
    password: "SuperSecretPassword!"
  );
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }
} catch (e) {
  print(e);
}
  }
  getToken() async{
    final user = await FirebaseAuth.instance.currentUser;
  final idToken = await user.getIdToken();
  print(idToken);
  }
  subscribe(){
_firebaseMessaging.subscribeToTopic("${this.level.id}");

  }




fetchStudnet() async {
var data =  getStorage.read('student');
var student=  Student.fromJson( json.decode(data) );
var user_image =   await   downloadURLExample(student.profile_image)??''  ;
 setState(()  {
    
    
    image= user_image;
    name =student.name;
    
    email= student.email;
    dept = Department.fromJson(student.department.toJson());
    level= Level.fromJson(student.level.toJson());
  });
  // var user =users.firstWhere((element) => element['user_id']=='dkjkfkdjf100998');
  // setState(() {
    

  //   image=user['profile'];
  //   name =user['user_name'];
  //   email= user ['email'];
  // });
}
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(appBar: AppBar(

    centerTitle: true,
    title:Text('Students App' ,   style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 30),))
    ,
    drawer: Drawer(


 child: ListView(
        padding: EdgeInsets.zero,
        children: [

DrawerHeader(
  
    child: Column(
children: [
GestureDetector(
  onTap: (){
    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage()));

  },
  child:   Container(
  
    width:120,
  
    height:120,
  
    decoration: BoxDecoration(
  
      shape:BoxShape.circle
  
    ),
  
    child:   Hero(
  
    
  
      tag: 'image',
  
    
  
      child: Image.network(image??'data:image/jpeg;base64,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'),
  
    
  
    ),
  
  ),
) ,


Text(name ?? '')

],

    ),
    
         ),

         ListTile(
    title: Row(
      children: <Widget>[
        Icon(Icons.home),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('My subjects'),
        )
      ],
    ),
    onTap: (){
Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Material(child: CourseDetail())));
    },
  ) ,

  
         ListTile(
    title: Row(
      children: <Widget>[
        Icon(Icons.calendar_view_day_sharp),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Events'),
        )
      ],
    ),
    onTap: (){

    },
  ) ,

         ListTile(
    title: Row(
      children: <Widget>[
        Icon(Icons.star),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Featured'),
        )
      ],
    ),
    onTap: (){

    },
  ) ,

         ListTile(
    title: Row(
      children: <Widget>[
        Icon(Icons.play_arrow),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('notifications'),
        )
      ],
    ),
    onTap: (){

    },
  ) ,


 



         ListTile(
    title: Row(
      children: <Widget>[
        Icon(Icons.build),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('About college'),
        )
      ],
    ),
    onTap: (){

    },
  ) ,
      ListTile(
    title: Row(
      children: <Widget>[
        Icon(Icons.build),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('استفسار'),
        )
      ],
    ),
    onTap: (){
Navigator.of(context).push(MaterialPageRoute(builder:(_)=>NewConsult()));
    },
  ) ,


         ListTile(
    title: Row(
      children: <Widget>[
        Icon(Icons.build),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('logout'),

        )
      ],
    ),
    onTap: ()  async{
      getStorage.write('islogged', false);

getStorage?.remove('islogged');

 Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen()),
     (Route<dynamic> route) => false
    );      

    },
  ) ,
        ],
        
        
        
        
        
        )


    ) ,
   body: 
   
   
   ListView(
     children:[
SizedBox(height:10 ) ,


Image.asset('assets/images/dental_cover.jpg' ,width:double.infinity) ,

SizedBox(height:8.0) ,
Text('categories' ,  style: TextStyle(fontSize:15),) ,
SizedBox(height:8.0) ,

Container(
  height:100 ,

  color:Colors.black45 ,
  child:   ListView.builder(
  // shrinkWrap: true,
    scrollDirection: Axis.horizontal,
  
    itemCount: lecures.length,
  
    itemBuilder: (BuildContext context, int index) {
  
    return   Card(
  
  color: Theme.of(context).accentColor,
  
  child: lecureDetails(lecures[index])
    
    
    
      ) ;
    
     },
    
    )
  ),
  
  SizedBox(height:20) ,
  
  Text('Top courses in Orthedentic Program') ,
  
  Container(
    height: 220,
   child: ListView.builder(
     scrollDirection: Axis.horizontal,
     itemCount: courses.length,
     itemBuilder: (BuildContext context, int index) {
     return   Column(
       children:[
         InkWell(

           onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Material(child: CourseDetail(course_id:courses[index]['course_id']))));

           },
                    child: Stack(
             children:[
Image.network(courses[index]['img'] , width:180 ,height:200) ,

Positioned(bottom:10 ,right :20 ,child: Container(

decoration:BoxDecoration(
  shape: BoxShape.circle ,

) ,
child: Icon(Icons.shopping_cart)

),)
             ]
           ),
         ) ,


         Text(courses[index]['course_title'])
       ]
     )  ;
    },
   ),
  )
  
         
       ]
     ),
  
  
      
      );
    }
  
 Widget   lecureDetails(lecur) {
   var subject =   sujects.firstWhere((element) => element['suject_id']==lecur['subject_id']);
   return Stack(

     children: [
       Positioned( top:8  ,child:Text(lecur['title'])) ,
       Center(child: Text(subject['subject_name']))
     ],
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