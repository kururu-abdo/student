import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/days.dart';
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
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('lecture Q & A  '),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
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
                                    return Container(
                                      height: 80,
                                      width: 80,
                                      child: Card(
                                          child: Column(
                                        children: [
                                          Text('file ${index + 1}'),
                                          IconButton(
                                              icon:
                                                  Icon(Icons.download_rounded),
                                              onPressed: () {})
                                        ],
                                      )),
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
            Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(blurRadius: 2.0, color: Colors.black38)
                ]),
                child: Text('التعليقات...')),
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
                      var data =  snapshot.data.docs[index]
                                  .data() as Map<String  , dynamic>;
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            color: Colors.blue[300]),
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
                            dateFormatWidget(
                               data['time'])
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
                              'data': widget.data
                            },
                            'to':
                                '/topics/teacher${widget.data['subject']['teacher_id']}'
                          },
                        ),
                      );

                      debugPrint(response.body);
                    }),
                hintText: 'comment...'),
          ),
        ));
  }

  Widget dateFormatWidget(Timestamp time) {
    DateTime date = time.toDate();
    var now = DateTime.now();
    var nowDay = now.weekday;
    var day = date.weekday;

    print(day);
    print(Days.values[Days.values[day].index]);
    return Container(
      child: Text(getDayText(nowDay, day)),
    );
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
}
