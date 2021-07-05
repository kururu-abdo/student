import 'dart:convert';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:load/load.dart';
import 'package:student_side/app/services_provider.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/model/semester.dart';
import 'package:student_side/model/student.dart';
import 'package:student_side/ui/views/edit_profile.dart';
import 'package:student_side/ui/views/home/home_screen.dart';
import 'package:student_side/ui/views/widgets/loader.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/fancy_toast.dart';
import 'package:student_side/util/fcm_init.dart';
import 'package:student_side/util/firebase_init.dart';
import 'package:student_side/util/ui/app_colors.dart';

class MyPrpfole extends StatefulWidget {
  final Student student;
  MyPrpfole(this.student);

  @override
  _MyPrpfoleState createState() => _MyPrpfoleState();
}

class _MyPrpfoleState extends State<MyPrpfole> {
  TextEditingController idController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  Semester semester;
  List<Semester> semesters = [];

  fetch_semesters(BuildContext context) async {
    LoadingDialog.show(context);

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var level = firestore.collection('semester');

    var fetchedSemester = await level.get();

    Iterable I = fetchedSemester.docs;

    setState(() {
      semesters = I.map((e) => Semester.fromJson(e.data())).toList();
    });
    for (var item in semesters) {
      print(item.toJson());
    }

    LoadingDialog.hide(context);
  }

  @override
  void initState() {
    super.initState();

    FirebaseInit.initFirebase();

    semester = widget.student.semester;

    fetch_semesters(context);
  }

  @override
  Widget build(BuildContext context) {
    var studentProvider = Provider.of<UserProvider>(context);
    Query students = FirebaseFirestore.instance
        .collection('student')
        .where('id_number', isEqualTo: widget.student.id_number);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(FontAwesomeIcons.edit),
              onPressed: () {
                Get.to(EditProfile());
              }),
          IconButton(
              icon: Icon(FontAwesomeIcons.home),
              onPressed: () {
                Get.back();
              }),
        ],
        title: Text('الملف الشخصي'),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: students.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            debugPrint(snapshot.data.size.toString());
            Map<String, dynamic> data = snapshot.data.docs.first.data();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.redAccent, Colors.pinkAccent])),
                      child: Container(
                        width: double.infinity,
                        height: 350.0,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                                ),
                                radius: 50.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "${data['name']}",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.white,
                                elevation: 5.0,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 22.0),
                                    child: Center(
                                      child: Text(
                                        "${data['role']}",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      )),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "البيانات الشخصية:",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontStyle: FontStyle.normal,
                                fontSize: 28.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Form(
                                child: Column(
                              children: [
                                Center(
                                    child: ListTile(
                                  title: Text('${data['id_number']}'),
                                  trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () async {
                                        await editPhone(context);
                                      }),
                                )),
                                Center(
                                    child: ListTile(
                                  title: Text('${data['semester']['name']}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      await editAddres(context);
                                    },
                                  ),
                                )),
                              ],
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  editPhone(BuildContext context) async {
    var studentProvider = Provider.of<UserProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('تعديل الرقم الجامعي'),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {},
              controller: idController,
              decoration: InputDecoration(hintText: "الرقم الجامعي"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('cancel'),
                onPressed: () {
                  setState(() {
                    //  codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async {
                  CollectionReference students =
                      FirebaseFirestore.instance.collection('student');
                  // .where('id' , isEqualTo:teacher.id)
                  // .get()
                  // ;
                  QuerySnapshot current_teacer = await students
                      .where('id_number', isEqualTo: widget.student.id_number)
                      .get();
                  print(widget.student.id_number);
                  print(current_teacer.docs.toString());

                  var doc_id = current_teacer.docs.first.id;

                  debugPrint(doc_id);
                  if (idController.text.length > 0) {
                    await students
                        .doc(doc_id)
                        .update({'id_number': '${idController.text}'});
                  }
                  await studentProvider.updateId(idController.text);

                  setState(() {
                    //  codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  editAddres(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Address'),
            content: TextField(
              keyboardType: TextInputType.phone,
              onChanged: (value) {},
              controller: addressController,
              decoration: InputDecoration(hintText: "new Address Name"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('cancel'),
                onPressed: () {
                  setState(() {
                    //  codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async {
                  await updateAddress();
                  setState(() {
                    //  codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  updatePhone(UserProvider provider) async {
    CollectionReference students =
        FirebaseFirestore.instance.collection('student');
    // .where('id' , isEqualTo:teacher.id)
    // .get()
    // ;
    QuerySnapshot current_teacer = await students
        .where('id_number', isEqualTo: widget.student.id_number)
        .get();
    print(widget.student.id_number);
    print(current_teacer.docs.toString());

    var doc_id = current_teacer.docs.first.id;

    debugPrint(doc_id);
    if (idController.text.length > 0) {
      await students.doc(doc_id).update({'id_number': '${idController.text}'});
    }
    provider.updateId(idController.text);
  }

  updateAddress() async {
    CollectionReference teachers =
        FirebaseFirestore.instance.collection('teacher');
    // .where('id' , isEqualTo:teacher.id)
    // .get()
    // ;
    QuerySnapshot current_teacer = await teachers
        .where('id', isEqualTo: int.parse(widget.student.id_number))
        .get();

    var doc_id = current_teacer.docs.first.id;

    if (idController.text.length > 0) {
      teachers
          .doc(doc_id)
          .update({'address': '${addressController.text}'})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var studentProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          title: Text(studentProvider.getUser().name), centerTitle: true),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new FloatingActionButton(
                elevation: 0.0,
                child: Icon(Icons.edit),
                onPressed: () {
                  Get.to(EditProfile());
                })
          ],
        ),
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    var studentProvider = Provider.of<UserProvider>(context, listen: false);

    return ListView(physics: BouncingScrollPhysics(), children: <Widget>[
      Container(
          padding: EdgeInsets.all(15),
          child: Column(children: <Widget>[_headerSignUp(), _formUI(context)]))
    ]);
  }

  _headerSignUp() {
    var studentProvider = Provider.of<UserProvider>(context, listen: false);

    return Column(children: <Widget>[
      Container(
          height: 80,
          child: Icon(Icons.person, color: AppColors.secondaryColor, size: 90)),
      SizedBox(height: 12.0),
      Text(studentProvider.getUser().name,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
              color: Colors.orange)),
    ]);
  }

  _formUI(BuildContext context) {
    var studentProvider = Provider.of<UserProvider>(context, listen: false);
    return new Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 12.0),
          _id_number(),
          SizedBox(height: 12.0),
          _dept(),
          SizedBox(height: 12.0),
          _level(),
          SizedBox(height: 12.0),
          _semester(),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }

  _dept() {
    var studentProvider = Provider.of<UserProvider>(context, listen: false);
    return Row(children: <Widget>[
      _prefixIcon(Icons.person),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('القسم',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  color: Colors.grey)),
          SizedBox(height: 1),
          Text(studentProvider.getUser().department.name)
        ],
      )
    ]);
  }

  _level() {
    var studentProvider = Provider.of<UserProvider>(context, listen: false);
    return Row(children: <Widget>[
      _prefixIcon(Icons.person),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('المستوى',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  color: Colors.grey)),
          SizedBox(height: 1),
          Text(studentProvider.getUser().level.name)
        ],
      )
    ]);
  }

  _semester() {
    var studentProvider = Provider.of<UserProvider>(context, listen: false);
    return Row(children: <Widget>[
      _prefixIcon(Icons.person),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('الفصل الدراسي',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  color: Colors.grey)),
          SizedBox(height: 1),
          Text(studentProvider.getUser().semester.name)
        ],
      )
    ]);
  }

  _prefixIcon(IconData iconData) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
      child: Container(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          margin: const EdgeInsets.only(right: 8.0),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(10.0))),
          child: Icon(
            iconData,
            size: 20,
            color: Colors.grey,
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _id_number() {
    var studentProvider = Provider.of<UserProvider>(context, listen: false);
    return Row(children: <Widget>[
      _prefixIcon(Icons.perm_identity),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('الرقم الجامعي',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  color: Colors.grey)),
          SizedBox(height: 1),
          Text(studentProvider.getUser().id_number)
        ],
      )
    ]);
  }
}

class EditProfile extends StatefulWidget {
  EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<Level> levels = [];
  List<Semester> semesters = [];
  Semester semester;
  Level level;
  fetch_semesters() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var sems = firestore.collection('semester');

    var fetchedLevel = await sems.get();

    Iterable I = fetchedLevel.docs;
    print(
        'dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');
    setState(() {
      semesters = I.map((e) => Semester.fromJson(e.data())).toList();
    });
  }

  fetch_levels() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var level = firestore.collection('level');

    var fetchedLevel = await level.get();

    Iterable I = fetchedLevel.docs;
    print(
        'dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');
    setState(() {
      levels = I.map((e) => Level.fromJson(e.data())).toList();
    });

    for (var item in fetchedLevel.docs) {
      print(item.data());
    }

//  Backendless.data.of("department").find().then((department) {
//     print(department);

// Iterable I = department;
// setState(() {
//   depts= I.map((dept) =>
//    Department.fromJson(dept)).toList();

// });

//   });
  }

  @override
  void initState() {
    super.initState();

    FirebaseInit.initFirebase();
    fetch_levels();
    fetch_semesters();
//fetch_depts();
  }

  subscribe(Student student) {
    // var data = getStorage.read('student');
    // var student = Student.fromJson(json.decode(data));

    FCMConfig.subscripeToTopic(
        "${student.department.dept_code}${student.level.id}");

    FCMConfig.subscripeToTopic("${student.department.dept_code}");

    FCMConfig.subscripeToTopic("student${student.id_number.toString()}");
    FCMConfig.subscripeToTopic("general");
  }

  String newName;

  unSubscrib() {
    var data = getStorage.read('student');
    var student = Student.fromJson(json.decode(data));

    FCMConfig.subscripeToTopic(
        "${student.department.dept_code}${student.level.id}");
    FCMConfig.subscripeToTopic("level${student.level.id.toString()}");
    FCMConfig.subscripeToTopic("${student.department.dept_code}");

    FCMConfig.subscripeToTopic("${student.id_number.toString()}");
    FCMConfig.subscripeToTopic("general");
  }

  @override
  Widget build(BuildContext context) {
    var studentProvider = Provider.of<UserProvider>(context, listen: false);
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              Get.to(HomeView());
            },
            icon: Icon(Icons.home))
      ], title: Text('تعديل الملف الشخصي'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(0.0),
            //height: MediaQuery.of(context).size.height,

            child: Form(
                child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'الاسم'),
                  onChanged: (str) {
                    setState(() {
                      newName = str;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('المستوى'),
                            Container(),
                            new DropdownButton<Level>(
                              value: level,
                              items: levels.map((level) {
                                return DropdownMenuItem<Level>(
                                  value: level,
                                  child: Text(level.name),
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
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('السمستر'),
                            Container(),
                            new DropdownButton<Semester>(
                              value: semester,
                              items: semesters.map((sem) {
                                return DropdownMenuItem<Semester>(
                                  value: sem,
                                  child: Text(sem.name),
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
                SizedBox(
                  height: 50.0,
                ),
                Spacer(),
                OutlinedButton.icon(
                  label: Text('حفظ البيانات'),
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    LoadingDialog.show(context);

                    //unsubscribe to old things

                    unSubscrib();

                    //update data

                    var data = getStorage.read('student');

                    var student = Student.fromJson(json.decode(data));

                    if (this.level != null) {
                      student.level = this.level;

                      serviceProvider.updateStudent(student).then((value) {
                        getStorage.write(
                            'student', json.encode(student.toJson()));
                      });

                      subscribe(student);
                    }

                    if (this.semester != null) {
                      student.semester = this.semester;

                      serviceProvider.updateStudent(student).then((value) {
                        getStorage.write(
                            'student', json.encode(student.toJson()));
                      });

                      subscribe(student);
                    }

                    if (this.newName.length > 0 || this.newName != "") {
                      student.name = this.newName;

                      serviceProvider.updateStudent(student).then((value) {
                        getStorage.write(
                            'student', json.encode(student.toJson()));

                        setState(() {});
                      });
                    }

                    //

                    LoadingDialog.hide(context);
                    AppToasts.showSuccessToast(
                        context, "تم تحديث البيانات بنجاح");

                    Get.back();
                  },
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
