import 'package:SyncPlayer/layouts/animation_player/portrait_video_controls.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:video_player/video_player.dart';

import './data_manager.dart';
import 'landscape_controls.dart';

class AnimationPlayer extends StatefulWidget {
  AnimationPlayer({Key key}) : super(key: key);

  @override
  _AnimationPlayerState createState() => _AnimationPlayerState();
}

class _AnimationPlayerState extends State<AnimationPlayer> {
  FlickManager flickManager;
  AnimationPlayerDataManager dataManager;
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
  bool _pauseOnTap = true;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.network(items[0]['trailer_url']),
      onVideoEnd: () => dataManager.playNextVideo(
        Duration(seconds: 5),
      ),
    );

    dataManager = AnimationPlayerDataManager(flickManager, items);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager.autoResume();
        }
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FlickVideoPlayer(
                flickManager: flickManager,
                flickVideoWithControls: AnimationPlayerPortraitVideoControls(
                    dataManager: dataManager, pauseOnTap: _pauseOnTap),
                flickVideoWithControlsFullscreen: FlickVideoWithControls(
                  controls: AnimationPlayerLandscapeControls(
                    animationPlayerDataManager: dataManager,
                  ),
                ),
              ),
            ),
            RaisedButton(
              child: Text('Next video'),
              onPressed: () => dataManager.playNextVideo(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('On tap action -- '),
                Row(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            _pauseOnTap = true;
                          });
                        },
                        child: Text('Pause')),
                    Switch(
                      value: !_pauseOnTap,
                      onChanged: (value) {
                        setState(() {
                          _pauseOnTap = !value;
                        });
                      },
                      activeColor: Colors.red,
                      inactiveThumbColor: Colors.blue,
                      inactiveTrackColor: Colors.blue[200],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pauseOnTap = false;
                        });
                      },
                      child: Text(
                        'Mute',
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
