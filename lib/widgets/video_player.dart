import 'package:flutter/material.dart';
import 'package:furkan_flutter/models/surah.model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayer extends StatefulWidget{
  const VideoPlayer({super.key, required this.controller, required this.videos});
  final YoutubePlayerController controller;
  final List<SurahVideo> videos;

  @override
  State<StatefulWidget> createState()=>  _VideoPlayer();


}

class _VideoPlayer extends State<VideoPlayer>{
  SurahVideo? _value;
  bool _visible = true;
  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  void didUpdateWidget(covariant VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.videos != widget.videos){
      init();
    }
  }

  void init(){
    setState(() {
      if(widget.videos.isNotEmpty){
        _value = widget.videos[0];
      } else {
        _value = null;
      }
    });
  }

  void onChange(SurahVideo video){
    setState(() {
      _value = video;
      widget.controller.loadVideoById(videoId: video.yt_video_id);
    });
  }

  void toggleVideo(){
    setState(() {
      _visible = !_visible;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          width: double.infinity,
          height: _visible? ((MediaQuery.of(context).size.width/16) * 9) + 50 : 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(),
          onEnd: (){
            if(_visible){
              widget.controller.playVideo();
            } else {
              widget.controller.pauseVideo();
            }
          },
          child: Column(
            children: [
              YoutubePlayer(
                controller: widget.controller,
                aspectRatio: 16 / 9,
              ),
              Container(
                  width: double.infinity,
                  height: 50,

                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child:DropdownButtonHideUnderline(
                      child:  DropdownButton<SurahVideo>(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        value: _value,
                        selectedItemBuilder: (BuildContext context){
                          return widget.videos.map((SurahVideo video) {
                            return DropdownMenuItem<SurahVideo>(
                              value: video,
                              child: SizedBox(width: 300,child:Text(video.title, overflow: TextOverflow.ellipsis,)),
                            );
                          }).toList();
                        },
                        items: widget.videos.map((SurahVideo video) {
                          return DropdownMenuItem<SurahVideo>(
                            value: video,
                            child: SizedBox(width: double.infinity,child:Text(video.title, overflow: TextOverflow.ellipsis,)),
                          );
                        }).toList(),
                        onChanged: (_) {
                          if(_ !=null) {
                            onChange(_);
                          }
                        },
                      )
                  )
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: InkWell(
            onTap: toggleVideo,
            child:  Icon(_visible? Icons.arrow_drop_up : Icons.arrow_drop_down, size: 40,),
          ),
        )
      ],
    );
  }

}