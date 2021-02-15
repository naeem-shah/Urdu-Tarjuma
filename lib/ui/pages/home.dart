
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarjumaquran/Constants/Constants.dart';
import 'package:tarjumaquran/Database/DatabaseManager.dart';
import 'package:tarjumaquran/QuranData/QuranInfo.dart';
import 'package:tarjumaquran/Utilities/utilities.dart';
import 'package:tarjumaquran/ui/widget/home_listview_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'surah_details.dart';
import 'book_marks.dart';
import 'search.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences preferences;

  DbManager dbManager;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: new Text(
                  "اردو آسان ترجمہ",
                  style: TextStyle(
                      fontFamily: "Jameel", fontWeight: FontWeight.w500),
                ),
                pinned: true,
                floating: true,
                bottom: new TabBar(
                  tabs: <Tab>[
                    new Tab(
                      child: Text(
                        "سورتیں",
                        style: TextStyle(
                            fontFamily: "Jameel",
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    new Tab(
                      child: Text(
                        "پارے",
                        style: TextStyle(
                            fontFamily: "Jameel",
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                      tooltip: "Search",
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Route route = new MaterialPageRoute(
                            builder: (context) => Search());
                        Navigator.push(context, route);
                      }),
                  PopupMenuButton<String>(
                      onSelected: choiceAction,
                      itemBuilder: (BuildContext context) {
                        return Constants.actions.map((MyActions choice) {
                          return PopupMenuItem<String>(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  choice.action,
                                  style: TextStyle(fontFamily: "Jameel"),
                                ),
                                Icon(
                                  choice.icon,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            value: choice.action,
                          );
                        }).toList();
                      },
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              ),
            ];
          },
          body: new TabBarView(
            children: <Widget>[
              HomeListView(QuranInfo.surahInfo, Constants.SURAH),
              HomeListView(QuranInfo.juzInfo, Constants.PARAH),
            ],
          ),
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.BOOKMARK) {
      Get.to(() =>Bookmarks());
    } else if (choice == Constants.COPY_LINK) {
      Clipboard.setData(new ClipboardData(text: Constants.APP_LINK));
      Utilities.showMessage(message: "Copied to Clipboard");
    } else if (choice == Constants.FEEDBACK) {
      LaunchReview.launch(androidAppId: Constants.APP_ID);
    } else if (choice == Constants.EMAIL_DEVELOPER) {
      showEmailDialog();
    } else if (choice == Constants.SHARE_APP) {
      String message =
          "Recite Quran and Urdu Translation with this beautiful App - Install this Application from following Play Store Link: \n\n" +
              Constants.APP_LINK;
      Share.share(message);
    } else if (choice == Constants.SETTINGS) {
      Get.to(() =>Settings());
    }
  }

  showEmailDialog() {
    final nameController = new TextEditingController();
    final messageController = new TextEditingController();

    bool nameValidate = false;
    bool messageValidate = false;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => new AlertDialog(
          title: Text(
            "اپنا پیغام لکھیں",
            style: TextStyle(fontFamily: "Jameel"),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: nameController,
                    onChanged: (text) {
                      if (text.trim().isNotEmpty)
                        setState(() {
                          nameValidate = false;
                        });
                    },
                    style: TextStyle(fontFamily: "Jameel", fontSize: 18),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "نام",
                      errorStyle: TextStyle(fontFamily: "Jameel", fontSize: 16),
                      errorText:
                      nameValidate ? "برائے مہربانی نام لکھیں" : null,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontFamily: "Jameel", fontSize: 18),
                    textInputAction: TextInputAction.send,
                    minLines: 3,
                    maxLines: 4,
                    onChanged: (text) {
                      if (text.trim().isNotEmpty) {
                        setState(() {
                          messageValidate = false;
                        });
                      }
                    },
                    controller: messageController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "پیغام",
                      errorStyle: TextStyle(fontFamily: "Jameel", fontSize: 16),
                      errorText:
                      messageValidate ? "برائے مہربانی پیغام لکھیں" : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          contentPadding:
          const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 0),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                String name = nameController.text.trim().toString();
                String message = messageController.text.trim().toString();
                if (name.isEmpty) {
                  setState(() {
                    nameValidate = true;
                  });
                  return;
                }

                if (message.isEmpty) {
                  setState(() {
                    messageValidate = true;
                  });
                  return;
                }
                Get.focusScope.unfocus();
                mailTo(name, message);
              },
              child: Text(
                "ارسال کریں",
                style: TextStyle(fontFamily: "Jameel"),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "مسخ کریں",
                style: TextStyle(fontFamily: "Jameel"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void mailTo(String name, String message) async {
    var url = 'mailto:${Constants.MY_EMAIL}?subject=$name&body=$message';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    dbManager = new DbManager();
    dbManager.initializeDatabase();
    _showDialog();
  }

  _showDialog() async {
    preferences = await SharedPreferences.getInstance();


    bool isLastRead = preferences.getBool(Constants.LAST_READ) ?? true;
    if (!isLastRead){
      return;
    }

    bool isFirstTime = preferences.getBool(Constants.IS_FIRST) ?? true;
    int scrollPosition = preferences.getInt(Constants.SCROLL_POSITION);
    int id = preferences.getInt(Constants.ID) ?? 1;
    String set = preferences.getString(Constants.SET);

    if (scrollPosition == 0) {
      scrollPosition = 1;
    }
    if (!isFirstTime) {
      String surahName = QuranInfo.surahInfo[id - 1].urduName;
      String parahName = "";

      String message = 'سورہ ' + surahName + " آیت نمبر " + '$scrollPosition';

      if (set == Constants.PARAH) {
        parahName = QuranInfo.juzInfo[id - 1].urduName;
        message = parahName;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'آپ مطالعہ فرما رہے تھے',
            style: TextStyle(fontFamily: "Jameel"),
          ),
          content: Text(
            message,
            style: TextStyle(fontFamily: "Jameel"),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  if (set == Constants.PARAH) {
                    Get.off(ParahDetailList(
                      title: parahName,
                      scroll: scrollPosition,
                      juzId: id,
                    ));
                  } else {
                    Get.off(SurahDetailList(
                      title: surahName,
                      scroll: scrollPosition,
                      surahId: id,
                    ));
                  }
                },
                child:
                Text("شروع کریں", style: TextStyle(fontFamily: "Jameel"))),
            FlatButton(
                onPressed: () {
                  Get.back();
                },
                child:
                Text("ختم کریں", style: TextStyle(fontFamily: "Jameel"))),
          ],
        ),
      );
    }
  }
}