import 'dart:ui';

import 'package:build_daemon/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

import '../../util/constants.dart';
import '../../util/constants.dart';

class CourseDetail extends StatefulWidget{
  final course_id ;

  const CourseDetail({Key key, this.course_id}) : super(key: key);
  @override
  
  State<StatefulWidget> createState() {
   return _State();
  }


}
class _State extends State<CourseDetail>{


  String course_name;
  String place;
  String   price;
  double rank;
  String img;
  String lecurer;


@override
void initState() { 
  super.initState();
  
  fetchData();
}


fetchData(){
  var course =courses.firstWhere((element) => element['course_id']==widget.course_id);


  setState(() {
    course_name= course['course_title'];
    place = course['place'];
    price= course['price'];
    rank =course['rank'];
    img= course['img'];
 lecurer = course['lecturer'];
  });
}
  @override
  Widget build(BuildContext context) {
    
return Stack(
  fit: StackFit.expand,

  children: [ 
     Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                img
                      ),
              fit: BoxFit.cover,),),
          child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: Container(
      color: Colors.black.withOpacity(0.1),
    ),)
          
    ),
    
    
    
    
     ListView(
  
  children: [
  
  
  
  Container(
  
    child:Row(
  
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
  
      
  
      children: [
  
    IconButton(icon:Icon(Icons.arrow_back_ios ),onPressed:(){}) ,
  
  
  
  
  
  Row(children:[
  
    IconButton(icon:Icon(Icons.share ),onPressed:(){}) ,
  
  
  
  IconButton(icon:Icon(Icons.favorite ),onPressed:(){}) ,
  
  ]) ,
  
  
  
  
  
  
  
    ],)
  
  ) ,
  
  SizedBox(height:15) ,
  
  Padding(
  
    padding: EdgeInsets.only(left:10),
  
    
  
    child: Text(course_name ,style: TextStyle(color:Colors.white ,fontSize:25 ,fontWeight:FontWeight.bold ,letterSpacing: 2.0,)))
  
  ,
  SizedBox(height:20) ,


Padding(
  padding: EdgeInsets.only(left:30),
  child:   Column(
  
    children:[
  
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
  
  Chip(
  
    labelPadding: EdgeInsets.all(5.0),
    labelStyle: TextStyle(  color:Colors.black ,  fontWeight :FontWeight.w600),
    label: Text('💵'+'$price'),) ,
  
    Chip(
    labelPadding: EdgeInsets.all(5.0),
    labelStyle: TextStyle(  color:Colors.black ,  fontWeight :FontWeight.w600),
    label: Text('created by: '+'$lecurer'),) ,
  
  
  
  
  
  ],) ,

   StarRating(
size: 25.0,
rating: rank,
color: Colors.orange,
borderColor: Colors.grey,
starCount: 5,
onRatingChanged: (rating) => setState(
() {
this.rank = rating;
},)) ,

SizedBox(height:10) ,
Padding(
  padding:EdgeInsets.only(left:30 ,right:30) ,

  child: Image.network(img ,
  width: 300 ,
  height:250
  
  ),
) ,

Container(

  child:Column(children: [

MaterialButton(
  
  minWidth: 250,
  color: Colors.green,
  
  child: Text('Add to Cart'),onPressed: (){},) ,
MaterialButton(
    minWidth: 250,
    color: Colors.green,
  
  child: Text('Add to wishlist'),onPressed: (){},)


  ],)
)
  
  
  
    ]
  
  ),
)  
  
  
  ],
  
  ), ]
);


  }

}