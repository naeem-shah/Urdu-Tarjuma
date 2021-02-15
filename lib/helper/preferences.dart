import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static SharedPreferences _preferences;

  static Future<void> initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String getString({@required String key}){

    return _preferences.getString(key);
  }

  static bool getbool({@required String key}){
    return _preferences.getBool(key);
  }

  static void setString({@required String key,@required String value}){
    _preferences.setString(key, value);
  }

  static void setBool({@required String key,@required bool value}){
    _preferences.setBool(key, value);
  }

}