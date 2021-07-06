import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/ui/views/open_image.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/days.dart';
import 'package:student_side/util/fcm_init.dart';
import 'package:student_side/util/ui/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LectureDisscusion extends StatefulWidget {
  final Map data;
  LectureDisscusion(this.data);

  @override
  _LectureDisscusionState createState() => _LectureDisscusionState();
}

class _LectureDisscusionState extends State<LectureDisscusion> {
  CollectionReference comments =
      FirebaseFirestore.instance.collection('comments');

  TextEditingController commentController = new TextEditingController();
  bool _permissionReady;

  @override
  void initState() {
    super.initState();
    _permissionReady = false;
    _prepareSaveDir();
  }

  String _localPath;
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }

  _checkPermission() async {
    final status = await Permission.storage.status;
    bool granted;
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        granted = true;
      } else {
        granted = false;
      }
    } else {
      granted = true;
    }

    return granted;
  }

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('lecture Q & A  '),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Container(
                width: double.infinity,
                height: 250.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text('${widget.data['name']}'),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: widget.data['files'].length > 0
                            ? Container(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.data['files'].length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var file = widget.data['files'][index];

                                    if (file.endsWith("jpg") ||
                                        file.endsWith("jpeg") ||
                                        file.endsWith("png")) {
                                      return Container(
                                        margin: EdgeInsets.all(8.0),
                                        width: 100,
                                        height: 200,
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.to(OpenImage(url: file));
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                color: Colors.amber,
                                                child: Center(
                                                    child:
                                                        Text("معاينة الملف")),
                                              ),
                                            ),
                                            Expanded(
                                                child: Image.network(
                                              file,
                                              fit: BoxFit.cover,
                                            )),
                                            InkWell(
                                              onTap: () {
                                                _requestDownload(file);
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                color: AppColors.greenColor,
                                                child: Center(
                                                    child: Text("تحميل الملف" ,        style: TextStyle(
                                                            color:
                                                                Colors.white))),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }

                                    return Container(
                                      margin: EdgeInsets.all(8.0),
                                      width: 100,
                                      height: 200,
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              if (await canLaunch(file)) {
                                                await launch(file);
                                              } else {
                                                throw 'Unable to open url : $file';
                                              }
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.amber,
                                              child: Center(
                                                  child: Text("معاينة الملف")),
                                            ),
                                          ),
                                          Expanded(
                                              child: Text(getFileType(file))),
                                          InkWell(

                                          onTap: (){
                                          
                                                                                        _requestDownload(file);

                                          },
                                            child: Container(
                                              width: double.infinity,
                                              color: AppColors.greenColor,
                                              child: Center(
                                                  child: Text("تحميل الملف" ,  style: TextStyle(color: Colors.white), )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Text('no document with this lecture'))
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text('التعليقات...', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10.0),
            Container(
              height: MediaQuery.of(context).size.height * 2 / 3,
              child: FutureBuilder<QuerySnapshot>(
                future: comments
                    .where('object_id', isEqualTo: widget.data['id'])
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data.docs[index].data()
                          as Map<String, dynamic>;
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.all(Radius.circular(20.0)),
    color: Colors.green[300].withOpacity(0.5)                            
                            
                            ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(data["commentator"]['name']),
                              subtitle: Text(data['commentator']['role']),
                            ),
                            Text(
                              data['comment_text'],
                              maxLines: 20,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            // Text(snapshot.data.docs[index].data()['time'].toString()),
                            dateFormatWidget(data['time'])
                          ],
                        ),
                      );
                      return Text(snapshot.data.docs[index].data().toString());
                    },
                  );
                },
              ),
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: TextField(
            controller: commentController,
            decoration: InputDecoration(
                icon: IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () async {
                      var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
                      await comments.add({
                        'id': uuid.v1(),
                        'object_id': widget.data['id'],
                        'comment_text': commentController.text,
                        'time': Timestamp.now(),
                        'commentator': <dynamic, dynamic>{
                          'id': userProvider.getUser().id_number,
                          'name': userProvider.getUser().name,
                          'role': 'طالب'
                        }
                      });

                      commentController.text = '';

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
                                  'تم االتعليق علي المحاضرة  من قبل الطالب  ${userProvider.getUser().name}',
                              'title': ':تم إضافة تعليق'
                            },
                            'priority': 'high',
                            'data': <String, dynamic>{
                              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                              'id': '1',
                              'status': 'done',
                              'screen': 'consults',
                              'data': <String, dynamic>{
"type":"lecture_comment" ,

"id" :widget.data['id']
                              }
                            },
                            'to':
                                '/topics/teacher${widget.data['subject']['teacher_id']}'
                          },
                        ),
                      );
FCMConfig.subscripeToTopic("event"+widget.data['id']);

                      debugPrint(response.body);
                    }),
                hintText: 'comment...'),
          ),
        ));
  }

  String getDayText(int nowDay, int day) {
    if (nowDay == day) {
      return 'اليوم';
    } else if (nowDay - day == 1) {
      return 'الأمس';
    } else {
      return Days.values[day - 1].toString();
    }
  }

  String getFileType(String url) {
    String fileType = url.split('.').last.toLowerCase();

    return fileType;
  }

  Widget dateFormatWidget(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    // var now = DateTime.now();
    // var nowDay = now.weekday;
    // var day = date.weekday;

    var format = new DateFormat('d MMM, hh:mm a');
    // var date = new DateTime.fromMillisecondsSinceEpoch(t);
    var formattedDate = DateFormat.yMMMd().format(date); // Apr 8, 2020

    var now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var formattedToday = DateFormat.yMMMd().format(today);

    final yesterday = DateTime(now.year, now.month, now.day - 1);
    var formattedYesterDay = DateFormat.yMMMd().format(yesterday);

    String time = '';

    if (formattedDate == formattedToday) {
      time = "اليوم";
    } else if (formattedDate == formattedYesterDay) {
      time = "الأمس";
    } else {
      time = formattedDate;
    }

    return Container(
      child: Text(time),
    );
    // print(day);
    // print(Days.values[Days.values[day].index]   );
    // return Container(
    //   child: Text(getDayText(nowDay, day)),
    // );
  }

  void _requestDownload(String link) async {
    var result = await _checkPermission();
    if (result != null && result) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      final taskId = await FlutterDownloader.enqueue(
          url: link,
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification: true,
          savedDir: _localPath,
          fileName: DateTime.now()
              .toString() // click on notification to open downloaded file (for Android)
          );
    }
  }
}
