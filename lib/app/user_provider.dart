

import 'dart:convert';

import 'package:student_side/model/student.dart';
import 'package:student_side/util/constants.dart';

class UserProvider{

Future<void> updateId(String id)  async{
    var student = Student.fromJson(json.decode(getStorage.read('student')));
        student.id_number= id;

      await   getStorage.write('student', json.encode(student.toJson()) );



}

Future<void>  updateStudent(Student newStudent) async{
      var student = Student.fromJson(json.decode(getStorage.read('student')));

  student.level =   newStudent.level;
  student.semester = newStudent.semester;

    await getStorage.write('student', json.encode(student.toJson()));

}

Student getUser(){
  var student = Student.fromJson(json.decode(getStorage.read('student')));

    return student;
}
}