

import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/model/semester.dart';
import 'package:student_side/model/teacher.dart';

class ClassSubject {
  String id;
  String name;
  Department department;
  Level level;
  String  teacher_id;
  Semester semester;

  ClassSubject(this.id, this.name, this.department, this.level, this.teacher_id,
      this.semester);

  ClassSubject.fromJson(Map<dynamic, dynamic> data) {
    this.id = data['id'].toString();
    this.name = data['name'];
    this.department = Department.fromJson(data['dept']);
    this.level = Level.fromJson(data['level']);
    this.teacher_id = data['teacher_id'] ;
    this.semester = Semester.fromJson(data['semester']);
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'department': this.department.toJson(),
      'level': this.level.toJson(),
      'teacher_id': this.teacher_id,
      'semester': this.semester.toJson()
    };
  }
}
