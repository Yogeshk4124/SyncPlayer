import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'landscape_player_controls.dart';

class LandscapePlayer extends StatefulWidget {
  final FlickManager flickManager;
  final int id;
  LandscapePlayer({@required this.flickManager,@required this.id});

  @override
  _LandscapePlayerState createState() => _LandscapePlayerState();
}

class _LandscapePlayerState extends State<LandscapePlayer> {
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager=widget.flickManager;
    // flickManager = FlickManager(
    //     // videoPlayerController:
    //         // VideoPlayerController.network(mockData["items"][2]["trailer_url"]));
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlickVideoPlayer(
        flickManager: flickManager,
        preferredDeviceOrientation: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft
        ],
        systemUIOverlay: [],
        flickVideoWithControls: FlickVideoWithControls(
          controls: LandscapePlayerControls(id:widget.id),
        ),
      ),
    );
  }
}
