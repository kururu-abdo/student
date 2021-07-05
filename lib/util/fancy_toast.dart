
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class AppToasts{


  static showSuccessToast(BuildContext context ,  String message){
showToastWidget(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        margin: EdgeInsets.symmetric(horizontal: 50.0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.green[600],
        ),
        child: Row(
          children: [
            Text(
             message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
           Icon(
                Icons.done_outline,
                color: Colors.white,
              ),
            
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      position: StyledToastPosition.top,
      context: context,
      isIgnoring: false,
      duration: Duration(seconds: 3),
    );
  }

static showfailToast(BuildContext context ,  String message) {
showToastWidget(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        margin: EdgeInsets.symmetric(horizontal: 50.0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.red[600],
        ),
        child: Row(
          children: [
            Text(
              message,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Icon(
              Icons.done_outline,
              color: Colors.black,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      context: context,
      isIgnoring: false,
      position: StyledToastPosition.top,
      duration: Duration(seconds: 3),
    );

}

}