import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:student_side/ui/views/logout/logout_view_model.dart';

class LogoutButton extends StatefulWidget {
  LogoutButton({Key key}) : super(key: key);

  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {

  LogoutController logoutController = new LogoutController();
  @override
  Widget build(BuildContext context) {
    return GetX<LogoutController>( builder: (_)=>
    
    MaterialButton(onPressed: () async {  

    // logoutController
    },
minWidth: 30,
  child: Text('تسجيل خروج'),
      ),
    

    );
  }
}