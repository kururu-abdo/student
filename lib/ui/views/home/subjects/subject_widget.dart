import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:student_side/app/subject_bloc.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/student.dart';
import 'package:student_side/model/subject.dart';
import 'package:student_side/model/teacher.dart';
import 'package:student_side/ui/views/subject_details.dart';
import 'package:student_side/util/ui/app_colors.dart';
import 'package:student_side/util/ui/type_ahead.dart';
import 'package:provider/provider.dart';

class Subjects extends StatefulWidget {
  final Student student;
  Subjects({Key key, this.student}) : super(key: key);

  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  bool isSearch = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var subjectProvider = Provider.of<SubjectProvider>(context);
    var studentProvider = Provider.of<UserProvider>(context);
// CollectionReference subjects = FirebaseFirestore.instance
//         .collection('subjects')
//         .where('dept', isEqualTo: widget.student.department.id ?? 1)
//         .where('level', isEqualTo: widget.student.level.id ?? 1);

    return Scaffold(
      appBar: new AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: AppColors.primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title:
        
       Text ("المواد")
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),

        child: Container(
          height: double.infinity,
          child: StreamBuilder<List<ClassSubject>>(
            stream: subjectProvider.getMySubjects(studentProvider.getUser()),
            builder: (BuildContext context,
                AsyncSnapshot<List<ClassSubject>> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return new ListView(
                children: snapshot.data.map((subject) {
                  //  return   ConsultCard(consult:document.data());

                  return Container(
                    margin: EdgeInsets.all(15),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      color: getRandomColor(),
                      borderRadius:
                          BorderRadius.circular(10), //border corner radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), //color of shadow
                          spreadRadius: 5, //spread radius
                          blurRadius: 7, // blur radius
                          offset: Offset(0, 2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                    child: ListTile(
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(builder: (_){
return SubjectDetails(subject);
                      }));
                    },
                        title: Text(
                          subject.name,
                          style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white),
                        ),
                        subtitle: FutureBuilder<Teacher>(
                          future: getTeacher(subject.teacher_id),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Text('الاستاذ' + ':  ' + snapshot.data.name , style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            );
                          },
                        ),
                        leading: Image.asset('assets/images/diary.png')),
                  );

                  return Text(
                    subject.name,
                    maxLines: 16,
                  );

                  // new ListTile(

                  //   title: new Text(document.data()['full_name']),

                  //   subtitle: new Text(document.data()['company']),

                  // );
                }).toList(),
              );
            },
          ),
        ),
//     child: ListView(
//       children: [
// Text('المواد' ,  style: Theme.of(context).textTheme.headline5,)  ,

// SizedBox(height: 10.0,) ,

// Container(
//   height: MediaQuery.of(context).size.height,
// color: AppColors.primaryColor,
//   child:ListView.builder(
//     itemCount: 20,
//     itemBuilder: (BuildContext context, int index) {
//     return
//
// Container(
//         margin: EdgeInsets.all(15),
//         height: 70,
//    decoration: BoxDecoration(
//             color: Colors.white,
//              borderRadius: BorderRadius.circular(10), //border corner radius
//              boxShadow:[
//                BoxShadow(
//                   color: Colors.grey.withOpacity(0.5), //color of shadow
//                   spreadRadius: 5, //spread radius
//                   blurRadius: 7, // blur radius
//                   offset: Offset(0, 2), // changes position of shadow
//                   //first paramerter of offset is left-right
//                   //second parameter is top to down
//                ),
//                //you can set more BoxShadow() here
//               ],
//           ),
//       child: ListTile(title: Text('lkfldfdl'),

//       leading:Image.asset('assets/images/diary.png')),) ;
//    },
//   ),
      ),
    );
  }

  Future<Teacher> getTeacher(String teacher_id) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('teacher')
        .where('id', isEqualTo: teacher_id)
        .get();
    Teacher teacher = Teacher.fromJson(data.docs.first.data());

    return teacher;
  }
  List<Color> colors =[Color.fromARGB(255, 76, 102, 213)  , Color.fromARGB(255, 55, 61, 66)  ,
    Color.fromARGB(255, 255, 60, 73) ];

    Color getRandomColor(){
      Random rnd = new Random();
// Define min and max value
    int min = 0, max = 2;
    int num = min + rnd.nextInt(max - min);
    return colors[num];
    }
}
