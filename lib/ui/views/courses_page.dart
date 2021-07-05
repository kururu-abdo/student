import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:build_daemon/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_side/app/subject_bloc.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/student.dart';
import 'package:provider/provider.dart';
import 'package:student_side/model/subject.dart';
import 'package:student_side/model/teacher.dart';
import 'package:student_side/ui/views/subject_details.dart';
import '../../util/constants.dart';
import '../../util/constants.dart';

class MyCourses extends StatefulWidget {
  final Student student;

  ///TODO: map of event
  MyCourses(this.student);
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<MyCourses> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var subjectProvider = Provider.of<SubjectProvider>(context);
    var studentProvider = Provider.of<UserProvider>(context);

    return SafeArea(
        child: Material(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Container(
                height: 80.0,
                decoration: BoxDecoration(
                    color: Colors.blue[500],
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Get.back();
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'كورسات السمستر',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 90,
              child: StreamBuilder<List<ClassSubject>>(
                stream:
                    subjectProvider.getMySubjects(studentProvider.getUser()),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ClassSubject>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('snapshot.'),
                    );
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 8.0,
                    children: snapshot.data
                        .map((subject) => OpenContainer(
                            openColor: Colors.pink,
                            transitionDuration: Duration(milliseconds: 750),
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedBuilder: (context, action) {
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.elliptical(20, 20))),
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          'assets/images/sub1.png',
                                          height: constraints.maxHeight - 90,
                                          fit: BoxFit.cover,
                                        ),
                                        Column(
                                          children: [
                                            Text(subject.name),

                                            FutureBuilder<Teacher>(
                                              future: getTeacher(
                                                  subject.teacher_id),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                return Text('الاستاذ' +
                                                    ':  ' +
                                                    snapshot.data.name);
                                              },
                                            ),
                                         Divider()  ,

                                     Text("0 محاضرة")     //
                                          ],
                                        )
                                     
                                     
                                  
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                            openBuilder: (context, action) {
                              return SubjectDetails(subject);
                            }))
                        .toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    ));
  }

  Future<Teacher> getTeacher(String teacher_id) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('teacher')
        .where('id', isEqualTo: teacher_id)
        .get();
    Teacher teacher = Teacher.fromJson(data.docs.first.data());

    return teacher;
  }
}
