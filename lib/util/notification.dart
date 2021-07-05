// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';


// class NotificationPlugin {
//   FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

//   NotificationPlugin() {
//     _initializeNotifications();
//   }

//   void _initializeNotifications() {
//     _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     final initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     final initializationSettingsIOS = IOSInitializationSettings();
//     final initializationSettings = InitializationSettings(
//    android:   initializationSettingsAndroid,
//       initializationSettingsIOS,
//     );
//     _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onSelectNotification: onSelectNotification,
//     );
//   }

//   Future onSelectNotification(String payload) async {
//     if (payload != null) {
      
      
//     // await Get.to(AcceptedOrder(orderId: int.parse(payload),));
//     }


//     // await Get.to(AcceptedOrder(orderId: int.parse(payload),));

//   }

//   Future<void> showWeeklyAtDayAndTime(
//       Time time, Day day, int id, String title, String description) async {
//     final androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'show weekly channel id',
//       'show weekly channel name',
//       'show weekly description',
//     );
//     final iOSPlatformChannelSpecifics = IOSNotificationDetails();
//     final platformChannelSpecifics = NotificationDetails(
//       androidPlatformChannelSpecifics,
//       iOSPlatformChannelSpecifics,
//     );
//     await _flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
//       id,
//       title,
//       description,
//       day,
//       time,
//       platformChannelSpecifics,
//     );
//   }

//   Future<void> showOnce(Map<dynamic ,dynamic> data) async {
//     final androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'show once channel id',
//       'show once channel name',
//       'show once description',
//     );
//     final iOSPlatformChannelSpecifics = IOSNotificationDetails();
//     final platformChannelSpecifics = NotificationDetails(
//       androidPlatformChannelSpecifics,
//       iOSPlatformChannelSpecifics,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       1,
//         'NEW ORDER',
//         '',
//         platformChannelSpecifics,
//         payload:data['order_id'].toString() );
//   }

//   Future<void> showDailyAtTime(
//       Time time, int id, String title, String description) async {
//     final androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'show weekly channel id',
//       'show weekly channel name',
//       'show weekly description',
//     );
//     final iOSPlatformChannelSpecifics = IOSNotificationDetails();
//     final platformChannelSpecifics = NotificationDetails(
//       androidPlatformChannelSpecifics,
//       iOSPlatformChannelSpecifics,
//     );

//     await _flutterLocalNotificationsPlugin.showDailyAtTime(
//       id,
//       title,
//       description,
//       time,
//       platformChannelSpecifics,
//     );
//   }

//   Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
//     final pendingNotifications =
//         await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
//     return pendingNotifications;
//   }

//   Future<void> cancelNotification(int id) async {
//     await _flutterLocalNotificationsPlugin.cancel(id);
//   }

//   Future<void> cancelAllNotifications() async {
//     await _flutterLocalNotificationsPlugin.cancelAll();
//   }

// }
