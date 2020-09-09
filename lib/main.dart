import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarjumaquran/Bookmark.dart';
import 'package:tarjumaquran/Constants/Constants.dart';
import 'package:tarjumaquran/Settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AyatDetail.dart';
import 'Database/DatabaseManager.dart';
import 'QuranData/QuranInfo.dart';
import 'Search.dart';
import 'Utilities/Utilities.dart';

void main() =>
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        );
      },
      home: Dashboard(),
    )
);

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  SharedPreferences preferences;

  DbManager dbManager = new DbManager();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
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
                      })
                ],
              ),
            ];
          },
          body: new TabBarView(
            children: <Widget>[
              IndexListView(QuranInfo.surahInfo, Constants.SURAH),
              IndexListView(QuranInfo.juzInfo, Constants.PARAH),
            ],
          ),
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.BOOKMARK) {
      Route route = new MaterialPageRoute(builder: (context) => Bookmarks());
      Navigator.push(context, route);
    } else if (choice == Constants.COPY_LINK) {
      Clipboard.setData(new ClipboardData(text: Constants.APP_LINK));
      Utilities.showMessage(message: "Copied to Clipboard");
    } else if (choice == Constants.FEEDBACK) {
      LaunchReview.launch(androidAppId: Constants.APP_ID);
    } else if (choice == Constants.EMAIL_DEVELOPER) {
      showEmailDialog();
    } else if (choice == Constants.SHARE_APP) {
      String message =
          "Recite Quran and Urdu Translation with this Beautifull App - Install this Application from following Play Store Link: \n\n" +
              Constants.APP_LINK;
      Share.share(message);
    } else if (choice == Constants.SETTINGS) {
      Route route = new MaterialPageRoute(builder: (context) => Settings());
      Navigator.push(context, route);
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
                      fillColor: Colors.grey.shade200,
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
                      fillColor: Colors.grey.shade200,
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
                FocusScope.of(context).requestFocus(FocusNode());
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
    int id = preferences.getInt(Constants.ID);
    String set = preferences.getString(Constants.SET);

    print("FirstTime " + isFirstTime.toString());
    print("Scroll " + scrollPosition.toString());
    print("Surah " + id.toString());

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
                    Route route = new MaterialPageRoute(
                        builder: (context) => ParahDetailList(
                              title: parahName,
                              scroll: scrollPosition,
                              juzId: id,
                            ));
                    Navigator.pushReplacement(context, route);
                  } else {
                    Route route = new MaterialPageRoute(
                        builder: (context) => SurahDetailList(
                              title: surahName,
                              scroll: scrollPosition,
                              surahId: id,
                            ));
                    Navigator.pushReplacement(context, route);
                  }
                },
                child:
                    Text("شروع کریں", style: TextStyle(fontFamily: "Jameel"))),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                    Text("ختم کریں", style: TextStyle(fontFamily: "Jameel"))),
          ],
        ),
      );
    }
  }
}

class IndexListView extends StatefulWidget {
  final List<Info> infoList;
  final String set;

  IndexListView(this.infoList, this.set);

  @override
  _IndexListViewState createState() =>
      _IndexListViewState(this.set);
}

class _IndexListViewState extends State<IndexListView> {
  List<Info> infoList = [];
  final String set;

  _IndexListViewState(this.set);

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        set == Constants.SURAH
            ? Padding(
                padding:
                    const EdgeInsets.only(bottom: 4, top: 8, left: 8, right: 8),
                child: TextField(
                  autofocus: false,
                  controller: nameController,
                  style: TextStyle(fontFamily: "Jameel", fontSize: 18),
                  textInputAction: TextInputAction.search,
                  onChanged: (String text) {
                    filter(text);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'سورت تلاش کریں',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              )
            : SizedBox(height: 4,),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: infoList.length,
            itemBuilder: (BuildContext context, int index) =>
                makeList(context, index),
          ),
        ),
      ],
    );
  }


  @override
  void initState() {
    super.initState();
    infoList.addAll(widget.infoList);
  }

  Widget makeList(BuildContext context, int index) {
    Info info = infoList[index];
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (set == Constants.PARAH) {
              Route route = MaterialPageRoute(
                  builder: (context) => ParahDetailList(
                        juzId: info.id,
                        title: info.urduName,
                      ));
              Navigator.push(context, route);
            } else {
              Route route = MaterialPageRoute(
                  builder: (context) => SurahDetailList(
                        surahId: info.id,
                        title: info.urduName,
                      ));
              Navigator.push(context, route);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    info.urduName,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontFamily: "NooreHuda", fontSize: 22),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      info.engName,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    info.id.toString(),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void filter(String query) {
    if (query.isNotEmpty) {
      List<Info> dummySearchList = List<Info>();
      dummySearchList.addAll(QuranInfo.surahInfo);
      List<Info> dummyListData = List<Info>();
      dummySearchList.forEach((item) {
        int id = item.id;
        String eng = item.engName.toLowerCase();
        String urdu = item.urduName;
        if (id.toString().contains(query) ||
            eng.contains(query.toLowerCase()) ||
            urdu.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        infoList.clear();
        infoList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        infoList.clear();
        infoList.addAll(QuranInfo.surahInfo);
      });
    }
  }
}
