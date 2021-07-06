import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:student_side/main.dart';
import 'package:student_side/model/notification.dart';
import 'package:student_side/util/local_datase.dart';
import 'package:student_side/util/ui/notifcatin_page.dart';

class FCMConfig {
 

  static fcmConfig() async {
    debugPrint('config notfication');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        debugPrint('config notfication');

        var result = await DBProvider.db.newNotification(LocalNotification(
            title: notification.title,
            body: notification.body,
            object: json.encode(message.data),
            time: DateTime.now().millisecondsSinceEpoch));
      Get.defaultDialog(
          title: 'اخطار جديد',
          content: Text("هنالك اخطار جديد"),
          actions: [
            TextButton(
                onPressed: () {


                  Get.to(()=>NotificationPage());
                },
                child: Text('حسنا')) ,



                 TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('تجاهل'))
          ],
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        debugPrint('config notfication');

        var result = DBProvider.db.newNotification(LocalNotification(
            title: notification.title,
            body: notification.body,
            object: json.encode(message.data),
            time: DateTime.now().millisecondsSinceEpoch));
        debugPrint('/////////////////////////////');
        debugPrint(result.toString());
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android:  AndroidNotificationDetails(
                    'channel', 'channelName', 'channelDescription'),
                
                // android:
                //  AndroidNotificationDetails(
                //   channel.id,
                //   channel.name,
                //   channel.description,
                //   // TODO add a proper drawable resource to android, for now using
                //   //      one that already exists in example app.
                //   icon: 'launch_background',
                // ),
                // null
                ),  payload: json.encode(message.data)   );
      }

    });

// RemoteMessage initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

// debugPrint(initialMessage?.data.toString());

//     if (initialMessage?.data['type'] != 'chat') {
//    Get.toNamed('notification');
//     }

    FirebaseMessaging.onBackgroundMessage((message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        debugPrint('config notfication');
        var result = await DBProvider.db.newNotification(LocalNotification(
            title: notification.title,
            body: notification.body,
                        object: json.encode(message.data),

            time: DateTime.now().millisecondsSinceEpoch));
        debugPrint('/////////////////////////////');
        debugPrint(result.runtimeType.toString());
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android:  AndroidNotificationDetails(
                    'channel', 'channelName', 'channelDescription'),
                )  ,    payload: json.encode(message.data)   );
      }

    });
  }

  static routes() {}

  static _handleOnMessage(Map<dynamic, dynamic> data) {}

  static _handleOnResume(Map<dynamic, dynamic> data) {}

  static _handleOnLaunch(Map<dynamic, dynamic> data) {}

  static subscripeToTopic(String topic) {
    debugPrint('subscribe to topic' + topic);
    FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  static unSubscripeToTopic(String topic) {
    FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  static Future<String> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
