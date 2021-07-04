

import 'package:flutter/material.dart';
import 'package:student_side/ui/views/home/home_screen.dart';

import 'package:student_side/util/constants.dart';


class Login extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';
TextEditingController emailController = new TextEditingController();

TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     
      
        appBar: AppBar(title: Text('Login'),  centerTitle: true,),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
         
            child: Expanded(
                          child: ListView(children: [
                // SizedBox(height: 40),
               
                SizedBox(height: 50),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network('https://th.bing.com/th/id/OIP.3wMJFpWlVPMNerfbxhKJTgHaHa?pid=Api&rs=1', height: 150),
                ),
                SizedBox(height: 50),
                Expanded(
                                child: Padding(

                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      controller: emailController
                      ,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Email',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    obscureText: true,

                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Password',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                RaisedButton(child: Text("Login"), onPressed: () {
List user =users.where((element) {
print(element['user_name']);


 return element['password']==passwordController.text && element['email']==emailController.text;
}).toList();

if(user.length>0){


Navigator.of(context).push(MaterialPageRoute(builder: (_)=>HomeView(user_id:'dkjkfkdjf100998')));


}else{
print('error');
}

                }),
              ]),
            ),
          
        )
      
    );
  }
}