 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_side/model/teacher.dart';
import 'package:student_side/ui/views/teacher_profile.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/ui/app_colors.dart';
class Teachers extends StatefulWidget {
 

  @override
  _TeachersState createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  @override
  Widget build(BuildContext context) {


    var studentProvider = Provider.of<UserProvider>(context);
 Query subs = FirebaseFirestore.instance
        .collection('subject')
        .where('dept', isEqualTo: studentProvider.getUser().department.toJson())
        .where('level', isEqualTo: studentProvider.getUser().level.toJson())
        .where('semester' ,isEqualTo: studentProvider.getUser().semester.toJson() )
        ;


    return    SafeArea(
        child: Scaffold(
         appBar: AppBar(
  backgroundColor: AppColors.primaryColor,
  leading: IconButton(onPressed: (){
    Navigator.of(context).pop();
  }, icon: Icon(Icons.arrow_back , color:  Colors.black,)),
  elevation: 0.0,
            title: Text('الأساتذة' ,  style: TextStyle(color: Colors.black),),
            centerTitle: true,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.only(
            //     bottomLeft: Radius.circular(25) ,

            //      bottomRight: Radius.circular(25),
            //   )
              
            //   ),

              

         ) ,
         body:   FutureBuilder<QuerySnapshot>(
           future: subs.get(),
         
           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState==ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError){
               return Center(child: Text('Eroor'),);
          }


             return  ListView(

               children: snapshot.data.docs.map((document) {


var data = document.data() as Map<String, dynamic>;
                return 
                 FutureBuilder<Teacher>(
                    future: getTeacher(data['teacher_id']),
                  
                    builder: (BuildContext context, AsyncSnapshot<Teacher> snapshot) {

if (snapshot.connectionState==ConnectionState.waiting) {
  return Center(child: CircularProgressIndicator(),);
}
if(!snapshot.hasData){
     return ListTile(
                      onTap: () {
                        Get.to(Material(child: TeacherProfile(snapshot.data)));
                      },
                      title: Text("بدون اسم"),
                      subtitle: Text( "بدون اسم"),
                    );
}
                      return        ListTile(
                    onTap: () {
                      Get.to(Material(
                          child: TeacherProfile( snapshot.data)));
                    },
                    title: Text(snapshot.data.name),
                    subtitle: Text(data['name']??""),
                  );

                    },
                  );
                
                
            

               }).toList(),
             );
           },
         ),
         
         
         ));


  }




 Future<Teacher> getTeacher(String teacher_id) async{
    

 QuerySnapshot data = await FirebaseFirestore.instance
        .collection('teacher')
        .where('id', isEqualTo: teacher_id)
        .get();
    // List<T> lvls = data.docs.map((e) => Level.fromJson(e.data())).toList();
Teacher teacher =  Teacher.fromJson( data.docs.first.data());
  

  return teacher;
  }
}