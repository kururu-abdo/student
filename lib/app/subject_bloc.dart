import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_side/model/student.dart';
import 'package:student_side/model/subject.dart';


class SubjectProvider {
  Stream<List<ClassSubject>> getMySubjects(Student student) async* {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('subject')
        .where('dept' , isEqualTo: student.department.toJson())
        .where('level' , isEqualTo: student.level.toJson())
        .where('semester', isEqualTo: student.semester.toJson())
        .get();
    List<ClassSubject> subjects =
        data.docs.map((e) => ClassSubject.fromJson(e.data())).toList();

    subjects.forEach((element) {
      print(element.name);
    });

    yield subjects;
  }


 Future<List<ClassSubject>> get2subjects(Student student) async{
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('subject')
        .where('dept', isEqualTo: student.department.toJson())
        .where('level', isEqualTo: student.level.toJson())
        .where('semester', isEqualTo: student.semester.toJson())
        .limit(2)
        .get();
    List<ClassSubject> subjects  =[];
    
    
if (data.docs.length>0) {
    subjects=      data.docs.map((e) => ClassSubject.fromJson(e.data())).toList();

}
    subjects.forEach((element) {
      print(element.name);
    });

    return  subjects;
  }


}
