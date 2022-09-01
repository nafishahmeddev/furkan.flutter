import 'ayat.model.dart';
import 'package:html_unescape/html_unescape.dart';
class Surah {
  final String name_bn;
  final String name_en;
  final String name_ar;
  final String meaning;
  final String no;
  final String total_ayats;
  final String total_ruku;
  final List<SurahVideo> videos;
  final List<Ayat> ayats;

  Surah(this.name_bn, this.name_en, this.name_ar, this.meaning, this.no, this.total_ayats, this.total_ruku, this.videos, this.ayats);

  Surah.fromJson(Map<String, dynamic> json)
      : name_bn = HtmlUnescape().convert(json['name_bn']),
        name_en = json['name_en'],
        name_ar = json['name_ar'],
        meaning = json['meaning'],
        no = json['no'],
        total_ayats = json['total_ayats'],
        total_ruku = json['total_ruku'],
        videos = List<SurahVideo>.from(json['videos'].map((dynamic video) => SurahVideo.fromJson(Map<String, dynamic>.from(video)))),
        ayats = List<Ayat>.from(json['ayats'].map((dynamic ayat) => Ayat.fromJson(Map<String, dynamic>.from(ayat))));

  Map<String, dynamic> toJson() => {
    'name_bn':name_bn,
    'name_en':name_en,
    'name_ar':name_ar,
    'meaning':meaning,
    'no':no,
    'total_ayats':total_ayats,
    'total_ruku':total_ruku,
    'videos':videos,
    "ayats": ayats
  };
}

class SurahVideo{
  final String title;
  final String url;
  final String type;
  final String yt_video_id;

  SurahVideo(this.title, this.url, this.type, this.yt_video_id);
  SurahVideo.fromJson(Map<String, dynamic> json)
      :
        title = json['title'],
        url = json['url'],
        type = json['type'],
        yt_video_id = json['yt_video_id']?? "";

  Map<String, dynamic> toJson() => {
    'title':title,
    'url':url,
    'type':type,
    'yt_video_id':yt_video_id,
  };
}