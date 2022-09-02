import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:furkan_flutter/models/surah.model.dart';
import 'package:furkan_flutter/pages/sura-details.page.dart';
import 'package:furkan_flutter/theme/colors.dart';
import 'package:furkan_flutter/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SurahListPage extends StatefulWidget {
  const SurahListPage({Key? key}) : super(key: key);
  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  List<Surah> _surahs = [];
  Future<void> _get() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = "$dir/resources.json";
    final file = File(filePath);
    Map<String, dynamic> data = jsonDecode(await file.readAsStringSync());
    List<Surah> surahs = List<Surah>.from(data["surahs"].map((dynamic json){
      Map<String, dynamic> surah = Map<String, dynamic>.from(json);
      surah["ayats"] = data["ayats"][surah["no"]];
      return Surah.fromJson(surah);
    }));
    setState((){
      _surahs = surahs;
    });
  }
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    _get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Furkan"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
          children: [
            Expanded(
                child: Container(
                    height: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        )
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 15),
                        itemCount: _surahs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Surah surah = _surahs[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                            child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular((8)),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SurahDetailsPage(surah_no: surah.no, surahs: _surahs,)));
                                  },

                                  child: Column(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.00,
                                                horizontal: 15.00
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                    width: 24,
                                                    height: 24,
                                                    margin: EdgeInsets.only(right: 15),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(color: ThemePrimaryColor[400], borderRadius: BorderRadius.circular(15)),
                                                    child: Text(Utils.toBNNumber(surah.no), style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),)
                                                ),
                                                Container(
                                                    width: 150,
                                                    alignment: Alignment.centerLeft,
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            surah.name_bn,
                                                            style: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 20 ,
                                                                fontFamily: "Kalpurush"
                                                            ),
                                                          ),
                                                          Text("${surah.total_ayats} আয়াত", style: TextStyle(fontSize: 11))
                                                        ]
                                                    )
                                                ),
                                                Expanded(
                                                    child:   Text(surah.name_ar,
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(
                                                          color: Theme.of(context).primaryColor,
                                                          fontSize: 24,
                                                          fontFamily: "Al-Qalam Quran"
                                                      ),
                                                    )
                                                )
                                              ],
                                            )
                                        ),
                                      ]
                                  ),
                                )
                            ),
                          );
                        },
                      ),
                    )
                )
            )
          ]
      ),
    );
  }
}
