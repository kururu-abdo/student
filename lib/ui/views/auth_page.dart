import 'package:flutter/material.dart';

import 'package:student_side/ui/views/login/login_view.dart';

import 'package:student_side/ui/views/registeration/regiteration_screen.dart';

class Auth extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {


return _State();
  }



}

class _State  extends State<Auth>{
  @override
  Widget build(BuildContext context) {
  

return SafeArea(
  child:   Material(
  
    child: Container(
  
      
  
      decoration: BoxDecoration(
  
        image:DecorationImage(
  
                            image: AssetImage('assets/images/splash2.jpg'),
  
                            fit: BoxFit.cover)
  
                            
  
                            )
  
      ,
  
      
  
      child: LayoutBuilder(
  
      builder: (BuildContext context, BoxConstraints constraints) {
  
        return   ListView(
  
          children: [
  
     SizedBox(height: 20,),
  
    
  
     Center(
  
                      child: Text('أهلا بك',
  
                          style: TextStyle(
  
                              fontWeight: FontWeight.bold, fontSize: 30 ,color: Colors.white))),
  
                  Padding(
  
                    padding: const EdgeInsets.only(left: 25.0),
  
                    child: Center(
  
                      child: Text(
  
                        'اعرف الحاصل شنو في الكلية \n النتيجة و ومتين الكلية تقتح  \n و متين تقفل و كمان ممكن تسنفسر \n ',
  
                        style: TextStyle(
  
                          color: Colors.white,
  
                            wordSpacing: 2.0, letterSpacing: 0.5, fontSize: 20),
  
                        maxLines: 16,
  
                      ),
  
                    ),
  
                  ),
  
     
  
     SizedBox(height: 40),
  
      
  
      MaterialButton(
shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.horizontal(
    left: Radius.circular(20),
    right: Radius.circular(20), 
  )
),

                      color: Colors.blue[800],
  
                      child: Text('سجل دخول برقمك الجامعي'),
  
                      onPressed: () {
  
                        Navigator.of(context)
  
                            .push(MaterialPageRoute(builder: (_) => LoginView()));
  
                      }),
  
                  SizedBox(height: 15),
  
                  Center(child: Text('ليس لديك حساب بعد!؟' ,  style: TextStyle(color: Colors.white),)),
  
                  MaterialButton(
  shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20),
                        right: Radius.circular(20),
                      )),
                      color: Colors.blue[800],
  
                      child: Text('حساب جديد'),
  
                      onPressed: () {
  
                        Navigator.of(context).push(MaterialPageRoute(
  
                            builder: (_) =>
  
                                Material(child: RegisterationView())));
  
                      }),
  
    
  
  
  
  
  
  
  
  
  
          ],
  
        ) ;
  
      },
  
    ),),
  
  ),
);

return Material(
  child:   Scaffold(
  
    appBar: AppBar(
      title: Text('مرحبا'),
  
    
  
    centerTitle: true,
  
    ),
  
  body: Padding(
    padding: EdgeInsets.all(8),
      child: ListView(
    
    children: [
    
    SizedBox(
    
    
    
    
    
      height: 20,
    
    ) ,
    
    
    
    Center(child: Text('أهلا بك' ,  style:TextStyle(fontWeight: FontWeight.bold ,fontSize: 30))) ,
    
    
    
   Padding(
     padding: const EdgeInsets.only(left: 25.0),
     child: Center(
            child: Text(
         
          'اعرف الحاصل شنو في الكلية \n النتيجة و ومتين الكلية تقتح  \n و متين تقفل و كمان ممكن تسنفسر \n '
          
          
           ,
          style: TextStyle( wordSpacing: 2.0 ,letterSpacing: 0.5 ,fontSize: 20)  ,
          maxLines: 16,
                          ),
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