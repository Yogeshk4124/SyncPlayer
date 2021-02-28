import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'layouts/custom_orientation_player/controls.dart';
import 'layouts/custom_orientation_player/data_manager.dart';
import 'package:adv_fab/adv_fab.dart';

class V extends StatefulWidget {
  final int Roomid;

  V({@required this.Roomid});

  @override
  _VState createState() => _VState();
}

class _VState extends State<V> {
  FlickManager flickManager;
  DataManager dataManager;
  VideoPlayerController controller;
  List<String> urls = [];
  Widget d;
  AdvFabController FABcontroller;
  bool selected=false;
  @override
  void initState() {
    super.initState();
    FABcontroller = AdvFabController();
    // flickManager = FlickManager(
    //     videoPlayerController: VideoPlayerController.network(
    //       urls[0],
    //     ),
    //     onVideoEnd: () {
    //       dataManager.skipToNextVideo(Duration(seconds: 5));
    //     });
    flickManager = null;
    // dataManager = DataManager(flickManager: flickManager, urls: urls);
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
    Timer.periodic(Duration(seconds: 1), (Timer t) async {
      if (flickManager != null) {
        // print(flickManager.flickVideoManager.videoPlayerValue.position.inSeconds.toString());
        String time = flickManager.flickVideoManager.videoPlayerValue.isPlaying
            ? flickManager.flickVideoManager.videoPlayerValue.position.inSeconds
                .toString()
            : '-1';
        http.Response response = await http.get(
            'http://20.197.61.11:8000/seekTo/' +
                widget.Roomid.toString() +
                '/' +
                time);
      }
    });

    if (flickManager != null)
      flickManager.flickVideoManager.addListener(() {
        setState(() {});
      });
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: AdvFab(
        showLogs: true,
        onFloatingActionButtonTapped: () {
          FABcontroller.isCollapsed
              ? FABcontroller.expandFAB()
              : FABcontroller.collapseFAB();
        },
        floatingActionButtonIcon: Icons.add,
        floatingActionButtonIconColor: Colors.red,
        navigationBarIconActiveColor: Colors.pink,
        navigationBarIconInactiveColor: Colors.pink[200].withOpacity(0.6),
        collapsedColor: Colors.grey[200],
        controller: FABcontroller,
        useAsFloatingSpaceBar: true,
      ),
      // FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Colors.red,
      //   child: Icon(CupertinoIcons.chat_bubble_text_fill,color: Colors.white,),
      // ),
      body: Column(
        children: <Widget>[
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
                        flickVideoWithControlsFullscreen:
                            FlickVideoWithControls(
                          videoFit: BoxFit.fitWidth,
                          controls: CustomOrientationControls(
                            dataManager: dataManager,
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          else
            Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/video.jpeg",
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height * 0.60,
                ),
                Text(
                  'Get Ready!!',
                  style: GoogleFonts.bungee(fontSize: 32),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Stream',
                        style: GoogleFonts.roboto(),
                      ),
                      Text(
                        'Movie',
                        style: GoogleFonts.roboto(),
                      ),
                      Text(
                        'Enjoy',
                        style: GoogleFonts.roboto(),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    final file = await pickVideoFile();
                    if (file == null) return;
                    setState(() {
                      controller = VideoPlayerController.file(file);
                      setVideo(controller);
                      FABcontroller.setExpandedWidgetConfiguration(
                        showLogs: true,
                        heightToExpandTo: 25,
                        expendedBackgroundColor: Colors.blue[300],
                        withChild: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: (MediaQuery.of(context).size.width),
                            height:
                            (MediaQuery.of(context).size.height / 100) * 20,
                            child: Image.asset("assets/images/video.jpeg"),
                          ),
                        ),
                      );

                    });
                  },
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xffFF2929),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text('ADD VIDEO')),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(); //type: FileType.video
    if (result == null) return null;
    urls.add(result.files.single.path);
    return File(result.files.single.path);
  }
}
