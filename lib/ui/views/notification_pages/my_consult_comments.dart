import 'dart:convert';
import 'package:flutter_show_more/flutter_show_more.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:load/load.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/consult.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/days.dart';
import 'package:provider/provider.dart';
import 'package:student_side/util/ui/app_colors.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class MyConsultComments extends StatefulWidget {
  final String  consult_id;

  const MyConsultComments({Key key, this.consult_id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<MyConsultComments> {
  static const String id = '/myconsultcomments';
  TextEditingController commentController = new TextEditingController();
Consult consult;

@override
void initState() { 
  super.initState();
  Future.microtask(()async {
var data =await FirebaseFirestore.instance.collection("consults")
.where("id" ,  isEqualTo:widget.consult_id)
.get();

if(data.docs.length>0){
setState(() {
  consult =   Consult.fromJson(data.docs.first.data());
});
}

  });
}


  @override
  Widget build(BuildContext context) {
    CollectionReference comments =
        FirebaseFirestore.instance.collection('comments');
    var userProvider = Provider.of<UserProvider>(context);
    final String  consultId = ModalRoute.of(context).settings.arguments;

    return SafeArea(
        child: Scaffold(




            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    Get.back();
                  }),
              title: Text(
                'التعليقات',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: AppColors.primaryColor,
            ),
            body: Container(
              height: double.infinity,
              child: ListView(
                children: [
                consult!= null?
Container(height: 300,
child: Card(
  elevation: 8.0, 

  child: Column(
    children: [
      Text(consult.student.name) ,
      Divider() ,
      
    ],
  ),
),
) : Center(child: Text("هذا المنشور غير متوفر"),)  ,
                  SizedBox(height: 10.0),
                      
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: FutureBuilder<QuerySnapshot>(
                      future: comments
                          .where('object_id', isEqualTo: consultId)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                color: AppColors.primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), //color of shadow
                                    spreadRadius: 5, //spread radius
                                    blurRadius: 7, // blur radius
                                    offset: Offset(
                                        0, 2), // changes position of shadow
                                    //first paramerter of offset is left-right
                                    //second parameter is top to down
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                // color: Color.fromARGB(250,192, 192, 192) ,

                                // gradient: LinearGradient(colors: [
                                //   Color.fromARGB(250, 132, 132, 132),
                                //   Color.fromARGB(250, 192, 192, 192)
                                // ])
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading:
                                        Image.asset('assets/images/user.jpg'),
                                    title: Text(data['commentator']['name']),
                                    subtitle: Text(data['commentator']['role']),
                                    trailing: dateFormatWidget(data['time']),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: ShowMoreText(
                                      data['comment_text'] ?? '',
                                      maxLength: 100,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                      showMoreText: 'عرض اكثر',
                                      showMoreStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.greenColor,
                                      ),
                                      shouldShowLessText: true,
                                      showLessText: ' عرض اقل',
                                    )

                                        //    Text(
                                        //  data['comment_text'],
                                        //     maxLines: 20,
                                        //   ),
                                        ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                    icon: IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () async {
                          var uuid =
                              Uuid(options: {'grng': UuidUtil.cryptoRNG});
                          await comments.add({
                            'id': uuid.v1(),
                            'object_id': consultId,
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
                                      'تتم الرد علي أستفسار من قبل   $userProvider.getUser().name}',
                                  'title': ':هنالك رد علي إستفسارك'
                                },
                                'priority': 'high',
                                'data': <String, dynamic>{
                                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                  'id': '1',
                                  'status': 'done',
                                  'screen': 'consults',
                                 
                                    "type": "consult_comment",
                                    "consult_id": consultId
                                  
                                },
                                'to': '/topics/consult${consultId}'
                              },
                            ),
                          );

                          debugPrint(response.body);

                          print('comment');
                        }),
                    hintText: 'comment...'),
              ),
            )));
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

  String getDayText(int nowDay, int day) {
//  var format = new DateFormat('d MMM, hh:mm a');
//     var date = new DateTime.fromMillisecondsSinceEpoch(t);
//     var formattedDate = DateFormat.yMMMd().format(date); // Apr 8, 2020

//     var now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     var formattedToday = DateFormat.yMMMd().format(today);

//     final yesterday = DateTime(now.year, now.month, now.day - 1);
//     var formattedYesterDay = DateFormat.yMMMd().format(yesterday);

//     String time = '';

//     if (formattedDate == formattedToday) {
//       time = "اليوم";
//     } else if (formattedDate == formattedYesterDay) {
//       time = "الأمس";
//     } else {
//       time = formattedDate;
//     }

//     return time;

    if (nowDay == day) {
      return 'اليوم';
    } else if (nowDay - day == 1) {
      return 'الأمس';
    } else {
      return Days.values[day - 1].toString();
    }
  }
}
