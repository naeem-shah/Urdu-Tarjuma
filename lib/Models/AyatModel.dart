import 'package:tarjumaquran/Constants/Constants.dart';

class AyatModel {
  int id;
  int suratId;
  String ayatNo;
  String ayat;
  String ayatSimple;
  String translation;
  int parhNo;
  String reference;
  bool isFavourite;

  AyatModel(
      {this.id,
      this.suratId,
      this.ayat,
      this.ayatSimple,
      this.translation,
      this.parhNo,
      this.reference,
      this.isFavourite});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map[Constants.ID] = this.id;
    map[Constants.SURAT_ID] = this.suratId;
    map[Constants.AYAT_NO] = this.ayatNo;
    map[Constants.AYAT] = this.ayat;
    map[Constants.AYAT_SIMPLE] = this.ayatSimple;
    map[Constants.TRANSLATION] = this.translation;
    map[Constants.PARAH] = this.parhNo;
    map[Constants.REFERENCE] = this.reference;
    map[Constants.IS_Favourite] = this.isFavourite == true ? 1 : 0;

    return map;
  }

  AyatModel.fromMapObject(Map<String, dynamic> map) {
    this.id = map[Constants.ID];
    this.suratId = map[Constants.SURAT_ID];
    this.ayat = map[Constants.AYAT];
    this.ayatSimple = map[Constants.AYAT_SIMPLE];
    this.translation = map[Constants.TRANSLATION];
    this.ayatNo = map[Constants.AYAT_NO];
    this.parhNo = map[Constants.PARAH];
    this.reference = map[Constants.REFERENCE];
    this.isFavourite = map[Constants.IS_Favourite] == 1 ? true : false;
  }
}
