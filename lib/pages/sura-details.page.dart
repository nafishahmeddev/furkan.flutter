import 'package:flutter/material.dart';
import 'package:furkan_flutter/models/ayat.model.dart';
import 'package:furkan_flutter/models/surah.model.dart';
class SurahDetailsPage extends StatefulWidget {
  const SurahDetailsPage({Key? key, required this.surah_no, required this.surahs}) : super(key: key);
  final String surah_no;
  final List<Surah> surahs;
  @override
  State<SurahDetailsPage> createState() => _SurahDetailsPageState();
}

class _SurahDetailsPageState extends State<SurahDetailsPage> {
  String _surah_no = "";
  List<Surah> _surahs = [];
  late Surah  _surah;
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    setState((){
      _surahs = widget.surahs;
      changeSurah(widget.surah_no);
    });
  }

  void changeSurah(String surahNo){
    setState(() {
      _surah_no = surahNo;
      _surah = _surahs.firstWhere((element) => element.no == _surah_no);
    });
  }
  nextSurah(){
    int next = int.parse(_surah_no) + 1;
    if(next <= 214) {
      changeSurah(next.toString());
    }
  }
  prevSurah(){
    int prev = int.parse(_surah_no) -1;
    if(prev >= 1) {
      changeSurah(prev.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: DropdownButtonHideUnderline(
              child: DropdownButton(
                  iconEnabledColor: Colors.white,
                  iconDisabledColor: Colors.grey,
                  value: _surah_no,
                  onChanged: (value) {
                    changeSurah(value.toString());
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return _surahs.map((Surah value) {
                      // return Text(
                      //   "${_surah.no}. ${_surah.name_en}",
                      //   style: const TextStyle(color: Colors.white),
                      // );

                      return DropdownMenuItem<String>(
                        value: _surah.no,
                        child: Container(child: Text("${_surah.no}. ${_surah.name_en}", style: TextStyle(color: Colors.white),)),
                      );
                    }).toList();
                  },
                  items: _surahs.map((Surah surah) {
                    return DropdownMenuItem<String>(
                      value: surah.no,
                      child: Container(child: Text("${surah.no}. ${surah.name_en}")),
                    );

                  }).toList()
              )
          ),
          actions: [
            IconButton(onPressed: prevSurah, icon: Icon(Icons.chevron_left)),
            IconButton(onPressed: nextSurah, icon: Icon(Icons.chevron_right)),
          ],
          elevation: 0,
          centerTitle: true,
        ),
        body:Container(
            height: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )
              ),child: _surah != null?Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                        itemCount: _surah.ayats.length,
                        padding: EdgeInsets.only(top: 15),
                        itemBuilder: (BuildContext context, int index) {
                          Ayat ayat = _surah.ayats[index];
                          return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                              child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular((8)),
                                  child:InkWell(
                                    onTap: (){},
                                    child: Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 15.00,
                                                  horizontal: 15.00
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: 30,
                                                      child: Text(ayat.ayat_no, style: TextStyle(color: Theme.of(context).primaryColor),)
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                              width: double.infinity,
                                                              child:Text(ayat.text_ar,
                                                                textAlign: TextAlign.right,
                                                                style: TextStyle(
                                                                    color: Theme.of(context).primaryColor,
                                                                    fontSize: 24,
                                                                    fontFamily: "Al-Qalam Quran"
                                                                ),
                                                              )
                                                          ),
                                                          SizedBox(
                                                              width: double.infinity,
                                                              child: Text(
                                                                ayat.text_bn,
                                                                style: const TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18,
                                                                    fontFamily: "Kalpurush"
                                                                ),
                                                              )
                                                          ),

                                                        ],
                                                      )
                                                  )
                                                ],
                                              )
                                          ),
                                        ]
                                    ),
                                  )
                              )
                          );
                        },
                      )
                  )
                ]
            ):const Text("Nothing to show"),
            )
        )
    );
  }
}

