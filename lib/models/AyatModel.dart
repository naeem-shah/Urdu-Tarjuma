import 'package:tarjumaquran/Constants/Constants.dart';

class AyatModel {
  int? id;
  int? suratId;
  String? ayatNo;
  String? ayat;
  String? ayatSimple;
  String? translation;
  int? parhNo;
  String? reference;
  bool? isFavourite;

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
    var map = <String, dynamic>{};

    map[Constants.ID] = id;
    map[Constants.SURAT_ID] = suratId;
    map[Constants.AYAT_NO] = ayatNo;
    map[Constants.AYAT] = ayat;
    map[Constants.AYAT_SIMPLE] = ayatSimple;
    map[Constants.TRANSLATION] = translation;
    map[Constants.PARAH] = parhNo;
    map[Constants.REFERENCE] = reference;
    map[Constants.IS_Favourite] = isFavourite == true ? 1 : 0;

    return map;
  }

  AyatModel.fromMapObject(Map<String, dynamic> map) {
    id = map[Constants.ID];
    suratId = map[Constants.SURAT_ID];
    ayat = map[Constants.AYAT];
    ayatSimple = map[Constants.AYAT_SIMPLE];
    translation = map[Constants.TRANSLATION];
    ayatNo = map[Constants.AYAT_NO];
    parhNo = map[Constants.PARAH];
    reference = map[Constants.REFERENCE];
    isFavourite = map[Constants.IS_Favourite] == 1 ? true : false;
  }
}
