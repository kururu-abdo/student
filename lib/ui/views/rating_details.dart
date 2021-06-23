
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:screenshot/screenshot.dart';

class RatingDetails extends StatefulWidget {
  String id;
   RatingDetails({ Key key ,  this.id }) : super(key: key);

  @override
  _RatingDetailsState createState() => _RatingDetailsState();
}

class _RatingDetailsState extends State<RatingDetails> {
  ScreenshotController screenshotController = ScreenshotController(); 
 Uint8List _imageFile;
  @override
  Widget build(BuildContext context) {
        CollectionReference ratings =
        FirebaseFirestore.instance.collection('rating');

 return Scaffold(
  appBar: new AppBar(title: Text("الاشادة"),
  centerTitle: true,
  
  
  
  ),
body: SafeArea(child: Padding(padding: EdgeInsets.all(15.0) ,
child: Screenshot(
    controller: screenshotController,
  child:   Center(
  
    child: FutureBuilder<QuerySnapshot>(
  
      future: ratings.where("id" , isEqualTo: widget.id).get(),
  
      builder: (context, snapshot) {
  
        if (!snapshot.hasData) {
  
          return CircularPercentIndicator(radius: 5);
  
        }
  
        var data =  snapshot.data.docs.first.data();
  
  
  
        return
  
         Container(
  
           height: 250,
  
          decoration: BoxDecoration(
  
             border: Border.all(width: 5, ) ,
  
             
  
          ),
  
  child: Column(
  
  crossAxisAlignment: CrossAxisAlignment.center,
  
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  
    children: [
  
  Text(data.toString() ) ,
  
  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  
  children: [
  
   InkWell(  
  
     
  
     onTap: () async{
  
  
  
  
  
       final directory = (await getApplicationDocumentsDirectory ()).path; //from path_provide package
  
  String fileName = DateTime.now().microsecondsSinceEpoch.toString();
  
  var path = '$directory';
  
  var value = await screenshotController.capture(delay: Duration(milliseconds: 10));
  print(value.toString());
 final dir = await getApplicationDocumentsDirectory();
    final pathOfImage = await File('${dir.path}/legendary.png').create();
    final Uint8List bytes = value.buffer.asUint8List();
    await pathOfImage.writeAsBytes(bytes);

  
  
  
  
  screenshotController.captureAndSave(
  
      path ,
  
      fileName:fileName 
  
  );
  
    
  
    
  
     },
  
     
  
      child: Container(
  
     
  
    width: 100,
  
      height: 30,
  
     decoration: BoxDecoration(
  
       color: Colors.green,
  
       borderRadius: BorderRadius.all(Radius.circular(30))
  
     ),
  
  child: Center(child: Text("سكرين شوت"),),
  
   ),
  
   ),
  
   InkWell(
  
                              child: Container(
  
                                width: 100,
  
                                height: 30,
  
                                decoration: BoxDecoration(
  
                                    color: Colors.red,
  
                                    borderRadius:
  
                                        BorderRadius.all(Radius.circular(30))),
  
                                child: Center(
  
                                  child: Text(" رجوع" ,  style: TextStyle(color: Colors.black),),
  
                                ),
  
                              ),
  
                            ),
  
  
  
  ],
  
  
  
  )
  
  
  
  
  
    ],
  
  ),
  
        );
  
      }
  
    ),
  
  ),
),


)),



 );
  }
}