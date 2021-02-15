import 'package:flutter/material.dart';

class NewConsult extends StatefulWidget {
  NewConsult({Key key}) : super(key: key);

  @override
  _NewConsultState createState() => _NewConsultState();
}

class _NewConsultState extends State<NewConsult> {
  @override
  Widget build(BuildContext context) {
    return  Material(
          child: ListView(


        children: [
Padding(
  
  padding: EdgeInsets.only(top:8.0),
  child:  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
Row(children: [
IconButton(icon: Icon(Icons.arrow_back), onPressed: () { Navigator.of(context).pop(); },) ,

Text('استفسار جديد' ,  style: TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold),)

],) ,

Container(
  decoration: BoxDecoration(

    borderRadius : BorderRadius.all(Radius.circular(30.0))
    
  ),
  
  child:   MaterialButton(onPressed: () {  },
  
  
  child: Text('نشر'), color: Colors.green, 
  
  
  
  
  
   ),
)

  ],) ,) ,
SizedBox(
  height:50.0
) ,


TextFormField(
   minLines: 6, // any number you need (It works as the rows for the textarea)
   keyboardType: TextInputType.multiline,
   maxLines: null,
)


        ],
      ),
    );
  }
}