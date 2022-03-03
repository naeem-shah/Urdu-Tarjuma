import 'package:flutter/material.dart';
import 'package:tarjumaquran/Constants/Constants.dart';
import 'package:tarjumaquran/QuranData/QuranInfo.dart';
import 'package:tarjumaquran/models/surah_info_model.dart';

import '../pages/surah_details.dart';

class HomeListView extends StatefulWidget {
  final List<Info> infoList;
  final String set;

  const HomeListView(this.infoList, this.set);

  @override
  _HomeListViewState createState() =>
      _HomeListViewState(set);
}

class _HomeListViewState extends State<HomeListView> {
  List<Info> infoList = [];
  final String set;

  _HomeListViewState(this.set);

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8,bottom: 8),
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
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    info.urduName!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontFamily: "NooreHuda", fontSize: 22),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      info.engName!,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    info.id.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void filter(String query) {
    if (query.isNotEmpty) {
      List<Info> dummySearchList = <Info>[];
      dummySearchList.addAll(QuranInfo.surahInfo);
      List<Info> dummyListData = <Info>[];
      for (var item in dummySearchList) {
        int? id = item.id;
        String eng = item.engName!.toLowerCase();
        String? urdu = item.urduName;
        if (id.toString().contains(query) ||
            eng.contains(query.toLowerCase()) ||
            urdu!.contains(query)) {
          dummyListData.add(item);
        }
      }
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