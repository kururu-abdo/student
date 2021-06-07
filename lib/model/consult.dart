import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/model/student.dart';

class Consult{
String id; 

String body;
Student student;
Department dept;
Level   level;

Consult(this.id , this.body , this.dept ,this.level , this.student);



Consult.fromJson(Map<dynamic ,dynamic> data){

this.id = data['id'];
this.body =  data['consult'];
this.dept =  Department.fromJson(data['dept']);
this.level = Level.fromJson(data['level']);
this.student = Student.fromJson(data['student']);

}


Map<dynamic ,dynamic> toJson(){
  return {
'id': this.id ,
'consult' : this.body ,
'dept' : this.dept ,
'level': this.level ,
'student': this.student
 
  };
}

}