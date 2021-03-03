import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import '../layouts/custom_orientation_player/controls.dart';
import '../layouts/custom_orientation_player/data_manager.dart';

class VideoJoin extends StatefulWidget {
  final int Roomid;

  VideoJoin({@required this.Roomid});

  @override
  _VideoJoinState createState() => _VideoJoinState();
}

class _VideoJoinState extends State<VideoJoin> {
  FlickManager flickManager;
  DataManager dataManager;
  VideoPlayerController controller;
  List<String> urls = [];
  int f = 1, complete = 0;

  @override
  void initState() {
    super.initState();
    flickManager = null;
  }

  void setVideo(VideoPlayerController controller) {
    flickManager = FlickManager(
        videoPlayerController: controller,
        onVideoEnd: () {
          dataManager.skipToNextVideo(Duration(seconds: 5));
        });
    dataManager = DataManager(flickManager: flickManager, urls: urls);
  }

  @override
  void dispose() {
    if (flickManager != null) flickManager.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (flickManager != null) flickManager.dispose();
  }

  skipToVideo(String url) {
    // flickManager.handleChangeVideo(VideoPlayerController.network(url));
  }

//0:01:39.251000
  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 5), (Timer t) async {
      // print('http://20.197.61.11:8000/getCurrentSecond/' +
      //     widget.Roomid.toString());
      if (flickManager != null && complete == 0) {
        complete = 1;
        String link = 'http://20.197.61.11:8000/getCurrentSecond/' +
            widget.Roomid.toString();
        // print("jlink:"+link);
        Future<http.Response> response = http.get(link);
        response.then((value) {
          complete = 0;
          var decodedData = jsonDecode(value.body);
          print("jcur:"+decodedData['second'].toString());
          print("diff"+(int.parse(flickManager.flickVideoManager.videoPlayerValue.position.inSeconds.toString())-int.parse(decodedData['second'].toString())).abs().toString());
          if (decodedData['second'].toString() == '-1'.toString()) {
            print("pausing");
            flickManager.flickControlManager.pause();
          }else if((int.parse(flickManager.flickVideoManager.videoPlayerValue.position.inSeconds.toString())-int.parse(decodedData['second'].toString())).abs()>2){
            print('here2');
            flickManager.flickControlManager
                .seekTo(Duration(seconds: int.parse(decodedData['second'].toString())));
            flickManager.flickControlManager.play();
          }
          else {
            print("here3");
            flickManager.flickControlManager.play();
          }
        });
      }
    });

    if (f == 1 && flickManager != null) {
      f = 0;
      flickManager.flickVideoManager.addListener(() {
        setState(() {});
      });
    }
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Video Player",
            style: GoogleFonts.aBeeZee(fontSize: 30),
          ),
        ),
        if (flickManager != null)
          VisibilityDetector(
              key: ObjectKey(flickManager),
              onVisibilityChanged: (visibility) {
                if (visibility.visibleFraction == 0 && this.mounted) {
                  flickManager.flickControlManager.autoPause();
                } else if (visibility.visibleFraction == 1) {
                  flickManager.flickControlManager.autoResume();
                }
              },
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: FlickVideoPlayer(
                      flickManager: flickManager,
                      preferredDeviceOrientationFullscreen: [
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.landscapeRight,
                      ],
                      flickVideoWithControls: FlickVideoWithControls(
                        controls: CustomOrientationControls(
                          dataManager: dataManager,
                        ),
                      ),
                      flickVideoWithControlsFullscreen: FlickVideoWithControls(
                        videoFit: BoxFit.fitWidth,
                        controls: CustomOrientationControls(
                          dataManager: dataManager,
                        ),
                      ),
                    ),
                  )
                ],
              ))
        else
          Container(
            child: Text("Add Video"),
          ),
        MaterialButton(
          padding: EdgeInsets.all(20),
          onPressed: () async {
            final file = await pickVideoFile();
            if (file == null) return;
            setState(() {
              controller = VideoPlayerController.file(file);
              setVideo(controller);
            });
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Icon(
              Icons.video_call_sharp,
              size: 60,
            ),
          ),
        ),
      ],
    );
  }

  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(); //type: FileType.video
    if (result == null) return null;
    urls.add(result.files.single.path);
    return File(result.files.single.path);
  }
}
