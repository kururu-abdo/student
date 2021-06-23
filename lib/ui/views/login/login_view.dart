import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:student_side/app/services_provider.dart';
import 'package:student_side/ui/views/home/home_screen.dart';
import 'package:student_side/ui/views/registeration/regiteration_screen.dart';
import 'package:student_side/ui/views/widgets/loader.dart';
import 'package:student_side/util/check_internet.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/firebase_init.dart';
import 'package:student_side/util/ui/app_colors.dart';
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
    var service_provider = Provider.of<ServiceProvider>(context);
    return SafeArea(
      child: BlocProvider(
        create: (context) => LoginFormBloc(),
        child: Builder(
          builder: (context) {
            final formBloc = BlocProvider.of<LoginFormBloc>(context);

            return Scaffold(
              backgroundColor: AppColors.primaryColor,
              resizeToAvoidBottomInset: false,
              body: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      // SvgPicture.asset(
                      //   'assets/images/main.svg',
                      //   semanticsLabel: 'Acme Logo',
                      //   height: 100,
                      // ),

                      Image.asset( 
                        'assets/images/ic_login.png',
                        height: 100,),
                      SizedBox(
                        height: 10,
                      ),
                      Text('قم بتسجيل الدخول للمتابعة',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      FormBlocListener<LoginFormBloc, String, String>(
                          child: Container(
                        child: Column(
                          children: <Widget>[
                            TextFieldBlocBuilder(
                              textFieldBloc: formBloc.idNumberField,
                              keyboardType: TextInputType.number,
                              onChanged: (str) => idController.text = str,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                fillColor: Colors.grey[300],
                                labelText: 'Id number الرقم الجامعي',
                                prefixIcon: Icon(FontAwesomeIcons.university),
                              ),
                            ),
                            TextFieldBlocBuilder(
                              textFieldBloc: formBloc.passwordField,
                              suffixButton: SuffixButton.obscureText,
                              onChanged: (str) => passwordController.text = str,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                fillColor: Colors.grey[300],
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            MaterialButton(
                                minWidth: 200,
                                height: 50,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(50),
                                        right: Radius.circular(50))),
                                color: AppColors.secondaryColor,
                                onPressed: () async {
                                 
                                  if (await isConnectec()) {
                           
                                    await tryLogin(idController.text,
                                        passwordController.text);


                                     
                                  } else {
                                    debugPrint("statement");
                                    Fluttertoast.showToast(
                                        msg: "تأكد من اتصال البيانات 😠",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    'دخول',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor),
                                  ),
                                )),
                          ],
                        ),
                      )),
                      SizedBox(
                        height: 5.0,
                      ),
                      Center(
                        child: Row(
                          children: [
                            Text(
                              'ليس لديك حساب؟',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 190, 184, 252),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) {
                                  return RegisterationView();
                                }));
                              },
                              child: Text('قم بالتسجيل ',
                                  style: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }

  tryLogin(String idNumber, String password) async {
    //var future = await showLoadingDialog();
      LoadingDialog.show(context);
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('student')
        .where('password', isEqualTo: password)
        .where('id_number', isEqualTo: idNumber)
        .get();

    if (data.size > 0) {
      print(data.docs.first.data());
      //future.dismiss();
      await getStorage.write('student', json.encode(data.docs.first.data()));
       LoadingDialog.hide(context);
      await getStorage.write('islogged', true);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => Material(child: HomeView())));
      print('login done');
    } else {
        LoadingDialog.hide(context);
      Get.defaultDialog(
          title: 'فشل تسجيل الدخول',
          content: Text('حاول مرة أخرى'),
          buttonColor: Colors.blue,
          actions: [
            RaisedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('حسنا'),
            ),
          ]);
    }

 //   future.dismiss();
  }
}
