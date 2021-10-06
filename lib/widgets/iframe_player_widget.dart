import 'package:flutter/material.dart';
import 'package:news_app/services/app_service.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class IframePlayerWidget extends StatefulWidget {

  const IframePlayerWidget({Key? key, required this.youtubeVideoUrl}) : super(key: key);
  final String youtubeVideoUrl;

  @override
  _IframePlayerWidgetState createState() => _IframePlayerWidgetState();
}

class _IframePlayerWidgetState extends State<IframePlayerWidget> {

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: AppService.getYoutubeVideoIdFromUrl(widget.youtubeVideoUrl),
      params: YoutubePlayerParams(
        autoPlay: false,
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        loop: true,
        strictRelatedVideos: true,
        showVideoAnnotations: false,
        playsInline: true,
        enableCaption: false

      ),
    
    )..listen((value) {
      if (value.isReady && !value.hasPlayed) {
        _controller..hideTopMenu()..hideYoutubeLogo();
      }
      if (value.hasPlayed) {
        _controller..hideEndScreen();
      }
    });
    
  }


  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerIFrame(
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }
}