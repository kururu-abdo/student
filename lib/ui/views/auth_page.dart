import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_side/ui/views/login/login_view.dart';
import 'package:student_side/ui/views/registeration/reg_steps.dart';
import 'package:student_side/ui/views/registeration/registeration_view_model.dart';
import 'package:student_side/ui/views/registeration/regiteration_screen.dart';
import 'login_page.dart';
class Auth extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {


return _State();
  }



}

class _State  extends State<Auth>{
  @override
  Widget build(BuildContext context) {
  
return Material(
  child:   Scaffold(
  
    appBar: AppBar(title: Text('Browse Courses'),
  
    
  
    centerTitle: true,
  
    ),
  
  body: Padding(
    padding: EdgeInsets.all(8),
      child: ListView(
    
    children: [
    
    SizedBox(
    
    
    
    
    
      height: 20,
    
    ) ,
    
    
    
    Center(child: Text('Welcome' ,  style:TextStyle(fontWeight: FontWeight.bold ,fontSize: 30))) ,
    
    
    
   Padding(
     padding: const EdgeInsets.only(left: 25.0),
     child: Text(
        'be up-to-date with all events   and \n and also you can ask what you want with your  \n      account'
        
        
         ,
        style: TextStyle( wordSpacing: 2.0 ,letterSpacing: 0.5 ,fontSize: 20)
                        ),
   ),
   
 
    
    

    
    
     
    SizedBox(
    
      height:40
    
    ) ,
    
    
    
    
    
    MaterialButton(
    
    color:Colors.green,
    
      child:Text('سجل دخول برقمك الجامعي') ,
    
    
    
      onPressed:(){

Navigator.of(context).push(MaterialPageRoute(builder: (_)=> LoginView()));

      }
    
    ) ,
    
    
    
    SizedBox(
    
      height:15
    
    ) ,
    
    
    
    Text('ليس لديك حساب بعد!؟') ,
    
    
    
    MaterialButton(
    
    color:Colors.green,
    
      child:Text('حساب جديد') ,
    
    
    
      onPressed:(){

                   Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Material(child:    RegisterationView() )));



      }
    
    ) ,
    
    SizedBox(height:120),
    
    RichText(
    
      text: TextSpan(
    
        text: 'by sining in  , you accept DS online Accademy ',
    
        style: DefaultTextStyle.of(context).style,
    
        children: <TextSpan>[
    
          TextSpan(text: 'terms & conditions  ', style: TextStyle(color :Colors.green , fontWeight: FontWeight.bold)),
    
    
    
        TextSpan(text: '  and'),
    
    
    
          TextSpan(text: '  and privay policy' , style: TextStyle(color :Colors.green , fontWeight: FontWeight.bold)),
    
        ],
    
      ),
    
    ) ,
    
    
    
    
    
    
    
    
    
    
    
    ],
    
    
    
    
    
    ),
  ),
  
  
  
  
  
  ),
);


  }


}