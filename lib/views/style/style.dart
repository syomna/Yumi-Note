import 'package:flutter/material.dart';
import 'package:simplenote/views/constants/constants.dart';

ThemeData lightMode = ThemeData(
    primarySwatch: Colors.pink,
    fontFamily: 'Cairo',
    iconTheme: IconThemeData(color: Colors.black54),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0.0,
    ));

ThemeData darkMode = ThemeData(
    primarySwatch: Colors.pink,
    fontFamily: 'Cairo',
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.white),
        headline6: TextStyle(color: Colors.white)),
    scaffoldBackgroundColor: kDarkModeColor,
    appBarTheme: AppBarTheme(
      backgroundColor: kAppBarDarkColor,
      elevation: 2.0,
    ));
