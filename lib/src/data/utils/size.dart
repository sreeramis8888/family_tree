<<<<<<< HEAD
import 'package:flutter/material.dart';

class ScreenSize {
  static double getBottomInset(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
=======
import 'package:flutter/material.dart';

class ScreenSize {
  static double getBottomInset(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
}