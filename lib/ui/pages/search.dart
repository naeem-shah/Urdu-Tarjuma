import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:get/get.dart';
import 'package:tarjumaquran/models/AyatModel.dart';
import 'package:tarjumaquran/ui/pages/surah_details.dart';
import 'package:tarjumaquran/Constants/Constants.dart';
import 'package:tarjumaquran/QuranData/QuranInfo.dart';

import '../../Database/DatabaseManager.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  DbManager dbManager = DbManager();

  int? currentValue = 0;
  String? currentText = '';
  List<GroupModel> group = [
    GroupModel(text: 'قرآن', index: 0),
    GroupModel(text: 'ترجمہ', index: 1)
  ];

  late List<AyatModel> aayat;
  final queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تلاش کریں',style: TextStyle(fontFamily: "Jameel"),),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: TextField(
              controller: queryController,
              style: const TextStyle(fontFamily: "Jameel", fontSize: 18),
              textInputAction: TextInputAction.search,
              onChanged: (text) async {

                String column = currentText == 'قرآن' ? Constants.AYAT_SIMPLE : Constants.TRANSLATION;
                var list = await dbManager.find(column, text);
                setState(() {
                  aayat.clear();
                  aayat.addAll(list);
                });
              },
              decoration: const InputDecoration(
                filled: true,
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
                      title: Text(t.text!,style: const TextStyle(fontFamily: "Jameel"),),
                      groupValue: currentValue,
                      value: t.index,
                      onChanged: (dynamic val) {
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
    aayat = <AyatModel>[];
  }
  Widget translationListView(BuildContext context, int index) {
    AyatModel ayatModel = aayat[index];
    String? surahName = QuranInfo.surahInfo[ayatModel.suratId!-1].urduName;
    String ayatNo = ayatModel.ayatNo == "0" ? "سورہ "+surahName! : ' سورہ $surahName : '  +ayatModel.ayatNo!;
    return Card(
      elevation: 4,
      child: ListTile(
        title: ParsedText(
          text: ayatModel.translation!,
          style: TextStyle(
            fontFamily: "Jameel",
            color: Get.isDarkMode ?Colors.white:Colors.black87,
            height: 1.7,
            fontSize: 18
          ),
          parse: queryController.text.trim().isNotEmpty?[MatchText(
              pattern: queryController.text,
              style: const TextStyle(
                  fontFamily: "Jameel",
                  color: Colors.redAccent,
                  height: 1.7,
                  fontSize: 18
              )
          )]:[],
        ),
        subtitle: Container(
          padding: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300))
          ),
            child: Text(ayatNo, style: const TextStyle(fontFamily: "Jameel", fontSize: 16,),)
        ),
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
          Route route = MaterialPageRoute(builder: (context)=> SurahDetailList(title: surahName, surahId: ayatModel.suratId,scroll: int.parse(ayatModel.ayatNo!),));
          Navigator.push(context, route);
        },
      ),
    );
  }

  Widget quranListView(BuildContext context, int index) {
    AyatModel ayatModel = aayat[index];
    String? surahName = QuranInfo.surahInfo[ayatModel.suratId!-1].urduName;
    String ayatNo = ayatModel.ayatNo == "0" ? "سورہ "+surahName! : ' سورہ $surahName : '  +ayatModel.ayatNo!;
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(ayatModel.ayat!, style: const TextStyle(fontFamily: "NooreHuda", fontSize: 20,),),
        subtitle: Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300))
            ),
            child: Text(ayatNo, style: const TextStyle(fontFamily: "Jameel", fontSize: 16,),)
        ),
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
            Route route = MaterialPageRoute(builder: (context)=> SurahDetailList(title: surahName, surahId: ayatModel.suratId,scroll: int.parse(ayatModel.ayatNo!),));
            Navigator.push(context, route);
          },
      ),
    );
  }
}

class GroupModel{
  String? text;
  int? index;
  GroupModel({this.text, this.index});

}
