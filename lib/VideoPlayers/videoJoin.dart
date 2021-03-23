import 'dart:async';
import 'dart:convert';
import 'package:SyncPlayer/layouts/landscape_player/landscape_player_controls.dart';
import 'package:adv_fab/adv_fab.dart';
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
  AdvFabController FABcontroller;
  FlickManager flickManager;
  TextEditingController msgController;
  int complete = 0;
  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      // _scaffoldKey.currentState.showSnackBar(
      //   SnackBar(
      //     backgroundColor: result ? Colors.green : Colors.red,
      //     content: Text((result
      //         ? 'Temporary files removed with success.'
      //         : 'Failed to clean temporary files')),
      //   ),
      // );
    });
  }
  @override
  void dispose() {
    super.dispose();
    if (flickManager != null) flickManager.dispose();
    _clearCachedFiles();
  }

  @override
  void deactivate() {
    _clearCachedFiles();
    super.deactivate();
    // if (flickManager != null) flickManager.dispose();
  }
  @override
  void initState() {
    super.initState();
    flickManager = widget.flickManager;
    Timer.periodic(Duration(seconds: 1), (Timer t) async {
      if (complete == 0) {
        complete = 1;
        String time = flickManager.flickVideoManager.videoPlayerValue.isPlaying
            ? flickManager.flickVideoManager.videoPlayerValue.position.inSeconds
                .toString()
            : '-1';
        String l =
            'http://harmonpreet012.centralindia.cloudapp.azure.com:8000/getCurrentSecond/' +
                widget.id.toString();
        Future<http.Response> response = http.get(l);
        response.then((value) {
          setState(() {
            complete = 0;
            var decodedData = jsonDecode(value.body);
            // print("jcur:" + decodedData['second'].toString());
            // print("diff" +
            //     (int.parse(flickManager
            //                 .flickVideoManager.videoPlayerValue.position.inSeconds
            //                 .toString()) -
            //             int.parse(decodedData['second'].toString()))
            //         .abs()
            //         .toString());
            if (decodedData['second'].toString() == '-1'.toString()) {
              // print("pausing");
              flickManager.flickControlManager.pause();
            } else if ((int.parse(flickManager.flickVideoManager
                            .videoPlayerValue.position.inSeconds
                            .toString()) -
                        int.parse(decodedData['second'].toString()))
                    .abs() >
                3) {
              // print('here2');
              flickManager.flickControlManager.seekTo(Duration(
                  seconds: int.parse(decodedData['second'].toString())));
              flickManager.flickControlManager.play();
            } else {
              // print("here3");
              flickManager.flickControlManager.play();
            }
          });
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
          controls:
              LandscapePlayerControls(id: widget.id, username: widget.username,chatEnabled: true,),
        ),
      ),
    );
  }
}
