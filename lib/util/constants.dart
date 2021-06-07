import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';

const List<Map>  users=


[

{
"user_id":"dkjkfkdjf100998" ,
"user_name" :"mohammed ahmed" ,
"email":"mohammed@email.com" ,
"password":"12232" ,
"phone":"9458495" ,
"profile" :"https://th.bing.com/th/id/OIP.3wMJFpWlVPMNerfbxhKJTgHaHa?pid=Api&rs=1" ,
"role":"admin"

},

{
"user_id":"rrrrttt43f100998" ,
"user_name" :"Haitham ali" ,
"email":"haitham@email.com" ,
"password":"1234232" ,
"phone":"8475945794" ,
"profile" :"https://th.bing.com/th/id/OIP.3wMJFpWlVPMNerfbxhKJTgHaHa?pid=Api&rs=1" ,
"role":"user"
},


];




const List<Map>  sujects=



[
{
"suject_id":1 ,
"subject_name" :"subject one" 


},

{
"suject_id":2 ,
"subject_name" :"subject two" 


} ,

{
"suject_id":3 ,
"subject_name" :"subject three" 


}



];



const List<Map> lecures=

[

{
"lecure_id" :1,
"subject_id":1,
"title" :"lecture one" ,
"content" :" viedo or document" ,
"uploaded_date" :"1/1/2003"
} ,


{
"lecure_id" :1,
"subject_id":3,
"title" :"lecture one" ,
"content" :" viedo or document" ,
"uploaded_date" :"5/1/2023"
} ,

{
"lecure_id" :1,
"subject_id":2,
"title" :"lecture one" ,
"content" :" viedo or document" ,
"uploaded_date" :"5/1/2021"
} ,


];




const List<Map>  courses=


[
{
"course_id":"45454ltklrklt" ,
"course_title" :"course one" ,
"date":"1/1/2010",
"place": "course place" ,
"price" : "3000",
"lecturer":"Dr.lecturer" ,
"rank":4.2 ,
"img" : "http://www.stocklayouts.com/images/superviews/MD0240701-S.jpg"



} ,

{
"course_id":"45454lteererklrklt" ,
"course_title":"course two" ,
"date":"1/1/2030",
"place": "course place" ,
"price" : "1000" ,
"rank":3.4
,
"lecturer":"Dr.lecturer" ,
"img" : "http://www.stocklayouts.com/images/superviews/MD0240701-S.jpg"


}
,
{
"course_id":"45454ltuuueererklrklt" ,
"course_title":"course two" ,
"date":"1/1/2030",
"place": "course place" ,
"price" : "1000" ,
"rank":3.4
,
"lecturer":"Dr.lecturer" ,
"img" : "http://www.stocklayouts.com/images/superviews/MD0240701-S.jpg"


}










];




const List<Map> evens=



[
{
"event_id" :1,
"title" : "our confrence",
"place":"nile street" ,
"date" :"Friday 5:00 pm  1.1.2005"} ,
{
"event_id" : 2,
"title" : "event two",
"place":"nile street" ,
"date" :"Friday 5:00 pm  1.1.2005"} ,

];


const List<Map>  comment=


[

{

"user_id":"45454ltklrklt" ,
"event_id":1,
"text":"i will go to this event" ,
"date":"1.1.2020"




}  ,

{

"user_id":"45454ltklrklt" ,
"lecture_id":1,
"text":"i need to someone explain this topic clearly for me" ,
"date":"1.1.2020"




}  






] ;






const Map  enroll=

{
"id":1,
"course_id":'45454lteererklrklt',
"user_id":"45454ltklrklt" ,
"notes": "i need to the course"
};


GetStorage  getStorage = new GetStorage();
const String serverToken =
    'AAAAmLQY4zc:APA91bHOu6VSlURNXye9jO1HHEadpwT6Vjv6PZDjhf9dqC-vxDh184KEVRhUWDlgjqUSEv_8G6ic8huYuCew97ZoDAhY2YqOEEarZtvS7AYRp9pFWu2Z-fOJt6Flfuy1L92GBXxKsl6m';


const String USER_ID ='user_id';
const String USER_NAME= 'name';
const String USER_TYPE ='type';
const String ISLOGGEDIN= 'isloggedin';
const String PHONE ='phone';

const String PASSWORD = 'password';



// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.max,
// );
