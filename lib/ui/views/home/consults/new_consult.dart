import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/model/student.dart';
import 'package:student_side/util/backendless_setup.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/fcm_init.dart';
import 'package:student_side/util/firebase_init.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class NewConsult extends StatefulWidget {
  NewConsult({Key key}) : super(key: key);

  @override
  _NewConsultState createState() => _NewConsultState();
}

class _NewConsultState extends State<NewConsult> {
  List<Level> levels = [];
  List<Department> depts = [];

  Department dept;
  Level level;
  TextEditingController controller = new TextEditingController();

  fetch_levels() async {
    var future = await showLoadingDialog();

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

    future.dismiss();
  }

  @override
  void initState() {
    super.initState();

    FirebaseInit.initFirebase();

    fetch_student();
  }

  fetch_student() {
    var data = getStorage.read('student');

    var student = Student.fromJson(json.decode(data));

    setState(() {
      this.dept = student.department;
      this.level = student.level;
    });
  }

  getDepts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var level = firestore.collection('depts');

    var departs = await level.get();
    print('////////////////////////////////////');

    Iterable I = departs.docs;

    setState(() {
      depts = I.map((e) => Department.fromJson(e.data())).toList();
    });
    print(departs.runtimeType);

    for (var item in departs.docs) {
      print(item.data());
    }
  }

  @override
  Widget build(BuildContext context) {
    var studentProvider = Provider.of<UserProvider>(context);
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
          Container(
              height: 30,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    'استفسار جديد',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),  

            Container(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: controller,

               decoration: InputDecoration(
                  border: OutlineInputBorder(),
                 
                ),

                minLines:
                    6, // any number you need (It works as the rows for the textarea)

                keyboardType: TextInputType.multiline,

                maxLines: 20,
              ),
            ),

            
            // SizedBox(height: 50.0),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                      onPressed: () async {
                        CollectionReference consult =
                            FirebaseFirestore.instance.collection('consults');
                        var future = await showLoadingDialog();
                        var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
                        DocumentReference data = await consult.add({
                          'id': uuid.v1(),
                          'student':
                              studentProvider.getUser().toJson(), // John Doe
                          'dept': studentProvider
                              .getUser()
                              .department
                              .toJson(), // Stokes and Sons
                          'level':
                              studentProvider.getUser().level.toJson(), // 42 ,
                          "consult": controller.text,
                          "time": DateTime.now().millisecondsSinceEpoch
                        });

                        var firebase_data = await data.get();
                        FCMConfig.subscripeToTopic(
                            'consult' + firebase_data.data()['id']);
                        debugPrint('consult' + firebase_data.data()['id']);

                        future.dismiss();

                        Get.back();
                      },
                      child: Text('نشر' , style: TextStyle(fontWeight: FontWeight.bold),),
                      color: Color.fromARGB(255, 93, 43, 255),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // side: BorderSide(color: Colors.red)
                          )
                          
                          ),



                               MaterialButton(
                      onPressed: () async {
                                           Get.back();
                      },
                      child: Text(
                        'إلغاء',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      color: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // side: BorderSide(color: Colors.red)
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  publishPost(BuildContext context) async {
    var studentProvider = Provider.of<UserProvider>(context);

    CollectionReference consult =
        FirebaseFirestore.instance.collection('consults');
    var future = await showLoadingDialog();
    var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
    DocumentReference data = await consult.add({
      'id': uuid.v1(),
      'student': studentProvider.getUser().toJson(), // John Doe
      'dept': studentProvider.getUser().department.toJson(), // Stokes and Sons
      'level': studentProvider.getUser().level.toJson(), // 42 ,
      "consult": controller.text
    });

    var firebase_data = await data.get();
    FCMConfig.subscripeToTopic('consult' + firebase_data.data()['id']);
    debugPrint('consult' + firebase_data.data()['id']);

    debugPrint('sending .......');

    var response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body':
                'تم اضافة سؤال او استفسار جديد من قبل الطالب  ${studentProvider.getUser().name}',
            'title': ':هوي'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'screen': 'consults',
          },
          'to':
              '/topics/${studentProvider.getUser().department.dept_code}${studentProvider.getUser().level.id.toString()}'
        },
      ),
    );

    debugPrint(response.body);

    future.dismiss();

    Get.back();
  }
}
