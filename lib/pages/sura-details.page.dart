import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furkan_flutter/bloc/cubut/app_cubit.dart';
import 'package:furkan_flutter/models/ayat.model.dart';
import 'package:furkan_flutter/models/surah.model.dart';
import 'package:furkan_flutter/utils/utils.dart';
import 'package:furkan_flutter/widgets/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
class SurahDetailsPage extends StatefulWidget {
  const SurahDetailsPage({Key? key, required this.surah_no}) : super(key: key);
  final String surah_no;
  @override
  State<SurahDetailsPage> createState() => _SurahDetailsPageState();
}

class _SurahDetailsPageState extends State<SurahDetailsPage> {
  String _surah_no = "";
  List<Surah> _surahs = [];
  late Surah  _surah;
  final YoutubePlayerController _video_controller = YoutubePlayerController(
    params: const YoutubePlayerParams(
      mute: false,
      showControls: true,
      showFullscreenButton: true,
    ),
  );
  bool _isVideoVisible = true;
  @override
  void initState() {
    super.initState();
    AppCubit cubit = context.read<AppCubit>();
    setState((){
      _surahs = cubit.state.surahs!;
      changeSurah(widget.surah_no);
    });
  }

  void changeSurah(String surahNo){
    setState(() {
      _surah_no = surahNo;
      _surah = _surahs.firstWhere((element) => element.no == _surah_no);
      if(_surah.videos.isNotEmpty) {
        if (_isVideoVisible) {
          _video_controller.loadVideoById(videoId: _surah.videos[0].yt_video_id).then((value) => _video_controller.playVideo());
          _video_controller.playVideo();
        } else {
          _video_controller.loadVideoById(videoId: _surah.videos[0].yt_video_id).then((value) => _video_controller.pauseVideo());
        }
      } else {
        _video_controller.close();
      }

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

  toggleVideo(){
    setState(() {
      if(_isVideoVisible){
        _isVideoVisible = false;
        _video_controller.playVideo();
      } else {
        _isVideoVisible = true;
        _video_controller.pauseVideo();
      }
    });

  }

  @override
  void dispose() {
    _video_controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
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
                    return DropdownMenuItem<String>(
                      value: _surah.no,
                      child: SizedBox(
                          child: Text(
                            "${Utils.toBNNumber(_surah.no)}. ${_surah.name_bn}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Kalpurush"
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                      ),
                    );
                  }).toList();
                },
                items: _surahs.map((Surah surah) {
                  return DropdownMenuItem<String>(
                    value: surah.no,
                    child: SizedBox(
                        child: Text(
                          "${Utils.toBNNumber(surah.no)}. ${surah.name_bn}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontFamily: "Kalpurush"
                          ),
                        )
                    ),
                  );

                }).toList()
            )
        ),
        actions: [
          IconButton(onPressed: prevSurah, icon: const Icon(Icons.chevron_left)),
          IconButton(onPressed: nextSurah, icon: const Icon(Icons.chevron_right)),
        ],
        elevation: 0,
        centerTitle: true,
      ),
      body: _surah != null?Column(
          children: [
            VideoPlayer(controller: _video_controller, videos: _surah.videos),
            Expanded(
                child: ListView.separated(
                  itemCount: _surah.ayats.length,
                  itemBuilder: (BuildContext context, int index) {
                    Ayat ayat = _surah.ayats[index];
                    return Column(
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
                                      child: Text(Utils.toBNNumber(ayat.ayat_no), style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),)
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
                    );
                  },
                  separatorBuilder: (BuildContext context, index){
                    return Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.3),
                    );
                  },
                )
            )
          ]
      ):const Text("Nothing to show"),
    );
  }
}

