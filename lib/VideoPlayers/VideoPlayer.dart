import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../BottomNav.dart';
import '../layouts/custom_orientation_player/controls.dart';
import '../layouts/custom_orientation_player/data_manager.dart';

class VideoPlayer extends StatefulWidget {
  @override
  _VideoPlayerState createState() => _VideoPlayerState();

  @override
  _VideoPlayerState destroyState() => null;
}

class _VideoPlayerState extends State<VideoPlayer> {
  FlickManager flickManager;
  DataManager dataManager;
  VideoPlayerController controller;
  List<String> urls = [];
  Widget d;
  bool selected = false;
  int f = 1, complete = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
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
    _clearCachedFiles();
    super.dispose();
  }

  skipToVideo(String url) {
    // flickManager.handleChangeVideo(VideoPlayerController.network(url));
  }

  // @override
  // void deactivate() {
  //   _clearCachedFiles();
  //   super.deactivate();
  // }

//0:01:39.251000
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () async{
              // if (flickManager != null) flickManager.dispose();
              // _clearCachedFiles();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Home4()),
                    (route) => false,
              );
            },
            child: Text("Yes"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pop(false);
            },
            child: Text("No"),
          ),
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    if (f == 1 && flickManager != null) {
      f = 0;
      flickManager.flickVideoManager.addListener(() {
        setState(() {});
      });
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            top: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                            padding: EdgeInsets.only(bottom: 16),
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
                          MaterialButton(
                            onPressed: () {},
                            child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text("LEAVE")),
                          ),
                        ],
                      ))
                else
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/video.jpeg",
                          fit: BoxFit.fill,
                          height: MediaQuery.maybeOf(context).size.height * 0.60,
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
                              selected = !selected;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              decoration: BoxDecoration(
                                color: Color(0xffFF2929),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Text('ADD VIDEO')),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform
        .pickFiles(withReadStream: true); //type: FileType.video
    if (result == null) return null;
    urls.add(result.files.single.path);
    return File(result.files.single.path);
  }
}
