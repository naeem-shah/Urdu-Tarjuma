import 'package:flutter/material.dart';

class Constants{
  static const DB_NAME = "tafseer.db";

  static const BOOK_MARK = "BookMarks";
  static const DATA = "Data";


  static const ID = "_id";
  static const SURAT_ID = "surat_id";
  static const AYAT_NO = "aayat_number";
  static const AYAT = "quran";
  static const AYAT_SIMPLE = "simple_quran";
  static const TRANSLATION = "translation";
  static const PARAH = "parah";
  static const REFERENCE = "reference";
  static const IS_Favourite = "isFavourite";

  static const SURAH = "surah";

  static const LAST_READ = "lastRead";


  static const ARABIC_FONT = "arabicFont";
  static const TRANSLATION_FONT = "TranslationFont";


  static const SET = "set";
  static const isDark = "isDark";


  static const BOOKMARK = "بک مارک";
  static const FEEDBACK = "فیڈ بیک";
  static const SHARE_APP = "شئیر اپلیکیشن";
  static const SETTINGS = "سیٹنگز";
  static const COPY_LINK = "پلے اسٹور لنک";
  static const EMAIL_DEVELOPER = "ای میل ڈویلپر";


  static const APP_LINK = "https://play.google.com/store/apps/details?id=com.naeem.tarjumaquran";
  static const MY_EMAIL = "shahnaeem681@gmail.com";
  static const APP_ID = "com.naeem.tarjumaquran";

  static const SCROLL_POSITION = "scrollPosition";
  static const IS_FIRST = "firstTime";

  static final List<MyActions> actions = [
    MyActions(action: BOOKMARK, icon: Icons.star),
    MyActions(action: SETTINGS, icon: Icons.settings),
    MyActions(action: FEEDBACK, icon: Icons.feedback),
    MyActions(action: SHARE_APP, icon: Icons.share),
    MyActions(action: COPY_LINK, icon: Icons.content_copy),
    MyActions(action: EMAIL_DEVELOPER, icon: Icons.email),
  ];

}

class MyActions{
  String? action;
  IconData? icon;

  MyActions({this.action, this.icon});


}