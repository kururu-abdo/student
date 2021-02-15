import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as fire_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/model/student.dart';
import 'package:student_side/ui/views/home/home_screen.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/firebase_init.dart';
class CompleteReg extends StatefulWidget {

final String first_name;
final String last_name;
final String id_number;
final String email;
final String password;
final Department dept;
final Level level;

  CompleteReg({Key key, this.first_name, this.last_name, this.id_number, this.email, this.password, this.dept, this.level}) : super(key: key);

  @override
  _CompleteRegState createState() => _CompleteRegState();
}

class _CompleteRegState extends State<CompleteReg> {

String profile_image;

File _image;
@override
void initState() { 
  super.initState();
  FirebaseInit.initFirebase();


}



uploadImage() async{
 
//   Backendless.files.upload(_image, "/myfiles"  ,onProgressUpdate: ( value){
// print(value);
//     setState((){
// _level=value;
//     });
//   } ).then((response) {
//   print("File has been uploaded. File URL is - " + response);
//   //_image.delete();

//   setState(() {
//     _progressLevel=false;
//   });
// });

// FirebaseStorage storage =
//   FirebaseStorage.instance;
//  await FirebaseStorage.instance
//         .ref('profile/${Path.basename(_image.path)}')
//         .putFile(_image);
// var storageReference=    storage.ref()
// .child('profile/${Path.basename(_image.path)}');
             

//    var uploadTask = storageReference.putFile(_image);    
//    await uploadTask;

//   storageReference.getDownloadURL().then((fileURL) {    
//      print(fileURL);   
//    });


  try {
  TaskSnapshot upload= await   fire_storage.FirebaseStorage.instance
        .ref('profile/${Path.basename(_image.path)}')
        .putFile(_image);
    


setState(() {
  this.profile_image =  upload.ref.fullPath;
});

 await updateUserData();
 
   } on fire_storage.FirebaseException catch (e) {
     // e.g, e.code == 'canceled'
     print(e);
   }
 
 
 
 
 }
 
 
 /*
 
 Scaffold(
 
 appBar: AppBar(title: Text('Complete Registeration'),
 centerTitle: true,
 elevation: 0,
 backgroundColor: Colors.white,
 
 ),
 
 body:
 */
 
   @override
   Widget build(BuildContext context) {
     return  SafeArea(
           child: Scaffold(
         
             body: Padding(
               padding: const EdgeInsets.only(top:10.0),
               child: Center(
 child: ListView(
   children:[
 
          ClipRRect(
                         borderRadius: BorderRadius.circular(100.0),
                         child:
                                Stack(
 children:[
                        Center(
                          child: ClipRRect(
                           borderRadius: BorderRadius.circular(100.0),
                           child:  _image==null?    Image.asset('assets/images/user.jpg', height: 150):Image.file(_image ,height: 150.0,) ),
                        ), 
 
                         
                                
                       //        Positioned(
 
                       //  right: 5,
                       
                       //  top: 100,
 
                       //  child: 
                        
                         Center(
                           child: IconButton(
                            icon: Icon(Icons.add_a_photo ,color: Colors.deepOrange,) ,
                            onPressed:(){
 //Get.showSnackbar(GetBar(title: 'choose imgae' ,message: 'select image source Gallery/Camera',));
 
 
 
 Get.bottomSheet(
  
  
  Container(
         child: Wrap(
           children: <Widget>[
               ListTile(
                 leading: Icon(FontAwesomeIcons.camera),
                 title: Text('Camera'),
                 onTap: () async=> {
 
 await _selectIamge(false)
 
                 }
               ),
               ListTile(
                 leading: Icon(FontAwesomeIcons.image),
                 title: Text('Gallery'),
                 onTap: () async => {
 
                   await _selectIamge(true)
                 },
               ),
           ],
         )),
 
         backgroundColor: Colors.teal
   
 );
 
 
 
                            }
                        ),
                         )
 
                     //   )
                             ]) ,
 
                             
                       ),
 
 SizedBox(height: 100),
                       Row(
 mainAxisAlignment:MainAxisAlignment.spaceBetween ,
 children:[
 
 FlatButton(child:Text('skip'), onPressed:() async{

await getStorage.write('islogged', true);
getStorage.write('student', json.encode(Student(widget.first_name+widget.last_name, widget.id_number, widget.password, widget.dept  ,widget.level, this.profile_image??'' ,widget.email).toJson() )); 



Navigator.of(context).push(
  MaterialPageRoute(builder:(_)=>HomeView())
  
);  }),
 
 FlatButton(child:Text('add image'), onPressed:() async{
 
 

 
 
 }) ,
 ]
 
                       )
 
 
   ]
 )
 ),
             ),
       ),
     );
   }
 
 
 
 
 
 
   
 Future _selectIamge(bool selection) async{
   if(selection){
 var image = await ImagePicker.pickImage(source: ImageSource.gallery);
 setState(() {
   _image = image;
 
 
 });
 
 await uploadImage();
   }else{
 
 var image = await ImagePicker.pickImage(source: ImageSource.camera);
 setState(() {
   _image = image;
 });
 
   }
 
 
 
  
 
 }
 
   updateUserData() async {
CollectionReference student = FirebaseFirestore.instance.collection('student');


   student
    .doc(widget.id_number)
    .update({'profile': this.profile_image})
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));


   }
}