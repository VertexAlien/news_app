import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news_app/services/app_service.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/widgets/full_image.dart';
import 'package:news_app/widgets/iframe_player_widget.dart';
import 'package:news_app/widgets/local_video_player.dart';

  // final String demoText = "<p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s</p>" + 
  // //'''<iframe width="560" height="315" src="https://www.youtube.com/embed/-WRzl9L4z3g" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'''+
  // '''<video controls src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"></video>''' + 
  // "<p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s</p>";

class HtmlBodyWidget extends StatelessWidget {
  const HtmlBodyWidget({
    Key? key,
    required this.htmlData,
  }) : super(key: key);

  final String htmlData;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: '''$htmlData''',
      onLinkTap: (String? url, RenderContext context1,
          Map<String, String> attributes, _) {
        AppService().openLinkWithCustomTab(context, url!);
      },
      onImageTap: (String? url, RenderContext context1,
          Map<String, String> attributes, _) {
        nextScreen(context, FullScreenImage(imageUrl: url!));
      },
      style: {
        "body": Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          fontSize: FontSize(17.0),
          lineHeight: LineHeight(1.4),
        ),
        "figure": Style(margin: EdgeInsets.zero, padding: EdgeInsets.zero),
        "h2": Style(letterSpacing: -0.7, wordSpacing: 0.5)
      },
      customRender: {
        "img": (RenderContext context1, Widget child){
          final String _imageSource = context1.tree.element!.attributes['src'].toString();
          return InkWell(
              child: Hero(
              tag: _imageSource,
                child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: CachedNetworkImageProvider(_imageSource), fit: BoxFit.cover)
                ),
              ),
            ),

            onTap: ()=> nextScreen(context, FullScreenImage(imageUrl: _imageSource)),
          );
        },
        "video": (RenderContext context1, Widget child) {
          final String _videoSource = context1.tree.element!.attributes['src'].toString();
          return LocalVideoPlayer(videoUrl: _videoSource);
        },
        "iframe": (RenderContext context1, Widget child) {
          final String _videoSource = context1.tree.element!.attributes['src'].toString();
          return IframePlayerWidget(youtubeVideoUrl: _videoSource);
        },
      },
    );
  }
}
