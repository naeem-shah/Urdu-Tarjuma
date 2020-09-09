import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:tarjumaquran/AyatDetail.dart';
import 'package:tarjumaquran/QuranData/QuranInfo.dart';

import 'Database/DatabaseManager.dart';
import 'Models/AyatModel.dart';
import 'Utilities/Utilities.dart';

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  DbManager dbManager = new DbManager();
  List<AyatModel> aayatList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("بک مارک", style: TextStyle(fontFamily: "Jameel"),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        child: aayatList.isNotEmpty ? ListView.builder(
            itemBuilder: (BuildContext context, int index) => makeListView(context, index),
            itemCount: aayatList.length,
        ) : Center(child: Text("آپ نے ابھی تک کوئی بک مارک نہیں لگایا۔", style: TextStyle(fontFamily: 'Jameel', fontSize: 18),),),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    aayatList = List<AyatModel>();
    getBookMars();
  }

  Widget makeListView(BuildContext context, int index) {

    AyatModel ayatModel = aayatList[index];

    String surahName = QuranInfo.surahInfo[ayatModel.suratId-1].urduName;
    String ayatNo = ayatModel.ayatNo == "0" ? 'سورۃ $surahName' : surahName+ " : " +ayatModel.ayatNo;

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: GestureDetector(
        onTap: (){
          Route route = new MaterialPageRoute(builder: (context) => SurahDetailList(surahId: ayatModel.suratId, title: surahName, scroll: int.parse(ayatModel.ayatNo),));
          Navigator.push(context, route);
        },
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  ayatModel.ayat,
                  style: TextStyle(fontFamily: "NooreHuda", fontSize: 24),
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
                  TextStyle(fontFamily: "Jameel", fontSize: 18, height: 1.5),
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
                            Utilities.showMessage(message: "Bookmark Removed");
                            ayatModel.isFavourite = false;
                            await dbManager.update(ayatModel);
                            setState(() {
                              aayatList.removeAt(index);
                            });
                          },
                          icon: Icon(Icons.star),
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
          ),
      ),
    );
  }

  void getBookMars() async{
    var list = await dbManager.getBookmarks();

    setState(() {
      aayatList.addAll(list);
    });
  }
}
