import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutCollege extends StatelessWidget {
  const AboutCollege({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Padding(child:ListView(
children:[

Header() ,
SizedBox(height:20.0) ,

Center(
  child:   AutoSizeText(
  '"At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. \n Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."',
  style: TextStyle(fontSize: 20),
  maxLines:20,
)
  
  
  
  // TypewriterAnimatedTextKit(
  
  //   speed: Duration(milliseconds: 500),
  
  //   totalRepeatCount: 4,
  
  //   text: ["computer science college is one of the most interesting coolleges around the world ", "any one wish to join it"],
  
  //   textStyle: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold ,color:Colors.black),
  
  //   pause: Duration(milliseconds: 1000),
  
  //   displayFullTextOnTap: true,
  
  //   stopPauseOnTap: true,
  
  // ),
)
]


      ) ,padding: EdgeInsets.only(top:8.0),)
    );
  }
}

class  Header extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Row(children: [
IconButton(icon:Icon(Icons.arrow_back) ,onPressed: (){
  Get.back();
},) ,

Text('عن الكلية' , style: GoogleFonts.cairo(color: Colors.black ,  fontSize: 20  ,) ),
SizedBox(width: 20.0,)




   ],
   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
   
   );
  }


}