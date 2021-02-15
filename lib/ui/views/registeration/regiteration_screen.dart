import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' ;
import 'package:firebase_storage/firebase_storage.dart'  as fire_storage ; 
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/ui/views/registeration/complete_reg.dart';
import 'package:student_side/util/backendless_setup.dart';
import 'package:student_side/util/firebase_init.dart';
import 'registeration_view_model.dart';
class RegisterationView extends StatefulWidget {
  static const String _title = 'Registration Page';
  @override
  _State createState() => _State();
}
class _State extends State<RegisterationView> {
  int selectedGender = 0;
  void _handleRadioValueChange1(int value) =>
      setState(() => selectedGender = value);




List<Department> depts =[];

List<Level> levels =[];

Department dept;
Level level;
String profile_image;
String email;
String password;







fetch_depts() async{
  var future = await showLoadingDialog();

  Backendless.data.of("department").find().then((department) {
    print(department);
Iterable I = department;
setState(() {
  depts= I.map((dept) => 
   Department.fromJson(dept)).toList();
  
});

  });

  future.dismiss();
}
fetch_levels() async{
  var future = await showLoadingDialog();

 FirebaseFirestore firestore = FirebaseFirestore.instance;


var level=    firestore.collection('level');



var fetchedLevel  =  await level.get();

Iterable I = fetchedLevel.docs;
print('dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');
setState(() {
  
  levels =   I.map((e) => Level.fromJson(e.data()) ).toList();
  
});


for (var item in fetchedLevel.docs) {
  print(item.data());

}

//  Backendless.data.of("department").find().then((department) {
//     print(department);


// Iterable I = department;
// setState(() {
//   depts= I.map((dept) => 
//    Department.fromJson(dept)).toList();
  
// });

//   });



 



future.dismiss();
}


@override
void initState() { 
  super.initState();
  

  BackendlessServer();
FirebaseInit.initFirebase();
fetch_levels();

//fetch_depts();
getDepts();

}
getDepts() async{

  FirebaseFirestore firestore = FirebaseFirestore.instance;


var level=    firestore.collection('depts');



var departs  =  await level.get();
print('////////////////////////////////////');

Iterable I = departs.docs;

setState(() {
  // depts= I.map((dept) => 

  //  Department.fromJson(dept)).toList();
  depts =   I.map((e) => Department.fromJson(e.data()) ).toList();
  
});
print(departs.runtimeType);

for (var item in departs.docs) {
  print(item.data());

}



}
GlobalKey _state = new GlobalKey<ScaffoldState>();

String profile;
String first_name;
String last_name;
String id_number;


bool _progressLevel = false;
int _level=0;

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
          child: BlocProvider<RegistertionFormBloc>(
            create: (context) =>
          RegistertionFormBloc(),
                      child: Builder(
 builder: (context) {
          final formBloc = BlocProvider.of<RegistertionFormBloc>(context);

                                         return Scaffold(
              resizeToAvoidBottomPadding: false,
        appBar: AppBar(title:Text('New Student')  ,  centerTitle: true,),
              body: FormBlocListener<RegistertionFormBloc, String, String>(

              //    onSubmitting: (context, state) => LoadingDialog.show(context),
              // onSuccess: (context, state) {
              //   LoadingDialog.hide(context);
              //   Navigator.of(context).pushReplacementNamed('success');
              // },
              // onFailure: (context, state) {
              //   LoadingDialog.hide(context);
              //   Notifications.showSnackBarWithError(
              //       context, state.failureResponse);
              // },
                              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                   decoration: BoxDecoration(


boxShadow: [
BoxShadow(color:Colors.white24) ,
BoxShadow(color:Colors.white12) ,
BoxShadow(color:Colors.white30) ,

BoxShadow(color:Colors.white12) ,

] ,



                   ),
                    child: Center(
                      
                      child: Column(
                             // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            
                              // Text("New Student",
                              //     style: TextStyle(
                              //       fontSize: 28.0,
                              //       fontWeight: FontWeight.bold,
                              //     )),
                              // SizedBox(height: 30),
                      
                              Container(
                                width: double.maxFinite,
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.grey[300],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: TextFieldBlocBuilder(
                                            textFieldBloc: formBloc.firstNameField,
                                            style: TextStyle(fontSize: 20.0, color: Colors.black),
                                            obscureText: false,
                                            onChanged: (str) => this.first_name=str,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "First Name",
                                              prefixIcon: Icon(FontAwesomeIcons.user)
                                              // fillColor: Colors.green
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.grey[300],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: TextFieldBlocBuilder(
                      textFieldBloc: formBloc.lastNameField ,
                                            style: TextStyle(fontSize: 20.0, color: Colors.black),
                                            obscureText: false,
                                             onChanged: (str) => this.last_name=str,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Last Name",
                                               prefixIcon: Icon(FontAwesomeIcons.user)
                                              // fillColor: Colors.green
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[300],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: TextFieldBlocBuilder(
                                     textFieldBloc: formBloc.emailField,
                                   keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                                    obscureText: false,
                                     onChanged: (str) => this.email=str,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter Email ",
                                       prefixIcon: Icon(Icons.email),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[300],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: TextFieldBlocBuilder(
                                textFieldBloc: formBloc.passwordField,
                                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                                    obscureText: true,
                                     onChanged: (str) => this.password=str,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      prefixIcon: Icon(Icons.lock)
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[300],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child:  TextFieldBlocBuilder(
                      textFieldBloc: formBloc.idNumberField,
                                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                                    onChanged: (str) => this.id_number=str,
                                    keyboardType: TextInputType.number,
                                    
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "ID Number الرقم الجامعي",
                                      prefixIcon: Icon(FontAwesomeIcons.university)
                                    ),
                                  ),
                                ),
                              ),

 SizedBox(
                                height: 10,
                              ),



                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[300],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Row(
                                    children:[
Text('choose your department') ,
 Container(
                            
                              ),
                              new DropdownButton<Department>(
                                value: dept,
                                items: depts.map((dept){
return DropdownMenuItem<Department>(
  
  value: dept,
  child: Text(dept.name),);
                                }).toList(),
                                onChanged: (newValue){
                                  setState(() {
                                    dept=newValue;
                                  });
                                },
                              )


                                    ]
                                  )


                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),


                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[300],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Row(
                                    children:[
Text('choose your level') ,
 Container(
                            
                              ),
                              new DropdownButton<Level>(
                                value: level,
                                items: levels.map((level){
return DropdownMenuItem<Level>(
  
  value: level,
  child: Text(level.name),);
                                }).toList(),
                                onChanged: (newValue){
                                  setState(() {
                                    level=newValue;
                                  });
                                },
                              )


                                    ]
                                  )


                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 250,
                                child: RaisedButton(
                                  color: Colors.black,
                                  onPressed: () async {

final valid = await usernameCheck();
    if (!valid) {
     print('try another id number');
     
    }
    else  {
await addStudent();


Navigator.of(context).push(MaterialPageRoute(builder: (_)=>CompleteReg(

first_name:this.first_name ,
last_name:this.last_name ,
id_number: this.id_number ,
 email:  this.email ,
 password: this.password ,
dept: this.dept ,
level : this.level

))

);

    }



                                  },
                                  child: Text(
                                    "Next",
                                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                                  ),
                                ),
                              ),
                            ]),
                    ),
                  ),
                ),
              ),
      );

 }
                      ),
          ),
    );
        
     
    
  }

  addStudent()  async{
  var future = await showLoadingDialog();
    CollectionReference student = FirebaseFirestore.instance.collection('student');






  student
  .doc(this.id_number)
          .set({
            'name': this.first_name + "" + this.last_name, // John Doe
            'dept': this.dept.toJson() , // Stokes and Sons
            'level': this.level.toJson()  ,
            "email" : this.email ,
            "password" : this.password ,
            "id_number": this.id_number ,

             // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

  }

Future<bool> usernameCheck() async {
    final result = await FirebaseFirestore.instance
        .collection('student')
        .where('id_number', isEqualTo: this.id_number)
        .get();
    return result.docs.isEmpty;
  }

}