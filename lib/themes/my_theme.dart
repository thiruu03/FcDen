import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  snackBarTheme: SnackBarThemeData(
      backgroundColor: Color.fromRGBO(190, 40, 40, 1),
      actionTextColor: Colors.white,
      contentTextStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 21, fontFamily: 'montserrat'),
      showCloseIcon: true),
  fontFamily: 'montserrat',
  colorScheme: ColorScheme.light(
    primary: Color.fromRGBO(190, 40, 40, 1),
    secondary: Color.fromRGBO(255, 160, 0, 1),
  ),
);
