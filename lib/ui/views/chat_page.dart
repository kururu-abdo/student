import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:student_side/model/chat_user.dart';
import 'package:student_side/util/constants.dart';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final User me;
  const ChatPage({Key key, this.user, this.me}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatPage> {
  TextEditingController _controller = new TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    CollectionReference chats =
        FirebaseFirestore.instance.collection('messages');

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  icon: Icon(FontAwesomeIcons.user),
                  onPressed: () {
                    Get.back();
                  })
            ],
            centerTitle: true,
            title: Text(widget.user.name+ "-"+" "+widget.user.role),
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('chat_id',
                      isEqualTo: widget.me.id.toString() + widget.user.id.toString())
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.docs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
var data =  snapshot.data.docs[index]
                                      .data()   as Map<String , dynamic>;

                      
                      return Align(
                          alignment: User.fromJson(data['receiver']) ==
                                  User.fromJson(widget.me.toJson())
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: User.fromJson(data['receiver']) ==
                                        User.fromJson(widget.me.toJson())
                                    ? Colors.grey
                                    : Colors.green[300].withOpacity(0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            margin: EdgeInsets.all(10.0),
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                data['message']),
                          ));
                    },
                  );
                }
              }),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  icon: IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () async {
                        var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
                        await chats.add({
                          'chat_id': widget.me.id.toString() +
                              widget.user.id.toString(),
                          'id': uuid.v1(),
                          'message': _controller.text,
                          'time': Timestamp.now(),
                          'sender': widget.me.toJson(),
                          'receiver': widget.user.toJson()
                        });
                        _controller.text = '';
                        print('comment');

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
                                    'الطالب   ارسل لك رسالة ${widget.me.name}',
                                'title': ':رسالة جديدة'
                              },
                              'priority': 'high',
                              'data': <String, dynamic>{
                                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                'id': '1',
                                'status': 'done',
                                'screen': 'chat',
                                'data': <dynamic, dynamic>{
                                  'sender': widget.me.toJson(),
                                  'receiver': widget.user.toJson() ,
                                  "type" :"message"
                                }
                              },
                              'to':
                                  '/topics/teacher${widget.user.id.toString()}'
                            },
                          ),
                        );

                        debugPrint(response.body);

                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      }),
                  hintText: 'message...'),
onTap: (){
  
                        _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn);
},
            ),
          )),
    );
  }
}
