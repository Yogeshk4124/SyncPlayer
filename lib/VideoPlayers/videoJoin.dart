import 'dart:async';
import 'dart:convert';
import 'package:SyncPlayer/layouts/landscape_player/landscape_player_controls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class videoJoin extends StatefulWidget {
  final FlickManager flickManager;
  final String username;
  final int id;

  videoJoin(
      {@required this.flickManager,
      @required this.username,
      @required this.id});

  @override
  _videoJoinState createState() => _videoJoinState();
}

class _videoJoinState extends State<videoJoin> {
  FlickManager flickManager;
  TextEditingController msgController;
  int complete = 0;
  Timer timer;

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    // if (flickManager != null) flickManager.dispose();
    _clearCachedFiles();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void deactivate() {
    _clearCachedFiles();
    super.deactivate();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // if (flickManager != null) flickManager.dispose();
    // if (flickManager != null) flickManager.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    flickManager = widget.flickManager;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (complete == 0) {
        print("joining call");
        complete = 1;
        String l =
            'http://harmonpreet012.centralindia.cloudapp.azure.com:8000/getCurrentSecond/' +
                widget.id.toString();
        // Future<http.Response> response = http.get(l);
        // response.then((value) {
        //     var decodedData = jsonDecode(value.body);
        //     int time=int.parse(decodedData['second'].toString());
        //     if (time < 0) {
        //       print("video -negative");
        //       flickManager.flickControlManager.pause();
        //       flickManager.flickControlManager.seekTo(Duration(seconds: time.abs()));
        //     } else if ((flickManager.flickVideoManager
        //                     .videoPlayerValue.position.inSeconds-
        //                 time).abs() > 4) {
        //       print("video +positive");
        //       flickManager.flickControlManager.seekTo(Duration(
        //           seconds: time+1));
        //       flickManager.flickControlManager.play();
        //     } else {
        //       print("video =neutral");
        //       flickManager.flickControlManager.play();
        //     }complete = 0;
        //   });
        Future<http.Response> r = http.get(l);
        r.timeout(Duration(seconds: 1), onTimeout: () {
          complete = 0;
          print("timeout");
          return;
        }).then((value) {
          print("success");
          var decodedData = jsonDecode(value.body);
          int time = int.parse(decodedData['second'].toString());
          if (time <= 0) {
            // print("video -negative");
            flickManager.flickControlManager.pause();
            flickManager.flickControlManager
                .seekTo(Duration(seconds: time.abs()));
          } else if ((flickManager.flickVideoManager.videoPlayerValue.position
                          .inSeconds -
                      time)
                  .abs() >
              4) {
            // print("video +positive");
            flickManager.flickControlManager
                .seekTo(Duration(seconds: time + 1));
            flickManager.flickControlManager.play();
          } else {
            // print("video =neutral");
            flickManager.flickControlManager.play();
          }
          complete = 0;
        });
      }
    });
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
          controls: LandscapePlayerControls(
            id: widget.id,
            username: widget.username,
            chatEnabled: true,
          ),
        ),
      ),
    );
  }
}
