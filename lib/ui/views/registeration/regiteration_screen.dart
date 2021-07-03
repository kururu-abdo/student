import 'dart:convert';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:load/load.dart';

import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/model/semester.dart';
import 'package:student_side/model/student.dart';
import 'package:student_side/ui/views/home/home_screen.dart';
import 'package:student_side/util/backendless_setup.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/firebase_init.dart';
import 'package:student_side/util/ui/app_colors.dart';
import 'package:tinycolor/tinycolor.dart';
import 'registeration_view_model.dart';

class RegisterationView extends StatefulWidget {
  static const String _title = 'Registration Page';
  @override
  _State createState() => _State();
}

class _State extends State<RegisterationView> {
  int selectedGender = 0;
  void _handleRadioValueChange1(int value) =>
      setState(() => selectedGender = value);

  List<Department> depts = [];

  List<Level> levels = [];

  Department dept;
  Level level;
  String profile_image;

  String password;
  List<Semester> semesters = [];
  Semester semester;
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

  fetch_depts() async {

    Backendless.data.of("department").find().then((department) {
      print(department);
      Iterable I = department;
      setState(() {
        depts = I.map((dept) => Department.fromJson(dept)).toList();
      });
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

    BackendlessServer();
    FirebaseInit.initFirebase();
   
//fetch_depts();
    getDepts();

     fetch_levels();
    fetch_semesters();
  }

  getDepts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var level = firestore.collection('depts');

    var departs = await level.get();
    print('////////////////////////////////////');

    Iterable I = departs.docs;

    setState(() {
      // depts= I.map((dept) =>

      //  Department.fromJson(dept)).toList();
      depts = I.map((e) => Department.fromJson(e.data())).toList();
    });
    print(departs.runtimeType);

    for (var item in departs.docs) {
      print(item.data());
    }
  }

  GlobalKey _state = new GlobalKey<ScaffoldState>();

  String profile;
  String first_name;
  String last_name;
  String id_number;

  bool _progressLevel = false;
  int _level = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<RegistertionFormBloc>(
        create: (context) => RegistertionFormBloc(),
        child: Builder(builder: (context) {
          final formBloc = BlocProvider.of<RegistertionFormBloc>(context);

          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.primaryColor,
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FormBlocListener<RegistertionFormBloc, String, String>(
                      child: Column(children: [
                        Container(
                            height: 50,
                            width: double.infinity,
                            child: Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                OutlineButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'تسجيل الدخول',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.nameField,
                          obscureText: true,
                          onChanged: (str) => this.first_name = str,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: "ألاسم",
                              prefixIcon: Icon(FontAwesomeIcons.user)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.passwordField,
                          obscureText: true,
                          onChanged: (str) => this.password = str,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: "كلمة السر",
                              prefixIcon: Icon(Icons.lock)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.idNumberField,
                          onChanged: (str) => this.id_number = str,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: "ID Number الرقم الجامعي",
                              prefixIcon: Icon(FontAwesomeIcons.university)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('التخصص'),
                                    Container(),
                                    new DropdownButton<Department>(
                                      value: dept,
                                      items: depts.map((dept) {
                                        return DropdownMenuItem<Department>(
                                          value: dept,
                                          child: Text(dept.name),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          dept = newValue;
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                          height: 10,
                        ),
                        MaterialButton(
                          minWidth: 200,
                          height: 60,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(50),
                                  right: Radius.circular(50))),
                          color: AppColors.greenColor,
                          onPressed: () async {
                            final valid = await usernameCheck();
                            if (!valid) {
                              Fluttertoast.showToast(
                                  msg:
                                      "في طالب تاني مسجل بي نفس الرقم الجامعي ده ^_^",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              await addStudent();
                            }
                          },
                          child: Center(
                            child: Text(
                              "تسجيل",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  addStudent() async {
    var future = await showLoadingDialog();
    CollectionReference student =
        FirebaseFirestore.instance.collection('student');

    if (this.semester != null && this.level != null && this.dept != null) {
      student.doc(this.id_number).set({
        'name': this.first_name, // John Doe
        'dept': this.dept.toJson(), // Stokes and Sons
        'level': this.level.toJson(),
        'semester': this.semester.toJson(),
        "password": this.password,
        "id_number": this.id_number,

        // 42
      }).then((value) {
        future.dismiss();
        getStorage.write('islogged', true).then((value) => print(''));
        getStorage
            .write(
                'student',
                json.encode(Student(
                        this.first_name,
                        this.id_number,
                        this.password,
                        this.dept,
                        this.level,
                        this.profile_image ?? '',
                        this.semester)
                    .toJson()))
            .then((value) => print(''));

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => HomeView()));
      }).catchError((error) => print("Failed to add user: $error"));
    } else {
      Fluttertoast.showToast(
          msg: "قم بملء كل الحقول",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<bool> usernameCheck() async {
    final result = await FirebaseFirestore.instance
        .collection('student')
        .where('id_number', isEqualTo: this.id_number)
        .get();
    return result.docs.isEmpty;
  }
}
