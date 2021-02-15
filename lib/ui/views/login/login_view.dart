import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:load/load.dart';
import 'package:student_side/ui/views/home/home_screen.dart';
import 'package:student_side/util/check_internet.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/firebase_init.dart';
import 'login_view_model.dart';
class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
TextEditingController idController = new TextEditingController();

TextEditingController passwordController = new TextEditingController();

  @override
  void initState() { 
    super.initState();
    FirebaseInit.initFirebase();

    
  }
  @override
  Widget build(BuildContext context) {
  return  BlocProvider<LoginFormBloc>(
      create: (context) =>
          LoginFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<LoginFormBloc>(context);

          return Scaffold(
appBar: AppBar( title:Text('Authentication') ,centerTitle: true,),

body: Padding(
  
  padding: EdgeInsets.only(top:10.0),


  
  child: FormBlocListener<LoginFormBloc, String, String>(
              // onSubmitting: (context, state) => LoadingDialog.show(context),
              // onSuccess: (context, state) {
              //   LoadingDialog.hide(context);
              //   Navigator.of(context).pushReplacementNamed('success');
              // },
              // onFailure: (context, state) {
              //   LoadingDialog.hide(context);
              //   Notifications.showSnackBarWithError(
              //       context, state.failureResponse);
              // },
              child: 


              ListView(
                children: <Widget>[
                  TextFieldBlocBuilder(
                    textFieldBloc: formBloc.idNumberField,
                    keyboardType: TextInputType.emailAddress,
                   onChanged: (str) => idController.text=str ,
                    decoration: InputDecoration(
                      labelText: 'Id number الرقم الجامعي',
                      prefixIcon: Icon(FontAwesomeIcons.university),
                    ),
                  ),
                  TextFieldBlocBuilder(
                    textFieldBloc: formBloc.passwordField,
                    suffixButton: SuffixButton.obscureText,
                     onChanged: (str) => passwordController.text=str ,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ), 


                  MaterialButton(
                    color: Colors.green,
                    onPressed:() async{
                      if(await isConnectec()){
                      await tryLogin(idController.text, passwordController.text);

                      }else{
                        debugPrint('check your intern connection');
                      }

                    } , child:Text('login'))

                ],
              )
              ),),


          );
        },
      ),
    );
  }

  tryLogin(String idNumber , String password) async{
      var future = await showLoadingDialog();
  QuerySnapshot data = await   FirebaseFirestore.instance
  .collection('student')
  .where('password' ,isEqualTo :password)
  .where('id_number', isEqualTo: idNumber)
  .get();

  if (data.size>0) {
    print(data.docs.first.data());
    future.dismiss();
    await getStorage.write('student', json.encode(data.docs.first.data()));
    await getStorage.write('islogged', true);
    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>HomeView()));
    print('login done');
  }else{
print('login failed');
  }

future.dismiss();
  }
}