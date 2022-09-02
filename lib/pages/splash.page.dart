import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furkan_flutter/pages/surah-list.page.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SplashPage extends StatefulWidget{
  const SplashPage({Key? key}) : super(key: key);
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _loading = false;
  int _total = 0;
  int _received = 0;
  double? _percentage = 0;
  http.Client _client = http.Client();


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
      setState(() {
        _percentage = null;
      });
    });
    if(fileExists && ! await _checkForUpdate()){
      print("file already exists");
      print("file exist");
      Timer.periodic(Duration(seconds: 3), (timer) {
        _gotoListing();
      });

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
          _percentage = (_received/_total);
        });
      }).onDone(() async {
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        print("file downloaded");
        _gotoListing();
      });
    }
  }

  _gotoListing(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SurahListPage()),
    );
  }


  @override
  void initState() {
    _getFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Center(
              child: Container(
                alignment: Alignment.center,
                height: 100,
                child: Column(
                  children: [
                    Text("Furkan", style: TextStyle(color: Colors.white, fontSize: 26),),
                    Container(
                        width: 90,
                        margin: EdgeInsets.only(top:20),
                        child:  LinearProgressIndicator(color: Colors.white,  value: _percentage, backgroundColor: Colors.transparent,)
                    ),
                  ],
                )
              )
          ),
        )
    );
  }

}