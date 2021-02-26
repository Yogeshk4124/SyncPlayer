import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import './multi_manager/flick_multi_manager.dart';
import './multi_manager/flick_multi_player.dart';

class FeedPlayer extends StatefulWidget {
  FeedPlayer({Key key}) : super(key: key);

  @override
  _FeedPlayerState createState() => _FeedPlayerState();
}

class _FeedPlayerState extends State<FeedPlayer> {
  List items = [
    {
      "title": "Rio from Above",
      "image": "images/rio_from_above_poster.jpg",
      "trailer_url":
      " https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/example/rio_from_above_compressed.mp4?raw=true",
    },
    {
      "title": "The Valley",
      "image": "images/the_valley_poster.jpg",
      "trailer_url":
      "https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/example/the_valley_compressed.mp4?raw=true",
    },
    {
      "title": "Iceland",
      "image": "images/iceland_poster.jpg",
      "trailer_url":
      " https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/example/iceland_compressed.mp4?raw=true",
    },
    {
      "title": "9th May & Fireworks",
      "image": "images/9th_may_poster.jpg",
      "trailer_url":
      " https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/example/9th_may_compressed.mp4?raw=true",
    },
  ];

  FlickMultiManager flickMultiManager;

  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickMultiManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickMultiManager.pause();
        }
      },
      child: Container(
        child: ListView.separated(
          separatorBuilder: (context, int) => Container(
            height: 50,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
                height: 400,
                margin: EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FlickMultiPlayer(
                    url: items[index]['trailer_url'],
                    flickMultiManager: flickMultiManager,
                    image: items[index]['image'],
                  ),
                ));
          },
        ),
      ),
    );
  }
}
