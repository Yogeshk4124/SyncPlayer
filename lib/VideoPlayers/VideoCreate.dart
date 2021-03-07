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
import '../BottomNav.dart';
import '../layouts/custom_orientation_player/controls.dart';
import '../layouts/custom_orientation_player/data_manager.dart';
import 'package:adv_fab/adv_fab.dart';

class VideoCreate extends StatefulWidget {
  final int Roomid;

  VideoCreate({@required this.Roomid});

  @override
  _VideoCreateState createState() => _VideoCreateState();

  @override
  _VideoCreateState destroyState() => null;
}

class _VideoCreateState extends State<VideoCreate> {
  FlickManager flickManager;
  DataManager dataManager;
  VideoPlayerController controller;
  List<String> urls = [];
  Widget d;
  AdvFabController FABcontroller;
  bool selected = false;
  int f = 1, complete = 0;
  List msg;

  @override
  void initState() {
    super.initState();
    msg = new List();
    String link =
        "http://harmonpreet012.centralindia.cloudapp.azure.com:8001/createRoom/" + widget.Roomid.toString();
    Future<http.Response> response = http.get(link);
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
    print("disposing");
    _clearCachedFiles();
    super.dispose();
  }

  @override
  void deactivate() {
    _clearCachedFiles();
    super.deactivate();
  }

  // void onBack
  skipToVideo(String url) {
    // flickManager.handleChangeVideo(VideoPlayerController.network(url));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () async {
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
                  // if (flickManager != null) flickManager.dispose();
                  // _clearCachedFiles();
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (BuildContext context) => Home4()),
                  //   (route) => false,
                  // );
                },
                child: Text("No"),
              ),
            ],
          ),
        ) ??
        false;
  }

//0:01:39.251000
  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 1), (Timer t) async {
      if (flickManager != null && complete == 0) {
        complete = 1;
        // print("cur:" +
        //     flickManager.flickVideoManager.videoPlayerValue.position.inSeconds
        //         .toString());
        String time = flickManager.flickVideoManager.videoPlayerValue.isPlaying
            ? flickManager.flickVideoManager.videoPlayerValue.position.inSeconds
                .toString()
            : '-1';
        // http.Response response = await http.get(
        //     'http://20.197.61.11:8000/seekTo/' +
        //         widget.Roomid.toString() +
        //         '/' +
        //         time);
        String l = 'http://harmonpreet012.centralindia.cloudapp.azure.com:8000/seekTo/' +
            widget.Roomid.toString() +
            '/' +
            time;
        // print("link:" + l);
        Future<http.Response> response = http.get(l);
        response.then((value) {
          setState(() {
            complete = 0;
          });
        });
      }
    });
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
          floatingActionButton: selected
              ? AdvFab(
                  showLogs: true,
                  onFloatingActionButtonTapped: () async {
                    msg.clear();
                    http.Response response = await http.get(
                        "http://harmonpreet012.centralindia.cloudapp.azure.com:8001/getMessages/" +
                            widget.Roomid.toString());
                    var decodedData = jsonDecode(response.body);
                    for (dynamic res in decodedData) {
                      msg.add([res[0].toString(), res[1].toString()]);
                    }
                    print(msg.toString());
                    FABcontroller.isCollapsed
                        ? FABcontroller.expandFAB()
                        : FABcontroller.collapseFAB();
                  },
                  floatingActionButtonIcon:
                      CupertinoIcons.chat_bubble_text_fill,
                  useAsFloatingActionButton: true,
                  useAsNavigationBar: false,
                  floatingActionButtonIconColor: Colors.white,
                  floatingActionButtonExpendedWidth: 90,
                  navigationBarIconActiveColor: Colors.pink,
                  navigationBarIconInactiveColor:
                      Colors.pink[200].withOpacity(0.6),
                  collapsedColor: Colors.red,
                  controller: FABcontroller,
                  useAsFloatingSpaceBar: false,
                )
              : null,
          // FloatingActionButton(
          //   onPressed: () {},
          //   backgroundColor: Colors.red,
          //   child: Icon(CupertinoIcons.chat_bubble_text_fill,color: Colors.white,),
          // ),
          body: SafeArea(
            top: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text('MOVIE NIGHT !!',style: GoogleFonts.bungee(),),
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
                              selected = !selected;
                              FABcontroller.setExpandedWidgetConfiguration(
                                showLogs: true,
                                heightToExpandTo:
                                    MediaQuery.of(context).size.height * 0.10,
                                expendedBackgroundColor: Colors.redAccent,
                                withChild: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    color: Colors.red,
                                    width: (MediaQuery.of(context).size.width),
                                    height:
                                        (MediaQuery.of(context).size.height /
                                                100) *
                                            50,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              FABcontroller.isCollapsed
                                                  ? FABcontroller.expandFAB()
                                                  : FABcontroller.collapseFAB();
                                            });
                                          },
                                          icon: Icon(CupertinoIcons.arrow_left),
                                        ),
                                        Text("hello",style: TextStyle(color: Colors.white,fontSize: 20),),
                                        Column(
                                          children: <Widget>[
                                            for (dynamic m in msg)
                                              Column(
                                                children: [
                                                  Text(m[0].toString()),
                                                  Text(m[1].toString()),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
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
