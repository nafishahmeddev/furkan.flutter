import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furkan_flutter/models/surah.model.dart';
import 'package:furkan_flutter/pages/sura-details.page.dart';
import 'package:http/http.dart' as http;
class SurahListPage extends StatefulWidget {
  const SurahListPage({Key? key}) : super(key: key);
  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  List<Surah> _surahs = [];
  bool _loading = false;
  Future<void> _get() async {
    setState((){
      _loading = true;
    });
    print("Fetching data");
    var url = Uri.https('webtrackers.co.in', 'furkan/api');
    print(url);
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(url);
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    Map<String, dynamic> data = jsonDecode(reply);

    List<Surah> surahs = List<Surah>.from(data["surahs"].map((dynamic json){
      Map<String, dynamic> surah = Map<String, dynamic>.from(json);
      surah["ayats"] = data["ayats"][surah["no"]];
      return Surah.fromJson(surah);
    }));
    setState((){
      _surahs = surahs;
      _loading = false;
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
        ),
        body: Column(
            children: [
              _loading? Text("Loading"): Container(),
              Expanded(
                  child: Container(
                    height: double.infinity,
                    child: ListView.builder(
                      itemCount: _surahs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Surah surah = _surahs[index];
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SurahDetailsPage(surah: surah,)));
                          },

                          child: Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.00,
                                        horizontal: 15.00
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 30,
                                            child: Text(surah.no)
                                        ),
                                        Container(
                                            width: 150,
                                            child: Text(
                                              surah.name_bn,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontFamily: "Kalpurush"
                                              ),
                                            )
                                        ),
                                        Expanded(child: Text("${surah.total_ayats} Ayats", style: TextStyle(fontSize: 11),)),
                                        Container(
                                            child:Text(surah.name_ar,
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
                                Container(
                                  height: 1,
                                  color: Colors.black12,
                                  margin: EdgeInsets.only(left: 45),
                                )
                              ]
                          ),
                        );
                      },
                    ),
                  )
              )
            ]
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _get,
        child: Icon(Icons.account_circle),
      ),
    );
  }
}
