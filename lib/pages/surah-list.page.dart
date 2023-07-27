import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:furkan_flutter/models/surah.model.dart';
import 'package:furkan_flutter/pages/sura-details.page.dart';
import 'package:furkan_flutter/theme/colors.dart';
import 'package:furkan_flutter/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

import '../models/todo.model.dart';
import '../utils/db-provider.dart';

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

  newClient(Todo newClient) async {
    final dbProvider = DBProvider();
    final db = await dbProvider.database;
    var res = await db?.rawInsert(
        "INSERT Into Client (id,first_name)"
            " VALUES (NULL,'${newClient.firstName}')");
    print(res);
    return res;
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
        title: const Text("Furkan", style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: _surahs.length,
        itemBuilder: (BuildContext context, int index) {
          Surah surah = _surahs[index];
          return ListTile(
            dense: true,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SurahDetailsPage(surah_no: surah.no, surahs: _surahs,)));
            },
            leading: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: ThemePrimaryColor[400], borderRadius: BorderRadius.circular(15)),
                child: Text(Utils.toBNNumber(surah.no), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),)
            ),
            title: Text(
              surah.name_bn,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20 ,
                  fontFamily: "Kalpurush"
              ),
            ),
            subtitle:Text("${surah.total_ayats} আয়াত", style: const TextStyle(fontSize: 11)),
            trailing: Text(surah.name_ar,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24,
                  fontFamily: "Al-Qalam Quran"
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, index){
          return Container(
            margin: const EdgeInsets.only(left: 60, right: 15),
            height: 1,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.3),
          );
        },
      ),
    );
  }
}
