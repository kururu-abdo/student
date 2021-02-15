import 'package:flutter/material.dart';
import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';

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
    return Container(

  decoration: BoxDecoration(


  ),


child: ListView.builder(
  itemCount: 1,
  itemBuilder: (BuildContext context, int index) {
  return ;
 },
),

    );
  }
}