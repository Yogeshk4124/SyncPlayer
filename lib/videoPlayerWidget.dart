import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final int Roomid;

  VideoPlayerWidget({
    Key key,
    @required this.controller,
    @required this.Roomid,
  }) : super(key: key);
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    // Timer.periodic(Duration(seconds: 1), (Timer t) {
    //   // Future<http.Response> response = http.get('http://20.197.61.11:8000/seekTo/'+Roomid.toString()+"/"+controller.value.position.inSeconds.toString());
    // });
    return controller != null && controller.value.initialized
        ? Container(alignment: Alignment.topCenter, child: buildVideo())
        : Container(
            height: 200,
            child: Center(child: Text("ADD Video")),
          );
  }

  Widget buildVideo() => Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              buildVideoPlayer(),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  },
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
          Text(Roomid.toString()),
          Text(controller.value.duration.inSeconds.toString()),
          Text(controller.value.position.inSeconds.toString()),
        ],
      );

  Widget buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );

    // return RotatedBox(
    //   quarterTurns: 2,
    //   child:  AspectRatio(
    //     aspectRatio: controller.value.aspectRatio,
    //     child: VideoPlayer(controller),
    //   ),
    // );

    // return AspectRatio(
    //     aspectRatio: controller.value.aspectRatio,
    //     child: RotatedBox(
    //       quarterTurns: 90,
    //       child: VideoPlayer(controller),
    //     ));
  }

  Widget buildIndicator() {
    return Column(
      children: [
        VideoProgressIndicator(
          controller,
          allowScrubbing: true,
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  },
                  child: controller.value.isPlaying
                      ? Icon(Icons.pause)
                      : Icon(Icons.play_arrow),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.fullscreen),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPlay() => controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: Icon(Icons.play_arrow, color: Colors.white, size: 40),
        );
}
