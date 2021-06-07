import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/chat_user.dart';
import 'package:student_side/model/semester.dart';
import 'package:student_side/model/teacher.dart';
import 'package:student_side/ui/views/chat_page.dart';
import 'package:student_side/util/fcm_init.dart';
import 'package:student_side/util/firebase_init.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherProfile extends StatefulWidget {
  final Teacher teacher;
  TeacherProfile(this.teacher);

  @override
  _MyPrpfoleState createState() => _MyPrpfoleState();
}

class _MyPrpfoleState extends State<TeacherProfile> {
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    FirebaseInit.initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    CollectionReference teachers =
        FirebaseFirestore.instance.collection('teacher');
    teachers.where('id', isEqualTo: widget.teacher.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teacher.name),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(FontAwesomeIcons.facebookMessenger),
              onPressed: () async {
                var token = await FCMConfig.getToken();

                Get.to(ChatPage(
                  user: User(widget.teacher.id.toString(), widget.teacher.name,
                      'أستاذ'),
                  me: User(userProvider.getUser().id_number.toString(),
                      userProvider.getUser().name, 'طالب'),
                ));
              })
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: teachers.get(),
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
                     // decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //     begin: Alignment.topCenter,
                          //     end: Alignment.bottomCenter,
                          //     colors: [Colors.redAccent, Colors.pinkAccent])),
                      child: Container(
                        width: double.infinity,
                        height: 350.0,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage:   AssetImage(
                                  "assets/images/karari.png",
                                ),
                                radius: 50.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "${widget.teacher.name}",
                                style: TextStyle(
                                  fontSize: 22.0,
                               
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
                                        "محاضر",
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
                                  title: Text('${widget.teacher.phone}'),
                                  trailing: IconButton(onPressed: ()  async {
await openContacts(widget.teacher.phone);
                                  }, icon: Icon(Icons.call)),
                                )),
                                Center(
                                    child: ListTile(
                                  title: Text('${widget.teacher.address}'),
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
openContacts(String phone) async{

    // final Uri _phoneCall = Uri(
    //   scheme: 'tel:$phone' 
    //   // path: 'smith@example.com',
    //   // queryParameters: {'subject': 'Example Subject & Symbols are allowed!'}
    //   );

      await launch('tel:$phone');
}



 






}
