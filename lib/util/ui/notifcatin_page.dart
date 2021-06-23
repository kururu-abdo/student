import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_side/model/notification.dart';
import 'package:student_side/ui/views/rating_details.dart';
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
                    // DBProvider.db.del(item.id);
                  },
                  child:    InkWell(onTap: (){
        debugPrint(item.object);
                                            var object =  json.decode(item.object);
                         debugPrint(object.toString());
                         var screen =  object['screen'];
                         //chat

                         //event

                         //comment


                         //warning
                         if(screen=="value_details"){
                           var id   =  object['id'];
                           Get.to(RatingDetails(id: id,));
                         }

                  },
                  child: Container(
                    width: double.infinity,
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(item.title) ,
                          
                          Text(formatedDate(item.time)),
                          ],

                          ) ,
  Text(item.body??''),
Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                 FlatButton(onPressed: (){}, child: Text("حذف")),
  FlatButton(
                                      onPressed: () {}, child: Text("تحديد كمقروء")),                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                  
                  )
                  
  //                 ListTile(
  //                   title: Text(item.title),
  //                   leading: Text(item.id.toString()),
  //                   trailing: Checkbox(
  //                     onChanged: (bool value) {
  //                       DBProvider.db.updateNotifica(item);
  //                       DBProvider.db.getAllNotification();
  //                       setState(() {});
  //                     },
  //                     value: item.isRead,
  //                   ),

  //                   onTap: (){
  //                     debugPrint(item.object);
  //                     var object =  json.decode(item.object);
  //  debugPrint(object.toString());
  //  var screen =  object['screen'];
  //  //chat

  //  //event

  //  //comment

  //                   },
  //                 ),
                );
              },
            );
          } 
          else if(snapshot.hasError){
                        return Center(child: Text(snapshot.error.toString()));

          }
          
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),



   )

    );
  }

formatedDate(int t){
  var date =  DateTime.fromMillisecondsSinceEpoch(t);
String txt ='';
if(date==DateTime.now()){
  txt='الان';
}else{
var now = DateTime.now();
var diff=     now.difference(date);

if (diff.inDays<=0   &&diff.inHours<=0) {
  txt ='قبل   ${diff.inMinutes}  دقايق';

}
else if (diff.inDays <= 0 && diff.inHours >= 1) {
        txt = 'قبل   ${diff.inHours}  ساعات';
      }else{
        var defaultTime =  DateTime.now().subtract(diff);
        
        txt =  '${defaultTime.day}-${defaultTime.month}-${defaultTime.year}';
      }



}

    

return txt;

}



}