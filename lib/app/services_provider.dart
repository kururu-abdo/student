import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:student_side/model/event.dart';
import 'package:student_side/model/student.dart';

class ServiceProvider{
BehaviorSubject <List<Event>>   allEvents =  BehaviorSubject<List<Event>>();


 Future<List<Event>> getEvents(Student student) async {
 
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection('events')
          .where('dept', isEqualTo: student.department.toJson())
          .where('level', isEqualTo: student.level.toJson())
          .get();
      List<Event> evnt =
          data.docs.map((e) => Event.fromJson(e.data())).toList();

      evnt.forEach((element) {
        print(element.title);
      });

      return evnt;
 
  }


 Future<List<Event>> getDeptEvents(Student student) async{
 
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection('events')
            .where('level', isEqualTo: student.level.toJson())
         
          .get();
      List<Event> evnt =
          data.docs.map((e) => Event.fromJson(e.data())).toList();

      evnt.forEach((element) {
        print(element.title);
      });

      return  evnt;
  
  }

 Future<List<Event>> getAlltEvents() async {
   
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection('events')
          .where('level', isEqualTo:null)
            .where('dept', isEqualTo: null )
          .get();
      List<Event> evnt =
          data.docs.map((e) => Event.fromJson(e.data())).toList();

      evnt.forEach((element) {
        print(element.title);
      });

      return  evnt;
   
  }

 Future<List<Event>> getYeartEvents(Student student) async {
  
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection('events')
          .where('level', isEqualTo: student.level.toJson())
          .get();
      List<Event> evnt =
          data.docs.map((e) => Event.fromJson(e.data())).toList();

      evnt.forEach((element) {
        print(element.title);
      });

      return  evnt;
    
  }






     Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      } else {
        print('disconnetced');
        return false;
      }
    } on SocketException catch (_) {
      print('not connected');

      return false;
    }
  }
}