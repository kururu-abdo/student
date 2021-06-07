import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_side/ui/views/home/consults/consults.dart';
import 'package:student_side/ui/views/news/news.dart';
import 'package:student_side/ui/views/teachers.dart';
import 'package:student_side/util/ui/app_colors.dart';


class MainDrawer extends StatefulWidget {
  // final Function filterProviders;
  MainDrawer();
  @override
  _ProvidersFilterDrawerState createState() => _ProvidersFilterDrawerState();
}

class _ProvidersFilterDrawerState extends State<MainDrawer> {
 


  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
           Container(height: 50,
           
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [ImageIcon(AssetImage('assets/images/dots.png') ,) ,


IconButton(icon: Icon(Icons.arrow_forward_ios) , onPressed: (){
  Navigator.of(context).pop();
}) ,

// IconButton(
//                     icon: Icon(Icons.more_horiz),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     })

           ],),
           ) ,

SizedBox(height: 20.0,) ,
 Align(
   alignment: Alignment.centerRight,
   child: Container(
     padding: EdgeInsets.only(left: 20),
                height: 130,
                child: Column(
             
                  children: [

                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/karari.png'),
                      radius: 40.0,
                    ) ,

                    Column(
                      children: [
                        Text('عابدة' ,  style: TextStyle(fontWeight: FontWeight.bold),)  ,
                        Text('لسنة الرابعة حاسوب' ,  style: TextStyle(color: Color.fromARGB(255, 172, 175, 181) ,
                        fontWeight: FontWeight.bold
                        
                        ),)
                      ],
                    )
                  

// IconButton(
//                     icon: Icon(Icons.more_horiz),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     })
                  ],
                ),
              ),
 ),
SizedBox(height: 30,),
Column(

  children: [

ListTile(
  leading:Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle ,
      color: Color.fromARGB(255, 228, 247, 255)
    ),
    child: Icon(Icons.web,size: 20,
                      color: Color.fromARGB(255, 79, 18, 254),
                    ),
  ),
  trailing: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 245, 245, 246)),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Color.fromARGB(255, 65, 67, 82),
                      size: 20,
                    ),
                  ) ,
  title: Text('موقع الكلية', style: TextStyle(fontWeight: FontWeight.bold)),),


ListTile(
  leading:Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle ,
      color: Color.fromARGB(255, 228, 247, 255)
    ),
    child: Icon(Icons.web,size: 20,
                      color: Color.fromARGB(255, 79, 18, 254),
                    ),
  ),
  trailing: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 245, 245, 246)),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Color.fromARGB(255, 65, 67, 82),
                      size: 20,
                    ),
                  ) ,
  title: Text('الاخبار', style: TextStyle(fontWeight: FontWeight.bold)),
  onTap: (){
    Navigator.of(context).push(PageTransition(child: NewsFeed(), type: PageTransitionType.fade));
  },
  
  ),

ListTile(
  onTap: (){
    Navigator.of(context).push(
      
PageTransition(child: Consults(), type: PageTransitionType.fade)
    );
  },
  leading:Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle ,
      color: Color.fromARGB(255, 228, 247, 255)
    ),
    child: Icon(Icons.web,size: 20,
                      color: Color.fromARGB(255, 79, 18, 254),
                    ),
  ),
  trailing: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 245, 245, 246)),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Color.fromARGB(255, 65, 67, 82),
                      size: 20,
                    ),
                  ) ,
  title: Text('الإستفسارات', style: TextStyle(fontWeight: FontWeight.bold)),),

ListTile(
onTap: (){
  Navigator.of(context).push(

MaterialPageRoute(builder: (_)=>
Teachers()
)

  );
},


  leading:Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle ,
      color: Color.fromARGB(255, 228, 247, 255)
    ),
    child: Icon(Icons.web,size: 20,
                      color: Color.fromARGB(255, 79, 18, 254),
                    ),
  ),
  trailing: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 245, 245, 246)),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Color.fromARGB(255, 65, 67, 82),
                      size: 20,
                    ),
                  ) ,
  title: Text('الأساتذة', style: TextStyle(fontWeight: FontWeight.bold)),),

ListTile(
  leading:Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle ,
      color: Color.fromARGB(255, 228, 247, 255)
    ),
    child: Icon(Icons.web,size: 20,
                      color: Color.fromARGB(255, 79, 18, 254),
                    ),
  ),
  trailing: Container(

           

                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 245, 245, 246)),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Color.fromARGB(255, 65, 67, 82),
                      size: 20,
                    ),
                  ) ,
  title: Text('عن التطبيق', style: TextStyle(fontWeight: FontWeight.bold)),)


  ],

) ,


SizedBox(height: 30,) ,

SizedBox(
              width: 50,
  child:   Container(
  
   
  
    decoration: BoxDecoration(
  
      borderRadius: BorderRadius.all(Radius.circular(10)) ,
  
      color: Color.fromARGB(255, 245, 245, 247),
  
      
  
    ),
  
    margin: EdgeInsets.only(right: 20, left: 150),

  
    child: Row(
  
    //mainAxisAlignment: MainAxisAlignment.spaceAround,
  
    children: [
  
      Icon(Icons.login_outlined  , color: Color.fromRGBO(252, 66, 109, 1.0),) ,
  
      Text('تسجيل الخروج')
  
  
  
    ],
  
    
  
    ),
  
  ),
)
        
          ],
        ),
      ),
    );
  }

  
}