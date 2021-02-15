import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';

class Student{

  String name;

String  id_number;
String password;
String profile_image;
Department department;
Level level;
String email;


Student(this.name ,this.id_number  ,this.password  ,this.department  ,this.level ,this.profile_image ,this.email );



Student.fromJson(Map<dynamic ,dynamic> data){

  this.name=data['name'];

  this.id_number = data['id_number'];
  this.email = data['email'];
  this.password = data['password'];
  this.profile_image = data['profile'];

  this.department =  Department.fromJson(data['dept']);
  this.level = Level.fromJson( data['level']);




}

Map<dynamic ,dynamic> toJson() => {
'name' : this.name ,

'id_number': this.id_number ,
'email': this.email ,
'password': this.password ,
'profile':this.profile_image ,
'dept': this.department.toJson() ,

'level' : this.level.toJson() };







}