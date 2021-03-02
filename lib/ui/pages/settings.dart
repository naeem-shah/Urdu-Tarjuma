import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarjumaquran/helper/preferences.dart';

import '../../Constants/Constants.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SharedPreferences preferences;
  List<int> arabicFont;
  List<int> translationFont;
  Brightness brightness;

  double currentArabicFont = 20.0;
  double currentTranslationFont = 18.0;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سیٹنگز', style: TextStyle(fontFamily: "Jameel"),),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[

          // arabic
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text("عربی فاؤنٹ", style: TextStyle(fontSize: 20, fontFamily: "Jameel"),),
                ),
                Expanded(
                    child: DropdownButton(
                      value: currentArabicFont.toInt(),
                        isExpanded: true,
                        items: arabicFont.map((e) =>
                            DropdownMenuItem(
                                child: Text(e.toString()),
                              value: e,
                            )
                        ).toList(),
                        onChanged: (int value) {
                          setState(() {
                            currentArabicFont = value.toDouble();
                          });
                          preferences.setDouble(Constants.ARABIC_FONT, value.toDouble());
                        }
                    )
                )
              ],
            ),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَِ', textAlign: TextAlign.center ,style: TextStyle(fontFamily: "NooreHuda", fontSize: currentArabicFont.toDouble()),),
            ),
          ),

          // divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              height: 36,
            ),
          ),

          // tarjuma
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text("ترجمہ فاؤنٹ", style: TextStyle(fontSize: 20, fontFamily: "Jameel"),),
                ),
                Expanded(
                    child: DropdownButton(
                        value: currentTranslationFont.toInt(),
                        isExpanded: true,
                        items: translationFont.map((e) =>
                            DropdownMenuItem(
                              child: Text(e.toString()),
                              value: e,
                            )
                        ).toList(),
                        onChanged: (int value) {
                          setState(() {
                            currentTranslationFont = value.toDouble();
                          });
                          preferences.setDouble(Constants.TRANSLATION_FONT, value.toDouble());
                        }
                    )
                )
              ],
            ),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('سب تعریف اللہ کے لیے ہے جو سارے جہانوں کا پالنے والا ہے۔', textAlign: TextAlign.center ,style: TextStyle(fontFamily: "Jameel", fontSize: currentTranslationFont.toDouble()),),
            ),
          ),

          // divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              height: 36,
            ),
          ),
          // theme
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text("ڈارک موڈ تھیم", style: TextStyle(fontSize: 20, fontFamily: "Jameel"),),
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: (bool isDark) async {
                    print(isDark);
                    if (isDark){
                      Get.changeTheme(ThemeData.dark());
                      isDarkMode = true;
                      Preferences.setBool(key: Constants.isDark, value: true);
                    } else {
                      Get.changeTheme(ThemeData.light());
                      isDarkMode = false;
                      Preferences.setBool(key: Constants.isDark, value: false);
                    }

                    setState(() {

                    });
                  },
                )
              ],
            ),
          ),


        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
    arabicFont = new List<int>();
    translationFont = new List<int>();
    for (int i = 8; i <= 60; i=i+2){
      arabicFont.add(i);
      translationFont.add(i);
    }
  }

  getPreferences () async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      currentArabicFont = preferences.getDouble(Constants.ARABIC_FONT) ?? 24.0;
      currentTranslationFont = preferences.getDouble(Constants.TRANSLATION_FONT) ?? 18.0;
      isDarkMode = Preferences.getbool(key: Constants.isDark) ?? false;
    });
  }

}
