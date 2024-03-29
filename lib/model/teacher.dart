import 'package:flutter/material.dart';
import 'package:student_side/model/semester.dart';


class Teacher {
  String id;
  String name;
  String phone;
  String password;
  String address;
  Semester semester;

  Teacher(this.id, this.name, this.address, this.password, this.phone,
      this.semester);

  Teacher.fromJson(Map<dynamic, dynamic> data) {
    this.id = data['id'].toString();
    this.name = data['name'];
    this.phone = data['phone'];
    this.address = data['address'];
    this.password = data['password'];
//debugPrint(data['semester']);
    this.semester = Semester.fromJson(data['semester']);
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'phone': this.phone,
      'address': this.address,
      'password': this.password,
      'semester': this.semester.toJson()
    };
  }
}
