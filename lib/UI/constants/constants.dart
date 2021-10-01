import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

Color kMyPrimaryColor = Color(0xFFffffff);
Color kBackgroundColor = Color(0xFFED686E);
Color kErrorColor = Colors.red;
Color kDarkModeColor = Color(0xFF292826);
Color kAppBarDarkColor = Color(0xFF383632);
int kDarkModeInt = 0xFF292826;

bool kIsDark = false;
bool isNotFirst = false;

String kIcon = 'images/icon.png';

bool isRTL(String str) {
  return Bidi.detectRtlDirectionality(str);
}

Future<bool?> kToast(String msg, {bool isSuccess = true}) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: isSuccess ? Colors.green.withOpacity(0.8) : Colors.red,
      textColor: Colors.white,
      fontSize: 14);
}

navigateTo(context, widget) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));

navigateAndRemove(context, widget) => Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => widget), (route) => false);

List<int> kColorPickerList = [
  0xFFffffff,
  0xFFfbffb3,
  0xFFcff9fc,
  0xFFffddc7,
  0xFFffbad1,
  0xFFffc4bd,
  0xFFdbc7ff,
  0xFFc9ffcc,
  0xFFb1b8de,
  0xFFc9adc4
];
