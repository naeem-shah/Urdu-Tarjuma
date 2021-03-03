import 'package:flutter/material.dart';

class CustomThemes {

  static ThemeData primaryTheme = ThemeData(primarySwatch: MaterialColor(0xff006f44, {
  50:Color.fromRGBO(229,255,255, .1),
  100:Color.fromRGBO(204,255,255, .2),
  200:Color.fromRGBO(179,255,247, .3),
  300:Color.fromRGBO(153,255,221, .4),
  400:Color.fromRGBO(127,238,195, .5),
  500:Color.fromRGBO(102,213,170, .6),
  600:Color.fromRGBO(77,188,145, .7),
  700:Color.fromRGBO(51,162,119, .8),
  800:Color.fromRGBO(26,137,94, .9),
  900:Color.fromRGBO(0,111,68, 1),
  }));
  static ThemeData darkTheme = ThemeData.dark();
}