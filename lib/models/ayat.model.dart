class Ayat {
  final String text_bn;
  final String text_en;
  final String text_ar;
  final String ayat_no;
  final String surah_no;

  Ayat(this.text_bn, this.text_en, this.text_ar, this.ayat_no, this.surah_no);

  Ayat.fromJson(Map<String, dynamic> json)
      : text_bn = json['text_bn'],
        text_en = json['text_en'],
        text_ar = json['text_ar'],
        ayat_no = json['ayat_no'],
        surah_no = json['surah_no'];

  Map<String, dynamic> toJson() => {
    'text_bn':text_bn,
    'text_en':text_en,
    'text_ar':text_ar,
    'ayat_no':ayat_no,
    'surah_no':surah_no,
  };
}