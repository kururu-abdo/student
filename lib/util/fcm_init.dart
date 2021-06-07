import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:student_side/main.dart';


class FCMConfig {

  FCMConfig() {
    fcmConfig();
  }

  static fcmConfig() async {
    debugPrint('config notfication');
  
 FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                AndroidNotificationDetails(
                    'channel', 'channelName', 'channelDescription'),
                null
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
                ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.data.toString());
      Get.toNamed('notification');
    });


RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
  
debugPrint(initialMessage?.data.toString());

    if (initialMessage?.data['type'] != 'chat') {
   Get.toNamed('notification');
    }      

FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
print(notification.android.color);
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
            AndroidNotificationDetails(
              'channel.id',
                  'channel.name',
                  'channel.description',
                  icon: android?.smallIcon,
            ) ,
            null
            ));
      }
    });


  }

  static routes() {}

  static _handleOnMessage(Map<dynamic, dynamic> data) {}

  static _handleOnResume(Map<dynamic, dynamic> data) {}

  static _handleOnLaunch(Map<dynamic, dynamic> data) {}

  static subscripeToTopic(String topic) {
    debugPrint('subscribe to topic'+  topic);
    FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  static unSubscripeToTopic(String topic) {

   FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  static Future<String> getToken() async {
    return await   FirebaseMessaging.instance.getToken();
  }
}
