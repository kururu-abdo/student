import 'dart:convert';

LocalNotification localNotificationFromJson(String str) {
  final jsonData = json.decode(str);
  return LocalNotification.fromJson(jsonData);
}

String localNotificationToJson(LocalNotification data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
class LocalNotification{
  int id;
  DateTime time;
  
  String title;
  String screen;
  String object;
  bool isRead;
LocalNotification({this.id ,this.title,this.screen ,this.object , this.time});

LocalNotification.fromJson(Map<dynamic ,dynamic> data){
  this.id =  data['id'];
  this.title = data['title'];
  this.screen = data['screen'];
  this.object =data['object'];
  this.time = data['time'];
  this.isRead =  data['isread']==1;
}

Map<dynamic ,dynamic> toJson(){
  return {
'id': this.id ,
'title':this.title ,
'screen':this.screen ,
'object': this.object ,
'time': this.time ,
'isread':  this.isRead
  };
}


}