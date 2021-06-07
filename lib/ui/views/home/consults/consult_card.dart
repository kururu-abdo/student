import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:student_side/model/consult.dart';
import 'package:student_side/ui/views/home/consults/comments.dart';

class ConsultCard extends StatefulWidget {
  final Map consult;

  ConsultCard({Key key, this.consult}) : super(key: key);

  @override
  _ConsultCardState createState() => _ConsultCardState();
}

class _ConsultCardState extends State<ConsultCard> {
  @override
  Widget build(BuildContext context) {
    final double aspectRatio = 6 / 3;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return Material(child: ConsultComments());
                },
                settings: RouteSettings(
                    arguments: Consult.fromJson(widget.consult))));
      },
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Card(
          elevation: 2,
          child: Container(
            color: Color.fromARGB(255, 244, 246, 249),
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: <Widget>[
                _PostDetails(),

                //   SizedBox(height:10) ,
                Divider(color: Colors.grey),
                _Consult(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _Consult() {
    return Column(children: [
      //  Center(child:Text(widget.consult['student']['name']??'')) ,

      Container(
        // decoration: BoxDecoration(
        //    color: Colors.grey,
        // ),
        child: Text(
          widget.consult['consult'] ?? '',
          maxLines: 16,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    ]);
  }

  String timeWidgetText(int t) {
 var format = new DateFormat('d MMM, hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(t );
var formattedDate = DateFormat.yMMMd().format(date); // Apr 8, 2020


    var now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
   var formattedToday =  DateFormat.yMMMd().format(today);


    final yesterday = DateTime(now.year, now.month, now.day - 1);
   var formattedYesterDay =  DateFormat.yMMMd().format(yesterday);

  String time ='';

if(formattedDate == formattedToday) {
  time ="اليوم" ;
} else if(formattedDate == formattedYesterDay) {
  time ="الأمس";

}else{



  time = formattedDate;
}
    
    return time;
  }
  Widget _PostDetails() {
    return Row(
      children: [
// Text(widget.consult['level']['name']??'') ,
        Text(
          widget.consult['student']['name'] ?? '',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Center(child:Text(widget.consult['student']['id_number']??'')) ,

        Text(widget.consult['time'] != null
            ? timeWidgetText(widget.consult['time'] ).toString()
            : '')
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

}

class ConsutDetails extends StatefulWidget {
  // final Map consult;
  ConsutDetails({Key key}) : super(key: key);

  @override
  _ConsutDetailsState createState() => _ConsutDetailsState();
}

class _ConsutDetailsState extends State<ConsutDetails> {
  @override
  Widget build(BuildContext context) {
    final Consult consult = ModalRoute.of(context).settings.arguments;
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.back();
              },
            ),
            Text('الاستفسار'),
            SizedBox(width: 30)
          ],
        ),
        SizedBox(height: 20.0),
        Center(
          child: Container(
              width: double.infinity,
              height: 200.0,
              decoration: BoxDecoration(color: Colors.teal),
              child: AutoSizeText(
                consult.body,
                style: TextStyle(fontSize: 15.0),
                maxLines: 15,
              )),
        ) ,
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: 300),
          child: TextFormField(
            maxLines: 15,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0.0),
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  // add  a comment
        
                  //push a notification to owner of the consult
        
                  //push a notification to all commantators
                },
              ),
              border: OutlineInputBorder(),
              labelText: 'comment...',
            ),
            onChanged: (text) {
              setState(() {
                // fullName = text;
                //you can access nameController in its scope to get
                // the value of text entered as shown below
                //fullName = nameController.text;
              });
            },
          ),
        ),
      ],
    );
  }
}
