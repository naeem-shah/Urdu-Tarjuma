// List View of Ayat detail
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarjumaquran/Constants/Constants.dart';
import 'package:tarjumaquran/Database/DatabaseManager.dart';
import 'package:tarjumaquran/Models/AyatModel.dart';
import 'package:tarjumaquran/Utilities/Utilities.dart';

import 'QuranData/QuranInfo.dart';

class SurahDetailList extends StatefulWidget {
  final int surahId;
  final String title;
  final int scroll;

  SurahDetailList({this.surahId, this.title, this.scroll});

  @override
  _SurahDetailListState createState() =>
      new _SurahDetailListState(this.surahId, this.title, this.scroll);
}

class _SurahDetailListState extends State<SurahDetailList>{
  DbManager dbManager = new DbManager();
  SharedPreferences preferences;

  double arabicFont = 24.0;
  double translationFont = 18.0;

  final ItemScrollController itemScrollController = new ItemScrollController();
  final ItemPositionsListener itemPositionListener = new ItemPositionsListener.create();

  List<AyatModel> aayatList = [];

  final int surahId;
  final String title;
  final int scroll;
  int currentItem;

  _SurahDetailListState(this.surahId, this.title, this.scroll);

  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);
    return WillPopScope(
      onWillPop: () async {
        return onBackPress();
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              centerTitle: true,
              title: Text(title, style: TextStyle(fontFamily: "NooreHuda",),),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: currentItem,
                        isDense: true,
                        hint: Text(
                          "آیات", style: TextStyle(color: Colors.black),),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
                        items: List.generate(aayatList.isNotEmpty ? aayatList.length-1 : aayatList.length, (int index) =>
                            DropdownMenuItem(
                              child: Text((index+1).toString(), style: TextStyle(
                                  color: Colors.black),),
                              value: index+1,
                            )),
                        onChanged: (int value) {
                          jumpTo(value);
                          setState(() {
                            currentItem = value;
                          });
                        }
                    ),
                  ),
                )
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              child: aayatList.isNotEmpty ? ScrollablePositionedList.builder(
                itemCount: aayatList.length,
                itemBuilder: (BuildContext context, int index) => makeListView(context, index),
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionListener,
              ) : Center(child: CircularProgressIndicator(),),
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

    Future.delayed(Duration(milliseconds: 50), (){

      // for scrolling...
      if (scroll != null){
        jumpTo(scroll);
      }

    });

    preferences = await SharedPreferences.getInstance();
    preferences.setBool(Constants.IS_FIRST, false);
    arabicFont = preferences.getDouble(Constants.ARABIC_FONT) ?? 24.0;
    translationFont = preferences.getDouble(Constants.TRANSLATION_FONT) ?? 18.0;
  }

  void jumpTo(int position) {
    itemScrollController.jumpTo(index: position);

  }

  bool onBackPress() {

    if (itemPositionListener.itemPositions.value.isNotEmpty){
      int mPosition = itemPositionListener.itemPositions.value
          .where((ItemPosition position) => position.itemTrailingEdge > 0)
          .reduce((ItemPosition min, ItemPosition position) => position.itemTrailingEdge < min.itemTrailingEdge ? position : min).index;
      print(mPosition);

      preferences.setInt(Constants.SCROLL_POSITION, mPosition);
      preferences.setInt(Constants.ID, surahId);
      preferences.setString(Constants.SET, Constants.SURAH);
    }


    return true;
  }

  Widget makeListView(BuildContext context, int index) {

    AyatModel ayatModel = aayatList[index];

    IconData favourite = ayatModel.isFavourite ? Icons.star : Icons.star_border;
    String ayatNo = ayatModel.ayatNo == "0" ? 'سورۃ $title' : "آیت نمبر (" +ayatModel.ayatNo+")";

    return Card(
      elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: MediaQuery.of(context).size.width,
              child: Text(
                ayatModel.ayat,
                style: TextStyle(fontFamily: "NooreHuda", fontSize: arabicFont),
                textDirection: TextDirection.rtl,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.shade50,
              child: Text(
                ayatModel.translation,
                style:
                    TextStyle(fontFamily: "Jameel", fontSize: translationFont, height: 1.5),
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
                        style: TextStyle(
                            fontFamily: "Jameel",
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FlatButton.icon(
                        padding: EdgeInsets.all(0),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: () async {
                          if (favourite == Icons.star){
                            setState(() {
                              ayatModel.isFavourite = false;
                            });
                            int result = await dbManager.update(ayatModel);
                            if (result != 0){
                              Utilities.showMessage(message: "Bookmark Removed");
                            }
                          } else {
                            setState(() {
                              ayatModel.isFavourite = true;
                            });

                            int result = await dbManager.update(ayatModel);

                            if (result != 0){
                              Utilities.showMessage(message: "Bookmark Added");
                            }
                          }
                        },
                        icon: Icon(favourite),
                        label: SizedBox.shrink()),
                  ),
                  Expanded(
                    flex: 1,
                    child: FlatButton.icon(
                        padding: EdgeInsets.all(0),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: (){
                          Clipboard.setData(new ClipboardData(text: ayatModel.ayat + "\n" + ayatModel.translation));
                          Utilities.showMessage(message: "Copied to Clipboard");
                        },
                        icon: Icon(Icons.content_copy),
                        label: SizedBox.shrink()),
                  ),
                  Expanded(
                    flex: 1,
                    child: FlatButton.icon(
                        padding: EdgeInsets.all(0),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: (){
                          Share.share(ayatModel.ayat + "\n" + ayatModel.translation);
                        },
                        icon: Icon(Icons.share),
                        label: SizedBox.shrink()),
                  ),

                ],
              ),
            )
          ],
        )
    );
  }
}

class ParahDetailList extends StatefulWidget {
  final int juzId;
  final bool isSurah;
  final String title;
  final int scroll;

  ParahDetailList({this.juzId, this.isSurah, this.title, this.scroll});

  @override
  _ParahDetailListState createState() => _ParahDetailListState(this.juzId, this.isSurah, this.title, this.scroll);
}

class _ParahDetailListState extends State<ParahDetailList> {
  DbManager dbManager = new DbManager();
  SharedPreferences preferences;

  double arabicFont = 24.0;
  double translationFont = 18.0;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionListener = ItemPositionsListener.create();

  List<AyatModel> aayatList = [];

  final int juzId;
  final bool isSurah;
  final String title;
  final int scroll;
  int currentItem;

  _ParahDetailListState(this.juzId, this.isSurah, this.title, this.scroll);
  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);
    return WillPopScope(
      onWillPop: () async {
        return onBackPress();
      },

      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            centerTitle: true,
            title: Text(title, style: TextStyle(fontFamily: "NooreHuda",),),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: aayatList.isNotEmpty ? ScrollablePositionedList.builder(
              itemCount: aayatList.length,
              itemBuilder: (BuildContext context, int index) => makeListView(context, index),
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionListener,
            ) : Center(child: CircularProgressIndicator(),),
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

    Future.delayed(Duration(milliseconds: 100), (){

      // for scrolling...
      if (scroll != null){
        jumpTo(scroll);
      }

    });

    preferences = await SharedPreferences.getInstance();
    preferences.setBool(Constants.IS_FIRST, false);
    arabicFont = preferences.getDouble(Constants.ARABIC_FONT) ?? 24.0;
    translationFont = preferences.getDouble(Constants.TRANSLATION_FONT) ?? 18.0;
  }

  void jumpTo(int position) {
    try{
      itemScrollController.jumpTo(index: position);
    } catch (e){

    }

  }

  bool onBackPress() {

    if (itemPositionListener.itemPositions.value.isNotEmpty){
      int mPosition = itemPositionListener.itemPositions.value
          .where((ItemPosition position) => position.itemTrailingEdge > 0)
          .reduce((ItemPosition min, ItemPosition position) => position.itemTrailingEdge < min.itemTrailingEdge ? position : min).index;
      print(mPosition);

      preferences.setInt(Constants.SCROLL_POSITION, mPosition);
      preferences.setInt(Constants.ID, juzId);
      preferences.setString(Constants.SET, Constants.PARAH);
    }


    return true;
  }

  Widget makeListView(BuildContext context, int index) {

    AyatModel ayatModel = aayatList[index];
    String surah = QuranInfo.surahInfo[ayatModel.suratId].urduName;
    IconData favourite = ayatModel.isFavourite ? Icons.star : Icons.star_border;
    String ayatNo = ayatModel.ayatNo == "0" ? 'سورۃ $surah' : surah+" : " +ayatModel.ayatNo;

    return Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: MediaQuery.of(context).size.width,
              child: Text(
                ayatModel.ayat,
                style: TextStyle(fontFamily: "NooreHuda", fontSize: arabicFont),
                textDirection: TextDirection.rtl,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.shade50,
              child: Text(
                ayatModel.translation,
                style:
                TextStyle(fontFamily: "Jameel", fontSize: translationFont, height: 1.5),
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
                        style: TextStyle(
                            fontFamily: "Jameel",
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FlatButton.icon(
                        padding: EdgeInsets.all(0),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: () async {
                          if (favourite == Icons.star){
                            setState(() {
                              ayatModel.isFavourite = false;
                            });
                            int result = await dbManager.update(ayatModel);
                            if (result != 0){
                              Utilities.showMessage(message: "Bookmark Removed");
                            }
                          } else {
                            setState(() {
                              ayatModel.isFavourite = true;
                            });

                            int result = await dbManager.update(ayatModel);

                            if (result != 0){
                              Utilities.showMessage(message: "Bookmark Added");
                            }
                          }
                        },
                        icon: Icon(favourite),
                        label: SizedBox.shrink()),
                  ),
                  Expanded(
                    flex: 1,
                    child: FlatButton.icon(
                        padding: EdgeInsets.all(0),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: (){
                          Clipboard.setData(new ClipboardData(text: ayatModel.ayat + "\n" + ayatModel.translation));
                          Utilities.showMessage(message: "Copied to Clipboard");
                        },
                        icon: Icon(Icons.content_copy),
                        label: SizedBox.shrink()),
                  ),
                  Expanded(
                    flex: 1,
                    child: FlatButton.icon(
                        padding: EdgeInsets.all(0),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: (){
                          Share.share(ayatModel.ayat + "\n" + ayatModel.translation);
                        },
                        icon: Icon(Icons.share),
                        label: SizedBox.shrink()),
                  ),

                ],
              ),
            )
          ],
        )
    );
  }
}
