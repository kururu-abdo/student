import 'package:flutter/material.dart';

class AnimContainer extends ChangeNotifier {
  var _rotateY = 0.0;
  double xOffset = 0.0;
  double yOffset = 0.0;
  double scaleFactore = 1.0;

  double get rotateY => _rotateY;
  changeValues(x, y, s) {
    xOffset = x;
    yOffset = y;
    scaleFactore = s;
    notifyListeners();
  }

  void changeRotation(double value) {
    _rotateY = value;
    notifyListeners();
  }
}
