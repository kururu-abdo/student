import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:student_side/app/services_provider.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/model/semester.dart';
import 'package:student_side/ui/views/widgets/loader.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<Semester> semesters = [];
  Semester semester;

  List<Level> levels = [];
  Level level;

  var _formKey = GlobalKey<FormState>();
  fetch_semeters() async {
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection('semester').get();

    setState(() {
      semesters = data.docs.map((e) => Semester.fromJson(e.data())).toList();
    });
  }

  fetch_levels() async {
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection('level').get();

    setState(() {
      levels = data.docs.map((e) => Level.fromJson(e.data())).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetch_semeters();
    fetch_levels();
  }

  @override
  Widget build(BuildContext context) {
    var studentProvider = Provider.of<UserProvider>(context);
    var serviceProvider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(FontAwesomeIcons.user),
              onPressed: () {
                Get.back();
              }),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
        centerTitle: true,
        title: Text(' تعديل الملف الشخصي '),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[300],
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(children: [
                      Text('السمستر'),
                      Container(),
                      new DropdownButton<Semester>(
                        value: semester,
                        items: semesters.map((sem) {
                          return DropdownMenuItem<Semester>(
                            value: sem,
                            child: Text(sem.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            semester = newValue;
                          });
                        },
                      )
                    ])),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[300],
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(children: [
                      Text('المستوى'),
                      Container(),
                      new DropdownButton<Level>(
                        value: level,
                        items: levels.map((lev) {
                          return DropdownMenuItem<Level>(
                            value: lev,
                            child: Text(lev.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            level = newValue;
                          });
                        },
                      )
                    ])),
              ),
              Center(
                child: new Container(
                    width: 200,
                    // padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                    child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Text('تحديث'),
                        onPressed: () async {
                          if (await serviceProvider.checkInternet()) {
                           LoadingDialog.show(context);
                            var student = studentProvider.getUser();

                            student.semester = this.semester != null
                                ? this.semester
                                : student.semester;
                            student.level =
                                this.level != null ? this.level : student.level;

                            CollectionReference teachers = FirebaseFirestore
                                .instance
                                .collection('student');
                            // .where('id' , isEqualTo:teacher.id)
                            // .get()
                            // ;
                            QuerySnapshot current_teacer = await teachers
                                .where('id_number',
                                    isEqualTo: student.id_number)
                                .get();

                            print(current_teacer.docs.toString());

                            var doc_id = current_teacer.docs.first.id;

                            teachers.doc(doc_id).update({
                              'semester': student.semester.toJson(),
                              'level': student.level.toJson()
                            });

                            await studentProvider.updateStudent(student);

                            Fluttertoast.showToast(
                                msg: "تحديث البيانات بنجاح ^_^",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);

                                                    LoadingDialog.hide(context);

                          } else {
                            Fluttertoast.showToast(
                                msg: "تأكد من أتصالك بالانترنت ^_^",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
