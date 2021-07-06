import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:load/load.dart';
import 'package:student_side/app/animated_container.dart';
import 'package:student_side/app/services_provider.dart';
import 'package:student_side/app/subject_bloc.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/chat_user.dart';
import 'package:student_side/model/consult.dart';
import 'package:student_side/model/notification.dart';
import 'package:student_side/model/subject.dart';
import 'package:student_side/ui/views/chat_page.dart';
import 'package:student_side/ui/views/events.dart';
import 'package:student_side/ui/views/home/consults/comments.dart';
import 'package:student_side/ui/views/home/consults/consults.dart';
import 'package:student_side/ui/views/home/home_screen.dart';
import 'package:student_side/ui/views/notification_pages/event_comments.dart';
import 'package:student_side/ui/views/notification_pages/lecture_comments.dart';
import 'package:student_side/ui/views/notification_pages/my_consult_comments.dart';
import 'package:student_side/ui/views/subject_details.dart';
import 'package:student_side/ui/views/welcome_screen.dart';
import 'package:student_side/util/chat_page_args.dart';
import 'package:student_side/util/keys.dart';
import 'package:student_side/util/local_datase.dart';
import 'package:student_side/util/ui/app_colors.dart';
import 'package:student_side/util/ui/notifcatin_page.dart';
import 'package:student_side/util/ui/notifications_page.dart';

Isolate isolate;
//  AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.High,
// );

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
   RemoteNotification notification = message.notification;
  AndroidNotification android = message.notification?.android;

  if (notification != null && android != null) {
    debugPrint('config notfication');

    DBProvider.db.newNotification(LocalNotification(
        title: notification.title,
          body: notification.body,
        object: json.encode(message.data["data"]),
        time: DateTime.now().millisecondsSinceEpoch));
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
      android:      AndroidNotificationDetails(
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
            ),   payload: json.encode(message.data["data"])   );
  }

  // if (message.data['screen'] == 'consults') {
  //   Get.toNamed('/consults');
  // } else if (message.data['screen'] == 'consultcomments') {
  //   Map data = message.data['data'];

  //   Get.toNamed('/consultcomments', arguments: Consult.fromJson(data));
  // } else if (message.data['screen'] == 'chat') {
  //   var user = User.fromJson(message.data['data']['sender']);

  //   var me = User.fromJson(message.data['data']['receiver']);

  //   Get.toNamed('/chat', arguments: ChatPageArgs(me, user));
  // } else if (message.data['screen'] == 'lecture' ||
  //     message.data['screen'] == 'event') {
  //   Get.toNamed('/subject');
  // } else if (message.data['screen'] == 'lecturedetails') {
  //   Get.toNamed('/consultcomments');
  // } else if (message.data['screen'] == 'eventdetails') {
  //   Get.toNamed('/consultcomments');
  // } else {
  //   Get.toNamed('/');
  // }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final Map<dynamic, dynamic> _items = <dynamic, dynamic>{};
_itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  debugPrint('dddddddddddddddddddddddddddd');
  SchedulerBinding.instance
      .addPostFrameCallback((_){
 if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }


      });
 

  // Or do other work.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await FlutterDownloader.initialize();
  FlutterDownloader.registerCallback(TestClass.callback);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
 android:initializationSettingsAndroid,  
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        debugPrint("onselect");
    var data = json.decode(payload);
   debugPrint(data);

debugPrint(data["type"]);
    if (data['type'] == "message") {
      var me = User.fromJson(data['receiver']);
      var user = User.fromJson(data['sender']);
      Get.to(ChatPage(
        me: me,
        user: user,
      ));
    } else {
     
      if(data["type"]=="consult"){
  Get.to(Consults());
      }
      if(data["type"]=="consult_comment"){
Get.to(MyConsultComments() ,  arguments: data["id"]);
      }

        if (data["type"] == "news") {

          debugPrint("inside news");
        Get.to(Events());
      }
      if(data["type"]=="lecture" || data["type"]=="event"  ){
      //  Get.to(SubjectDetails(subject));
      }
      if(data["type"]=="lecture_comment"){
      Get.to(LectureComments(data['id']));

      }

 if(data["type"]=="event_comment"){
      Get.to(EventComments(data['id']));

      }


    }

    debugPrint('notification payload: $payload');
  });
  runApp(
    
       MultiProvider(providers: [
    Provider<ServiceProvider>(create: (_) => ServiceProvider()),
    Provider<SubjectProvider>(create: (_) => SubjectProvider()),
    ChangeNotifierProvider<AnimContainer>(create: (_) => AnimContainer()),
    Provider<UserProvider>(create: (_) => UserProvider()),
  ] ,child: MyApp()
      
      
  ) 
      )
      
      
      
      ;
}

Route routes(RouteSettings settings) {
  if (settings.name == "notification") {
    return MaterialPageRoute(
      builder: (_) => NotificationPage(),
    );
  } else if (settings.name == '/') {
    return MaterialPageRoute(
      builder: (_) => WelcomeScreen(),
    );
  } else if (settings.name == '/consultcomments') {
    return MaterialPageRoute(
      builder: (_) => ConsultComments(),
    );
  } else if (settings.name == '/consults') {
    return MaterialPageRoute(
      builder: (_) => Consults(),
    );
  } else if (settings.name == '/subject') {
    //  ClassSubject subject = ClassSubject.fromJson(message.data['data'])
    return MaterialPageRoute(
      builder: (_) => Consults(),
    );
  } else {
    return MaterialPageRoute(
      builder: (_) => HomeView(),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // key:  Get.key ,
        debugShowCheckedModeBanner: false,

        locale: const Locale('ar', ''),
      localizationsDelegates   : <LocalizationsDelegate<dynamic>>[
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        title: 'Flutter Demo',
        // locale: Locale('ar'),


        theme: ThemeData.from(colorScheme: ColorScheme.light(

primary: AppColors.greenColor ,
onPrimary: Colors.white,
secondary: Colors.green[200] ,
onSecondary: Colors.black ,
background: Colors.white ,
onBackground: Colors.black

        )),
      //   delegates: <LocalizationsDelegate<dynamic>>[
      //   DefaultWidgetsLocalizations.delegate,
      //   DefaultMaterialLocalizations.delegate,
      // ],
      
routes: {
  NotificationPage.page_id:(context)=>NotificationsPage()
},
        home: 
         LoadingProvider(
           key: RIKeys.riKey1,
      themeData: LoadingThemeData(
        tapDismiss: false ,
        
      ),
      
      loadingWidgetBuilder: (ctx, data) {
        return Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: Container(
              child: CircularProgressIndicator(),
              // color: AppColors.secondaryColor,
            ),
          ),
        );
      },
      child: WelcomeScreen()
        
         )    
        
        //WelcomeScreen()
        
        
        
        
        
        );
  }
}
class TestClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {}
}
