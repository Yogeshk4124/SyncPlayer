import 'dart:async';
import 'package:SyncPlayer/layouts/landscape_player/landscape_player_controls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class videoCreate extends StatefulWidget {
  final FlickManager flickManager;
  final String username;
  final int id;

  videoCreate(
      {@required this.flickManager,
      @required this.username,
      @required this.id});

  @override
  _videoCreateState createState() => _videoCreateState();
}

class _videoCreateState extends State<videoCreate> {
  FlickManager flickManager;
  TextEditingController msgController;
  int complete=0;
  Timer timer;

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles();
  }
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    if (flickManager != null) flickManager.dispose();
    _clearCachedFiles();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void deactivate() {
    _clearCachedFiles();
    super.deactivate();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // if (flickManager != null) flickManager.dispose();
  }
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    flickManager = widget.flickManager;
    timer=Timer.periodic(Duration(seconds: 1), (Timer t){
      if (complete == 0) {
        complete = 1;
        String time = flickManager.flickVideoManager.videoPlayerValue.isPlaying
            ? flickManager.flickVideoManager.videoPlayerValue.position.inSeconds
            .toString()
            : (-flickManager.flickVideoManager.videoPlayerValue.position.inSeconds)
            .toString();
        String l =
            'http://harmonpreet012.centralindia.cloudapp.azure.com:8000/seekTo/' +
                widget.id.toString() +
                '/' +
                time;

        // Future<http.Response> response = http.get(l);
        Future<http.Response> r = http.post(l);
        r.timeout(Duration(seconds: 1),onTimeout: (){complete=0;return;}).then((value){
          complete = 0;
        });
        // response.then((value) {
        //   complete = 0;
        // });
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
          controls: LandscapePlayerControls(id:widget.id,username:widget.username,chatEnabled: true,),
        ),
      ),
    );
  }
}
