import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarjumaquran/Constants/Constants.dart';
import 'package:tarjumaquran/Database/DatabaseManager.dart';
import 'package:tarjumaquran/Utilities/utilities.dart';
import 'package:tarjumaquran/models/AyatModel.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../QuranData/QuranInfo.dart';

class SurahDetailList extends StatefulWidget {
  final int? surahId;
  final String? title;
  final int? scroll;

  const SurahDetailList({this.surahId, this.title, this.scroll});

  @override
  _SurahDetailListState createState() =>
      _SurahDetailListState(surahId, title, scroll);
}

class _SurahDetailListState extends State<SurahDetailList> {
  DbManager dbManager = DbManager();
  late SharedPreferences preferences;

  final ItemScrollController itemScrollController = ItemScrollController();

  double arabicFont = 24.0;
  double translationFont = 18.0;

  List<AyatModel> aayatList = [];

  final int? surahId;
  final String? title;
  final int? scroll;
  int? currentItem;

  int lastVisible = 1;

  _SurahDetailListState(this.surahId, this.title, this.scroll);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onBackPress();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            title!,
            style: const TextStyle(
              fontFamily: "NooreHuda",
            ),
          ),
          actions: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 70,
                  child: DropdownButtonFormField(
                    value: currentItem,
                    dropdownColor: Get.theme.primaryColor,
                    style: const TextStyle(color: Colors.white),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    onChanged: (int? value) {
                      itemScrollController.jumpTo(index: value!);
                      setState(() {
                        currentItem = value;
                      });
                    },
                    items: List.generate(
                        aayatList.isNotEmpty
                            ? aayatList.length - 1
                            : aayatList.length,
                        (int index) => DropdownMenuItem(
                              child: Text("${index + 1}",),
                              value: index + 1,
                            )),
                    decoration: const InputDecoration(
                      hintText: "آیت نمبر",
                      border: InputBorder.none,
                      hintStyle:
                          TextStyle(fontFamily: "Jameel", color: Colors.white),
                      isCollapsed: true
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          child: aayatList.isNotEmpty
              ? ScrollablePositionedList.builder(
                itemCount: aayatList.length,
                itemScrollController: itemScrollController,
                itemBuilder: (_, int index) => VisibilityDetector(
                    onVisibilityChanged: (VisibilityInfo info) {
                      if (info.visibleFraction == 1){
                        lastVisible = index;
                      }
                    },
                    key: Key(index.toString()),
                    child: makeListView(index)
                ),
              )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    updateUi();
  }

  void updateUi() async {
    var list = await dbManager.getSurah(Constants.SURAT_ID, surahId);

    setState(() {
      aayatList = list;
    });

    if (scroll != null) {
      Future.delayed(const Duration(milliseconds: 100),(){
        itemScrollController.jumpTo(index: scroll!);
      });
    }

    preferences = await SharedPreferences.getInstance();
    preferences.setBool(Constants.IS_FIRST, false);
    arabicFont = preferences.getDouble(Constants.ARABIC_FONT) ?? 24.0;
    translationFont = preferences.getDouble(Constants.TRANSLATION_FONT) ?? 18.0;
  }

  bool onBackPress() {
    preferences.setInt(Constants.SCROLL_POSITION, lastVisible);
    preferences.setInt(Constants.ID, surahId!);
    preferences.setString(Constants.SET, Constants.SURAH);

    return true;
  }

  Widget makeListView(int index) {
    AyatModel ayatModel = aayatList[index];

    IconData favourite = ayatModel.isFavourite! ? Icons.star : Icons.star_border;
    String ayatNo = ayatModel.ayatNo == "0"
        ? 'سورۃ $title'
        : "آیت نمبر (" + ayatModel.ayatNo! + ")";

    return Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: MediaQuery.of(context).size.width,
              child: Text(
                ayatModel.ayat!,
                style: TextStyle(fontFamily: "NooreHuda", fontSize: arabicFont),
                textDirection: TextDirection.rtl,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: MediaQuery.of(context).size.width,
              child: Text(
                ayatModel.translation!,
                style: TextStyle(
                    fontFamily: "Jameel",
                    fontSize: translationFont,
                    height: 1.5),
                textDirection: TextDirection.rtl,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 16),
                      child: Text(
                        ayatNo,
                        style: const TextStyle(
                            fontFamily: "Jameel",
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(

                        onPressed: () async {
                          if (favourite == Icons.star) {
                            setState(() {
                              ayatModel.isFavourite = false;
                            });
                            int result = await dbManager.update(ayatModel);
                            if (result != 0) {
                              Utilities.showMessage(
                                  message: "Bookmark Removed");
                            }
                          } else {
                            setState(() {
                              ayatModel.isFavourite = true;
                            });

                            int result = await dbManager.update(ayatModel);

                            if (result != 0) {
                              Utilities.showMessage(message: "Bookmark Added");
                            }
                          }
                        },
                        icon: Icon(favourite),
                        label: const SizedBox.shrink()),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(

                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: ayatModel.ayat! +
                                  "\n" +
                                  ayatModel.translation!));
                          Utilities.showMessage(message: "Copied to Clipboard");
                        },
                        icon: const Icon(Icons.content_copy),
                        label: const SizedBox.shrink()),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(

                        onPressed: () {
                          Share.share(
                              ayatModel.ayat! + "\n" + ayatModel.translation!);
                        },
                        icon: const Icon(Icons.share),
                        label: const SizedBox.shrink()),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class ParahDetailList extends StatefulWidget {
  final int? juzId;
  final bool? isSurah;
  final String? title;
  final int? scroll;

  const ParahDetailList({this.juzId, this.isSurah, this.title, this.scroll});

  @override
  _ParahDetailListState createState() =>
      _ParahDetailListState(juzId, isSurah, title, scroll);
}

class _ParahDetailListState extends State<ParahDetailList> {
  DbManager dbManager = DbManager();
  late SharedPreferences preferences;

  double arabicFont = 24.0;
  double translationFont = 18.0;

  final ItemScrollController itemScrollController = ItemScrollController();


  List<AyatModel> aayatList = [];

  final int? juzId;
  final bool? isSurah;
  final String? title;
  final int? scroll;
  int? currentItem;
  late int lastVisible;

  _ParahDetailListState(this.juzId, this.isSurah, this.title, this.scroll);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onBackPress();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              title!,
              style: const TextStyle(
                fontFamily: "NooreHuda",
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: aayatList.isNotEmpty
                ? ScrollablePositionedList.builder(
                    itemCount: aayatList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        VisibilityDetector(
                            onVisibilityChanged: (VisibilityInfo info) {
                              if (info.visibleFraction == 1) {
                                lastVisible = index;
                              }
                            },
                            key: Key(index.toString()),
                            child: makeListView(context, index)),
              itemScrollController: itemScrollController,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    updateUi();
  }

  void updateUi() async {
    var list = await dbManager.getSurah(Constants.PARAH, juzId);

    setState(() {
      aayatList.addAll(list);
    });

    if (scroll != null) {
      Future.delayed(const Duration(milliseconds: 100),(){
        itemScrollController.jumpTo(index: scroll!);
      });
    }

    preferences = await SharedPreferences.getInstance();
    arabicFont = preferences.getDouble(Constants.ARABIC_FONT) ?? 24.0;
    translationFont = preferences.getDouble(Constants.TRANSLATION_FONT) ?? 18.0;
  }

  bool onBackPress() {
    preferences.setInt(Constants.SCROLL_POSITION, lastVisible);
    preferences.setInt(Constants.ID, juzId!);
    preferences.setString(Constants.SET, Constants.PARAH);

    return true;
  }

  Widget makeListView(BuildContext context, int index) {
    AyatModel ayatModel = aayatList[index];
    String? surah = QuranInfo.surahInfo[ayatModel.suratId!].urduName;
    IconData favourite = ayatModel.isFavourite! ? Icons.star : Icons.star_border;
    String ayatNo = ayatModel.ayatNo == "0"
        ? 'سورۃ $surah'
        : surah! + " : " + ayatModel.ayatNo!;

    return Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: MediaQuery.of(context).size.width,
              child: Text(
                ayatModel.ayat!,
                style: TextStyle(fontFamily: "NooreHuda", fontSize: arabicFont),
                textDirection: TextDirection.rtl,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: MediaQuery.of(context).size.width,
              child: Text(
                ayatModel.translation!,
                style: TextStyle(
                    fontFamily: "Jameel",
                    fontSize: translationFont,
                    height: 1.5),
                textDirection: TextDirection.rtl,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 16),
                      child: Text(
                        ayatNo,
                        style: const TextStyle(
                            fontFamily: "Jameel",
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(

                        onPressed: () async {
                          if (favourite == Icons.star) {
                            setState(() {
                              ayatModel.isFavourite = false;
                            });
                            int result = await dbManager.update(ayatModel);
                            if (result != 0) {
                              Utilities.showMessage(
                                  message: "Bookmark Removed");
                            }
                          } else {
                            setState(() {
                              ayatModel.isFavourite = true;
                            });

                            int result = await dbManager.update(ayatModel);

                            if (result != 0) {
                              Utilities.showMessage(message: "Bookmark Added");
                            }
                          }
                        },
                        icon: Icon(favourite),
                        label: const SizedBox.shrink()),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: ayatModel.ayat! +
                                  "\n" +
                                  ayatModel.translation!));
                          Utilities.showMessage(message: "Copied to Clipboard");
                        },
                        icon: const Icon(Icons.content_copy),
                        label: const SizedBox.shrink()),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(

                        onPressed: () {
                          Share.share(
                              ayatModel.ayat! + "\n" + ayatModel.translation!);
                        },
                        icon: const Icon(Icons.share),
                        label: const SizedBox.shrink()),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
