import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:tarjumaquran/AyatDetail.dart';
import 'package:tarjumaquran/Constants/Constants.dart';
import 'package:tarjumaquran/Models/AyatModel.dart';
import 'package:tarjumaquran/QuranData/QuranInfo.dart';

import 'Database/DatabaseManager.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  DbManager dbManager = new DbManager();

  int currentValue = 0;
  String currentText = '';
  List<GroupModel> group = [
    GroupModel(text: 'قرآن', index: 0),
    GroupModel(text: 'ترجمہ', index: 1)
  ];

  List<AyatModel> aayat;
  final queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('تلاش کریں',style: TextStyle(fontFamily: "Jameel"),),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: TextField(
              controller: queryController,
              style: TextStyle(fontFamily: "Jameel", fontSize: 18),
              textInputAction: TextInputAction.search,
              onChanged: (text) async {

                String column = currentText == 'قرآن' ? Constants.AYAT_SIMPLE : Constants.TRANSLATION;
                var list = await dbManager.find(column, text);
                setState(() {
                  aayat.clear();
                  aayat.addAll(list);
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'یہاں لکھیں',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: group.map((t) =>
                  Expanded(
                    child: RadioListTile(
                      title: Text("${t.text}",style: TextStyle(fontFamily: "Jameel"),),
                      groupValue: currentValue,
                      value: t.index,
                      onChanged: (val) {
                        setState(() {
                          currentValue = val;
                          currentText = t.text;
                        });
                      },
                    ),
                  ))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              itemBuilder: (BuildContext context, int index) =>
              currentValue == 0 ? quranListView(context, index) : translationListView(context, index),
              itemCount: aayat.length,
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    aayat = List<AyatModel>();
  }

  Widget translationListView(BuildContext context, int index) {
    AyatModel ayatModel = aayat[index];
    String surahName = QuranInfo.surahInfo[ayatModel.suratId-1].urduName;
    String ayatNo = ayatModel.ayatNo == "0" ? "سورہ "+surahName : ' سورہ $surahName : '  +ayatModel.ayatNo;
    return Card(
      elevation: 4,
      child: ListTile(
        title: SubstringHighlight(
          text: ayatModel.translation,
          term: queryController.text.trim(),
          textStyle: TextStyle(fontFamily: "Jameel", color: Colors.black, fontSize: 18, height: 1.7),
          textStyleHighlight: TextStyle(fontFamily: "Jameel",
              color: Colors.red, fontSize: 18, height: 1.7, fontWeight: FontWeight.w600),
        ),
        subtitle: Container(
          padding: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300))
          ),
            child: Text(ayatNo, style: TextStyle(fontFamily: "Jameel", fontSize: 16,),)
        ),
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
          Route route = new MaterialPageRoute(builder: (context)=> SurahDetailList(title: surahName, surahId: ayatModel.suratId,scroll: int.parse(ayatModel.ayatNo),));
          Navigator.push(context, route);
        },
      ),
    );
  }

  Widget quranListView(BuildContext context, int index) {
    AyatModel ayatModel = aayat[index];
    String surahName = QuranInfo.surahInfo[ayatModel.suratId-1].urduName;
    String ayatNo = ayatModel.ayatNo == "0" ? "سورہ "+surahName : ' سورہ $surahName : '  +ayatModel.ayatNo;
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(ayatModel.ayat, style: TextStyle(fontFamily: "NooreHuda", color: Colors.black, fontSize: 20,),),
        subtitle: Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300))
            ),
            child: Text(ayatNo, style: TextStyle(fontFamily: "Jameel", fontSize: 16,),)
        ),
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
            Route route = new MaterialPageRoute(builder: (context)=> SurahDetailList(title: surahName, surahId: ayatModel.suratId,scroll: int.parse(ayatModel.ayatNo),));
            Navigator.push(context, route);
          },
      ),
    );
  }
}

class GroupModel{
  String text;
  int index;
  GroupModel({this.text, this.index});

}
