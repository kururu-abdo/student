import 'dart:convert';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:load/load.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/semester.dart';
import 'package:student_side/model/student.dart';
import 'package:student_side/ui/views/edit_profile.dart';
import 'package:student_side/ui/views/home/home_screen.dart';
import 'package:student_side/util/firebase_init.dart';

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

  fetch_semesters() async {
    var future = await showLoadingDialog();

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

    future.dismiss();
  }

  @override
  void initState() {
    super.initState();

    FirebaseInit.initFirebase();

    semester = widget.student.semester;

    fetch_semesters();
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
