import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:furkan_flutter/models/surah.model.dart';
import 'package:furkan_flutter/pages/sura-details.page.dart';
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
  late http.Client _client;

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

  Future<void> _getFile() async{
    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = "$dir/resources.json";
    print(filePath);
    bool fileExists = await File(filePath).existsSync();
    setState((){
      _loading = true;
    });
    if(fileExists){
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
      _client = http.Client();
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
        ),
        body: Column(
            children: [
              _loading? LinearProgressIndicator(minHeight: 5, value: _percentage >0 ?_percentage: 0,color: Colors.yellow,): Container(),
              Expanded(
                  child: Container(
                    height: double.infinity,
                    child: ListView.builder(
                      itemCount: _surahs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Surah surah = _surahs[index];
                        return InkWell(
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
                                        SizedBox(
                                            width: 30,
                                            child: Text(surah.no)
                                        ),
                                        SizedBox(
                                            width: 150,
                                            child: Text(
                                              surah.name_bn,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontFamily: "Kalpurush"
                                              ),
                                            )
                                        ),
                                        Expanded(child: Text("${surah.total_ayats} আয়াত", style: TextStyle(fontSize: 11),)),
                                        Text(surah.name_ar,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 28,
                                              fontFamily: "Al-Qalam Quran"
                                          ),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _getFile,
      //   child: Icon(Icons.account_circle),
      // ),
    );
  }
}
