import 'package:SyncPlayer/layouts/landscape_player/landscape_player_controls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class videoPlayer extends StatefulWidget {
  final FlickManager flickManager;
  final String username;
  final int id;

  videoPlayer(
      {@required this.flickManager,
      @required this.username,
      @required this.id});

  @override
  _videoPlayerState createState() => _videoPlayerState();
}

class _videoPlayerState extends State<videoPlayer> {
  FlickManager flickManager;
  TextEditingController msgController;
  int complete = 0;

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {});
  }

  @override
  void dispose() {
    super.dispose();
    if (flickManager != null) flickManager.dispose();
    _clearCachedFiles();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void deactivate() {
    _clearCachedFiles();
    super.deactivate();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    flickManager = widget.flickManager;
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
            chatEnabled: false,
          ),
        ),
      ),
    );
  }
}
