import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furkan_flutter/models/ayat.model.dart';
import 'package:furkan_flutter/models/surah.model.dart';
class SurahDetailsPage extends StatefulWidget {
  const SurahDetailsPage({Key? key, required this.surah}) : super(key: key);
  final Surah surah;
  @override
  State<SurahDetailsPage> createState() => _SurahDetailsPageState();
}

class _SurahDetailsPageState extends State<SurahDetailsPage> {

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Surah _surah = widget.surah;
    return Scaffold(
      appBar: AppBar(
        title: Text("Surah Details"),
      ),
      body: ListView.builder(
        itemCount: _surah.ayats.length,
        itemBuilder: (BuildContext context, int index) {
          Ayat ayat = _surah.ayats[index];
          return InkWell(
            onTap: (){},

            child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.00,
                          horizontal: 15.00
                      ),
                      child: Row(
                            children: [
                              Container(
                                  width: 30,
                                  child: Text(ayat.ayat_no)
                              ),
                              Expanded(

                                  child: Container(

                                    child: Column(
                                      children: [
                                        Container(
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
                                        Container(
                                            width: double.infinity,
                                            child: Text(
                                              ayat.text_bn,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontFamily: "Kalpurush"
                                              ),
                                            )
                                        ),

                                      ],
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
    );
  }
}
