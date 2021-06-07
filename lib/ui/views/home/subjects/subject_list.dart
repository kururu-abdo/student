import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_side/app/subject_bloc.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:provider/provider.dart';
class SubjectList extends StatefulWidget {

  final Department  dept;

  final Level level;


  SubjectList(this.dept ,this.level);

  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  @override
  Widget build(BuildContext context) {
    CollectionReference subjects = FirebaseFirestore.instance.collection('subjects')
    .where('dept' , isEqualTo:widget.dept.id??1)
    .where('level' , isEqualTo:widget.level.id??1)
    ;


var subjectProvider =  Provider.of<SubjectProvider>(context);
var studentProvider =  Provider.of<UserProvider>(context);
      return StreamBuilder<QuerySnapshot>(
      stream: subjects.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
          //  return   ConsultCard(consult:document.data());
            
          return  Text(document.data().toString(),maxLines: 16,);
            new ListTile(
              title: new Text(document.data()['full_name']),
              subtitle: new Text(document.data()['company']),
            );
          }).toList(),
        );
      },
    );
  }
}