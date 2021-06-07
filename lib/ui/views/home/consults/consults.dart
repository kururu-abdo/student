import 'dart:convert';


import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/model/student.dart';
import 'package:student_side/ui/views/home/consults/comments.dart';
import 'package:student_side/ui/views/home/consults/consult_card.dart';
import 'package:student_side/ui/views/home/consults/new_consult.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/firebase_init.dart';
import 'package:student_side/util/ui/app_colors.dart';
import 'package:student_side/util/ui/pop_up_card.dart';

class Consults extends StatefulWidget {
  Consults({Key key}) : super(key: key);

  @override
  _ConsultsState createState() => _ConsultsState();
}

class _ConsultsState extends State<Consults> {
  static const String id='/consults';
@override
void initState() { 
  super.initState();
  FirebaseInit.initFirebase();

  student();
}
Department department;
Level level;
student() async{
var data =getStorage.read('student');
Student student =  Student.fromJson(json.decode(data));
setState(() {
  this.department = student.department;
  this.level =  student.level;
});
}

  @override
  Widget build(BuildContext context) {
       Query consults = FirebaseFirestore.instance.collection('consults').where('dept'  , isEqualTo: this.department.toJson())
       .where('level' , isEqualTo:this.level.toJson())
       ;

      return SafeArea(
        child: Scaffold(
         appBar: AppBar(
  backgroundColor: AppColors.primaryColor,
  elevation: 0.0,
            title: Text('الاستفسارات' ,  style: TextStyle(color: Colors.black),),
            centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios ,  color: Colors.black,), onPressed: (){
            Navigator.of(context).pop();
          }),

         ),
          body: StreamBuilder<QuerySnapshot>(
          stream: consults.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return   ConsultCard(consult:document.data());
                
              
              }).toList(),
            );
          },
    ),

    floatingActionButton: SpeedDial(

            /// both default to 16
            marginEnd: 18,
            marginBottom: 20,
          
            icon: Icons.add,
            activeIcon: Icons.remove,
           
            buttonSize: 56.0,
            visible: true,

            closeManually: false,

            renderOverlay: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Color.fromARGB(255, 249,170,51),
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: CircleBorder(),
         
            children: [
             
              SpeedDialChild(
                child: Icon(Icons.question_answer),
                backgroundColor: Colors.black,
                label: 'اضافة استفسار',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () =>
                    Navigator.of(context).push(HeroDialogRoute(builder: (_) {
                  return NewConsult();
                })),
                onLongPress: () => print('FIRST CHILD LONG PRESS'),
              ),
            ]),
        ),




      );
  }
}