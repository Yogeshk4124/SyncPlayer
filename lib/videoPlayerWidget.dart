import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      controller != null && controller.value.initialized
          ? Container(alignment: Alignment.topCenter, child: buildVideo())
          : Container(
              height: 200,
              child: Center(child: Text("ADD Video")),
            );

  Widget buildVideo() => Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              buildVideoPlayer(),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.value.isPlaying
                      ? controller.pause()
                      : controller.play(),
                  child: Stack(
                    children: <Widget>[
                      buildPlay(),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: buildIndicator(),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
          Text(controller.value.duration.inSeconds.toString()),
          Text(controller.value.position.inSeconds.toString()),
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      );

  Widget buildIndicator() => VideoProgressIndicator(
        controller,
        allowScrubbing: true,
      );

  Widget buildPlay() => controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: Icon(Icons.play_arrow, color: Colors.white, size: 40),
        );
}
