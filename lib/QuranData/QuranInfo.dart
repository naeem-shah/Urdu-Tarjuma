import 'dart:core';

class QuranInfo {
  static final List<Info> surahInfo = [
    new Info(
      id: 1,
      engName: "Al-Fatihah",
      urduName: "الفاتحۃ",
    ),
    new Info(
      id: 2,
      engName: "Al-Baqarah",
      urduName: "البقرۃ",
    ),
    new Info(
      id: 3,
      engName: "Aali Imran",
      urduName: "آل عمران",
    ),
    new Info(
      id: 4,
      engName: "An-Nisa’",
      urduName: "النسآء",
    ),
    new Info(
      id: 5,
      engName: "Al-Ma’idah",
      urduName: "المآئدۃ",
    ),
    new Info(
      id: 6,
      engName: "Al-An’am",
      urduName: "الانعام",
    ),
    new Info(
      id: 7,
      engName: "Al-A’raf",
      urduName: "الاعراف",
    ),
    new Info(
      id: 8,
      engName: "Al-Anfal",
      urduName: "الانفال",
    ),
    new Info(
      id: 9,
      engName: "At-Taubah",
      urduName: "التوبۃ",
    ),
    new Info(
      id: 10,
      engName: "Yunus",
      urduName: "یونس",
    ),
    new Info(
      id: 11,
      engName: "Hud",
      urduName: "ھود",
    ),
    new Info(
      id: 12,
      engName: "Yusuf",
      urduName: "یوسف",
    ),
    new Info(
      id: 13,
      engName: "Ar-Ra’d ",
      urduName: "الرعد",
    ),
    new Info(
      id: 14,
      engName: "Ibrahim",
      urduName: "ابراھیم",
    ),
    new Info(
      id: 15,
      engName: "Al-Hijr",
      urduName: "الحجر",
    ),
    new Info(
      id: 16,
      engName: "An-Nahl",
      urduName: "النحل",
    ),
    new Info(
      id: 17,
      engName: "Al-Isra’",
      urduName: "الاسراء",
    ),
    new Info(
      id: 18,
      engName: "Al-Kahf",
      urduName: "الکہف",
    ),
    new Info(
      id: 19,
      engName: "Maryam",
      urduName: "مریم",
    ),
    new Info(
      id: 20,
      engName: "Ta-Ha",
      urduName: "طٰہٰ",
    ),
    new Info(
      id: 21,
      engName: "Al-Anbiya’",
      urduName: "الانبیآء",
    ),
    new Info(
      id: 22,
      engName: "Al-Haj",
      urduName: "الحج",
    ),
    new Info(
      id: 23,
      engName: "Al-Mu’minun",
      urduName: "المؤمنون",
    ),
    new Info(
      id: 24,
      engName: "An-Nur",
      urduName: "النور",
    ),
    new Info(
      id: 25,
      engName: "Al-Furqan",
      urduName: "الفرقان",
    ),
    new Info(
      id: 26,
      engName: "Ash-Shu’ara’",
      urduName: "الشعراء",
    ),
    new Info(
      id: 27,
      engName: "An-Naml",
      urduName: "النمل",
    ),
    new Info(
      id: 28,
      engName: "Al-Qasas",
      urduName: "القصص",
    ),
    new Info(
      id: 29,
      engName: "Al-Ankabut",
      urduName: "العنکبوت",
    ),
    new Info(
      id: 30,
      engName: "Ar-Rum",
      urduName: "الروم",
    ),
    new Info(
      id: 31,
      engName: "Luqman",
      urduName: "لقمٰن",
    ),
    new Info(
      id: 32,
      engName: "As-Sajdah",
      urduName: "السجدۃ",
    ),
    new Info(
      id: 33,
      engName: "Al-Ahzab",
      urduName: "الاحزاب",
    ),
    new Info(
      id: 34,
      engName: "Saba’",
      urduName: "سبا",
    ),
    new Info(
      id: 35,
      engName: "Al-Fatir",
      urduName: "فاطر",
    ),
    new Info(
      id: 36,
      engName: "Ya-Sin",
      urduName: "یٰسٓ",
    ),
    new Info(
      id: 37,
      engName: "As-Saffah",
      urduName: "الصّٰفّٰت",
    ),
    new Info(
      id: 38,
      engName: "Sad",
      urduName: "صٓ",
    ),
    new Info(
      id: 39,
      engName: "Az-Zumar",
      urduName: "الزمر",
    ),
    new Info(
      id: 40,
      engName: "Ghafar",
      urduName: "الغافر",
    ),
    new Info(
      id: 41,
      engName: "Fusilat",
      urduName: "فصلت",
    ),
    new Info(
      id: 42,
      engName: "Ash-Shura",
      urduName: "الشُّورٰی",
    ),
    new Info(
      id: 43,
      engName: "Az-Zukhruf",
      urduName: "الزُّخرُف",
    ),
    new Info(
      id: 44,
      engName: "Ad-Dukhan",
      urduName: "الدُّخَان",
    ),
    new Info(
      id: 45,
      engName: "Al-Jathiyah",
      urduName: "الجاثیہ",
    ),
    new Info(
      id: 46,
      engName: "Al-Ahqaf",
      urduName: "الاحقاف",
    ),
    new Info(
      id: 47,
      engName: "Muhammad",
      urduName: "محمد",
    ),
    new Info(
      id: 48,
      engName: "Al-Fat’h",
      urduName: "الفتح",
    ),
    new Info(
      id: 49,
      engName: "Al-Hujurat",
      urduName: "الحجرات",
    ),
    new Info(
      id: 50,
      engName: "Qaf",
      urduName: "قٓ",
    ),
    new Info(
      id: 51,
      engName: "Adz-Dzariyah",
      urduName: "الذّٰریٰت",
    ),
    new Info(
      id: 52,
      engName: "At-Tur",
      urduName: "الطّور",
    ),
    new Info(
      id: 53,
      engName: "An-Najm",
      urduName: "النجم",
    ),
    new Info(
      id: 54,
      engName: "Al-Qamar",
      urduName: "القمر",
    ),
    new Info(
      id: 55,
      engName: "Ar-Rahman",
      urduName: "الرحمٰن",
    ),
    new Info(
      id: 56,
      engName: "Al-Waqi’ah",
      urduName: "الواقعۃ",
    ),
    new Info(
      id: 57,
      engName: "Al-Hadid",
      urduName: "الحدید",
    ),
    new Info(
      id: 58,
      engName: "Al-Mujadilah",
      urduName: "المجادلۃ",
    ),
    new Info(
      id: 59,
      engName: "Al-Hashr",
      urduName: "الحشر",
    ),
    new Info(
      id: 60,
      engName: "Al-Mumtahanah",
      urduName: "الممتحنۃ",
    ),
    new Info(
      id: 61,
      engName: "As-Saf",
      urduName: "الصّف",
    ),
    new Info(
      id: 62,
      engName: "Al-Jum’ah",
      urduName: "الجُمعۃ",
    ),
    new Info(
      id: 63,
      engName: "Al-Munafiqun",
      urduName: "المُنٰفِقُون",
    ),
    new Info(
      id: 64,
      engName: "At-Taghabun",
      urduName: "التّغابن",
    ),
    new Info(
      id: 65,
      engName: "At-Talaq",
      urduName: "الطّلاق",
    ),
    new Info(
      id: 66,
      engName: "At-Tahrim",
      urduName: "التحریم",
    ),
    new Info(
      id: 67,
      engName: "Al-Mulk",
      urduName: "الملک",
    ),
    new Info(
      id: 68,
      engName: "Al-Qalam",
      urduName: "القلم",
    ),
    new Info(
      id: 69,
      engName: "Al-Haqqah",
      urduName: "الحاقہ",
    ),
    new Info(
      id: 70,
      engName: "Al-Ma’arij",
      urduName: "المعارج",
    ),
    new Info(
      id: 71,
      engName: "Nuh",
      urduName: "نُوح",
    ),
    new Info(
      id: 72,
      engName: "Al-Jinn",
      urduName: "الجن",
    ),
    new Info(
      id: 73,
      engName: "Al-Muzammil",
      urduName: "المزّمّل",
    ),
    new Info(
      id: 74,
      engName: "Al-Mudaththir",
      urduName: "المدّثّر",
    ),
    new Info(
      id: 75,
      engName: "Al-Qiyamah",
      urduName: "القیٰمۃ",
    ),
    new Info(
      id: 76,
      engName: "Al-Insan",
      urduName: "الانسان",
    ),
    new Info(
      id: 77,
      engName: "Al-Mursalat",
      urduName: "المرسلٰت",
    ),
    new Info(
      id: 78,
      engName: "An-Naba",
      urduName: "النَّبَاِ",
    ),
    new Info(
      id: 79,
      engName: "An-Nazi’at",
      urduName: "النّٰزِعٰتِ",
    ),
    new Info(
      id: 80,
      engName: "Abasa",
      urduName: "عَبَسَ",
    ),
    new Info(
      id: 81,
      engName: "At-Takwir",
      urduName: "التَّکوِیر",
    ),
    new Info(
      id: 82,
      engName: "Al-Infitar",
      urduName: "الاِنفِطَار",
    ),
    new Info(
      id: 83,
      engName: "Al-Mutaffifin",
      urduName: "المُطَفِّفِین",
    ),
    new Info(
      id: 84,
      engName: "Al-Inshiqaq",
      urduName: "الاِنشِقَاق",
    ),
    new Info(
      id: 85,
      engName: "Al-Buruj",
      urduName: "البُرُوج",
    ),
    new Info(
      id: 86,
      engName: "At-Tariq",
      urduName: "الطَّارق",
    ),
    new Info(
      id: 87,
      engName: "Al-A’la",
      urduName: "الاَعلیٰ",
    ),
    new Info(
      id: 88,
      engName: "Al-Ghashiyah",
      urduName: "الغَاشِیَۃ",
    ),
    new Info(
      id: 89,
      engName: "Al-Fajr",
      urduName: "الفجر",
    ),
    new Info(
      id: 90,
      engName: "Al-Balad",
      urduName: "البلد",
    ),
    new Info(
      id: 91,
      engName: "Ash-Shams",
      urduName: "الشَّمس",
    ),
    new Info(
      id: 92,
      engName: "Al-Layl",
      urduName: "الَّیل",
    ),
    new Info(
      id: 93,
      engName: "Adh-Dhuha",
      urduName: "الضُّحٰی",
    ),
    new Info(
      id: 94,
      engName: "Al-Inshirah",
      urduName: "الم نشرح",
    ),
    new Info(
      id: 95,
      engName: "At-Tin",
      urduName: "التّین",
    ),
    new Info(
      id: 96,
      engName: "Al-‘Alaq",
      urduName: "العَلَق",
    ),
    new Info(
      id: 97,
      engName: "Al-Qadar",
      urduName: "القدر",
    ),
    new Info(
      id: 98,
      engName: "Al-Bayinah",
      urduName: "البیّنۃ",
    ),
    new Info(
      id: 99,
      engName: "Az-Zalzalah",
      urduName: "الزّلزال",
    ),
    new Info(
      id: 100,
      engName: "Al-Adiyah",
      urduName: "العٰدیٰت",
    ),
    new Info(
      id: 101,
      engName: "Al-Qari’ah",
      urduName: "القارعۃ",
    ),
    new Info(
      id: 102,
      engName: "At-Takathur",
      urduName: "التّکاثُر",
    ),
    new Info(
      id: 103,
      engName: "Al-Asr",
      urduName: "العصر",
    ),
    new Info(
      id: 104,
      engName: "Al-Humazah",
      urduName: "الھُمَزَۃ",
    ),
    new Info(
      id: 105,
      engName: "Al-Fil",
      urduName: "الفِیل",
    ),
    new Info(
      id: 106,
      engName: "Quraish",
      urduName: "قُرَیش",
    ),
    new Info(
      id: 107,
      engName: "Al-Ma’un",
      urduName: "المَاعُون",
    ),
    new Info(
      id: 108,
      engName: "Al-Kauthar",
      urduName: "الکوثر",
    ),
    new Info(
      id: 109,
      engName: "Al-Kafirun",
      urduName: "الکٰفرون",
    ),
    new Info(
      id: 110,
      engName: "An-Nasr",
      urduName: "النَّصَر",
    ),
    new Info(
      id: 111,
      engName: "Al-Masad",
      urduName: "اللَّھب",
    ),
    new Info(
      id: 112,
      engName: "Al-Ikhlas",
      urduName: "الاخلاص",
    ),
    new Info(
      id: 113,
      engName: "Al-Falaq",
      urduName: "الفَلَق",
    ),
    new Info(
      id: 114,
      engName: "An-Nas",
      urduName: "النَّاس",
    ),
  ];

  static final List<Info> juzInfo = [
    new Info(id: 1, engName: "Alif Lam Meem", urduName: "الم"),
    new Info(id: 2, engName: "Sayaqool", urduName: "سَيَقُولُ"),
    new Info(id: 3, engName: "Tilkal Rusull", urduName: "تِلْكَ الرُّسُلُ"),
    new Info(id: 4, engName: "Lan Tana Loo", urduName: "لَنْ تَنَالُوا"),
    new Info(id: 5, engName: "Wal Mohsanat", urduName: "وَالْمُحْصَنَاتُ"),
    new Info(id: 6, engName: "La Yuhibbullah", urduName: "لَا يُحِبُّ اللَّهُ"),
    new Info(id: 7, engName: "Wa Iza Samiu", urduName: "وَإِذَا سَمِعُوا"),
    new Info(id: 8, engName: "Wa Lau Annana", urduName: "وَلَوْ أَنَّنَا"),
    new Info(id: 9, engName: "Qalal Malao", urduName: "قَالَ الْمَلَأُ"),
    new Info(id: 10, engName: "Wa A'lamu", urduName: "وَاعْلَمُوا"),
    new Info(id: 11, engName: "Yatazeroon", urduName: "يَعْتَذِرُونَ"),
    new Info(id: 12, engName: "Wa Mamin Da'abat", urduName: "وَمَا مِنْ دَابَّةٍ"),
    new Info(id: 13, engName: "Wa Ma Ubrioo", urduName: "وَمَا أُبَرِّئُ"),
    new Info(id: 14, engName: "Rubama", urduName: "رُبَمَا"),
    new Info(id: 15, engName: "Subhanallazi", urduName: "سُبْحَانَ الَّذِي"),
    new Info(id: 16, engName: "Qal Alam", urduName: "قَالَ أَلَمْ"),
    new Info(id: 17, engName: "Aqtarabo", urduName: "اقْتَرَبَ"),
    new Info(id: 18, engName: "Qadd Aflaha", urduName: "قَدْ أَفْلَحَ"),
    new Info(id: 19, engName: "Wa Qalallazina", urduName: "وَقَالَ الَّذِينَ"),
    new Info(id: 20, engName: "A'man Khalaq", urduName: "أَمَّنْ خَلَقَ"),
    new Info(id: 21, engName: "Utlu Ma Oohi", urduName: "اتْلُ مَا أُوحِيَ"),
    new Info(id: 22, engName: "Wa Manyaqnut", urduName: "وَمَنْ يَقْنُتْ"),
    new Info(id: 23, engName: "Wa Mali", urduName: "وَمَا لِيَ"),
    new Info(id: 24, engName: "Faman Azlam", urduName: "فَمَنْ أَظْلَمُ"),
    new Info(id: 25, engName: "Elahe Yuruddo", urduName: "إِلَيْهِ يُرَدُّ"),
    new Info(id: 26, engName: "Ha'a Meem", urduName: "حم"),
    new Info(
        id: 27,
        engName: "Qala Fama Khatbukum",
        urduName: "قَالَ فَمَا خَطْبُكُمْ"),
    new Info(
        id: 28, engName: "Qadd Sami Allah", urduName: "قَدْ سَمِعَ اللَّهُ"),
    new Info(id: 29, engName: "Tabarakallazi", urduName: "تَبَارَكَ الَّذِي"),
    new Info(
        id: 30, engName: "Amma Yatasa'aloon", urduName: "عَمَّ يَتَسَاءَلُونَ")
  ];
}

class Info {
  int id;
  String urduName;
  String engName;

  Info({this.id, this.urduName, this.engName});
}
