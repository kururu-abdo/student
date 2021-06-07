import 'package:flutter/material.dart';
import 'package:student_side/model/notification.dart';
import 'package:student_side/util/local_datase.dart';

class NotificationPage extends StatefulWidget {

static const String page_id = 'notification';
final Map data;

NotificationPage(this.data);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Material (
   


   child :  Scaffold(
   appBar : AppBar(
title :  Text('الإشعارات' ),  

centerTitle :  true ,

actions :[
  IconButton (  icon: Icon(Icons.home ) ,  onPressed :() {
   

  })


]
   ) ,

    body: FutureBuilder<List<LocalNotification>>(
        future: DBProvider.db.getAllNotification(),
        builder: (BuildContext context, AsyncSnapshot<List<LocalNotification>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                LocalNotification  item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    // DBProvider.db.deleteClient(item.id);
                  },
                  child: ListTile(
                    title: Text(item.title),
                    leading: Text(item.id.toString()),
                    trailing: Checkbox(
                      onChanged: (bool value) {
                        DBProvider.db.getAllNotification();
                        setState(() {});
                      },
                      value: false,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),



   )

    );
  }
}