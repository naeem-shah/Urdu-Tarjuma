import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarjumaquran/Constants/Constants.dart';
import 'package:tarjumaquran/helper/preferences.dart';
import 'package:tarjumaquran/ui/pages/home.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPreferences();
  bool isDark = Preferences.getbool(key: Constants.isDark) ?? false;

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: isDark ? ThemeData.dark() : ThemeData.light(),
    builder: (context, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: child,
      );
    },
    home: HomePage(),
  )
  );
}