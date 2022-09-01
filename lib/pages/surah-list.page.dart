import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:furkan_flutter/models/surah.model.dart';
import 'package:furkan_flutter/pages/sura-details.page.dart';
import 'package:furkan_flutter/theme/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SurahListPage extends StatefulWidget {
  const SurahListPage({Key? key}) : super(key: key);
  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  List<Surah> _surahs = [];
  bool _loading = false;
  int _total = 0;
  int _received = 0;
  double _percentage = 0;
  http.Client _client = http.Client();

  Future<void> _get(File file) async {
    setState((){
      _loading = false;
    });
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
  Future<bool> _checkForUpdate() async{
    try {
      String dir = (await getApplicationDocumentsDirectory()).path;
      String filePath = "$dir/resources.json";
      FileStat fileStat = File(filePath).statSync();
      int ts = (fileStat.changed.millisecondsSinceEpoch).toInt();
      var res = await _client.get(Uri.parse("https://webtrackers.co.in/furkan/api/index.php?check_for_update=OK&ts=$ts"));
      return res.body == "UPDATE_AVAILABLE";
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> _getFile() async{
    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = "$dir/resources.json";
    print(filePath);
    bool fileExists = await File(filePath).existsSync();
    setState((){
      _loading = true;
    });
    if(fileExists && ! await _checkForUpdate()){
      print("file already exists");
      _get(File(filePath));
    } else {
      print("downloading files");
      try {
        var d = await File(filePath);
        await d.delete();
        print("file deleted");
      } catch(e){
        print(e);
      }
      
      http.Request request = http.Request("GET", Uri.parse("https://webtrackers.co.in/furkan/api/json.php"));
      http.StreamedResponse response = await _client.send(request);
      setState((){
        _total = response.contentLength??0;
        _received = 0;
        _percentage= 0;
      });

      final List<int> bytes = [];
      response.stream.listen((value) {
        setState(() {
          bytes.addAll(value);
          _received += value.length;
          _percentage = (_received/_total)*100;
        });
      }).onDone(() async {
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        _get(file);
      });
    }
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    _getFile();
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
            _loading? LinearProgressIndicator(minHeight: 5, value: _percentage >0 ?_percentage: 0,color: Colors.red,): Container(),
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
                                                    child: Text(surah.no, style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),)
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
