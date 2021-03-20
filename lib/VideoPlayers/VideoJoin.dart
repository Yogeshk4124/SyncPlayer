import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:SyncPlayer/Utils/Messages.dart';
import 'package:adv_fab/adv_fab.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../BottomNav.dart';
import '../Chats.dart';
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
  AdvFabController FABcontroller;
  bool selected = false;
  TextEditingController msgController;
  SharedPreferences sharedPreferences;
  String username;

  @override
  void initState() {
    super.initState();
    getUsername();
    FABcontroller = AdvFabController();
    msgController = new TextEditingController();
    flickManager = null;
  }
  getUsername()async{
    sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      username=sharedPreferences.getString("Username");
    });
    print("username On Call:"+username);
  }
  void setVideo(VideoPlayerController controller) {
    flickManager = FlickManager(
        videoPlayerController: controller,
        onVideoEnd: () {
          dataManager.skipToNextVideo(Duration(seconds: 5));
        });
    dataManager = DataManager(flickManager: flickManager, urls: urls);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    print("username On build:"+username.toString());
    Timer.periodic(Duration(seconds: 5), (Timer t) async {
      // print('http://20.197.61.11:8000/getCurrentSecond/' +
      //     widget.Roomid.toString());
      if (flickManager != null && complete == 0) {
        complete = 1;
        String link =
            'http://harmonpreet012.centralindia.cloudapp.azure.com:8000/getCurrentSecond/' +
                widget.Roomid.toString();
        // print("jlink:"+link);
        Future<http.Response> response = http.get(link);
        response.then((value) {
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
          } else if ((int.parse(flickManager
                          .flickVideoManager.videoPlayerValue.position.inSeconds
                          .toString()) -
                      int.parse(decodedData['second'].toString()))
                  .abs() >
              3) {
            // print('here2');
            flickManager.flickControlManager.seekTo(
                Duration(seconds: int.parse(decodedData['second'].toString())));
            flickManager.flickControlManager.play();
          } else {
            // print("here3");
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: selected
              ? AdvFab(
                  showLogs: true,
                  onFloatingActionButtonTapped: () {
                    FABcontroller.isCollapsed
                        ? FABcontroller.expandFAB()
                        : FABcontroller.collapseFAB();
                  },
                  floatingActionButtonIcon:
                      CupertinoIcons.chat_bubble_text_fill,
                  useAsFloatingActionButton: true,
                  useAsNavigationBar: false,
                  floatingActionButtonIconColor: Colors.red,
                  floatingActionButtonExpendedWidth: 90,
                  navigationBarIconActiveColor: Colors.pink,
                  navigationBarIconInactiveColor:
                      Colors.pink[200].withOpacity(0.6),
                  collapsedColor: Color(0xff121212),
                  controller: FABcontroller,
                  useAsFloatingSpaceBar: false,
                )
              : null,
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
                              FABcontroller.setExpandedWidgetConfiguration(
                                showLogs: true,
                                forceCustomHeight: true,
                                heightToExpandTo:
                                    MediaQuery.maybeOf(context).size.height * 0.1,
                                expendedBackgroundColor: Colors.red,
                                withChild: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Container(
                                    color: Colors.transparent,
                                    width: (MediaQuery.maybeOf(context).size.width),
                                    height:
                                        (MediaQuery.maybeOf(context).size.height *
                                            0.60),
                                    // (MediaQuery.maybeOf(context).size.height /
                                    //         100) *
                                    //     60,
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
                                        ChangeNotifierProvider(
                                          create: (context) => Chats(username),
                                          child: Messages(
                                            roomid: widget.Roomid,
                                          ),
                                        ),
                                        // Messages(roomid: widget.Roomid,),
                                        Spacer(
                                          flex: 5,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: TextField(
                                                      controller: msgController,
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 15),
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.black))),
                                              IconButton(
                                                  icon: Icon(Icons.send,
                                                      color: Colors.black),
                                                  onPressed: () async {
                                                    String s =
                                                        "http://harmonpreet012.centralindia.cloudapp.azure.com:8001/sendMessage/" +
                                                            widget.Roomid
                                                                .toString() +
                                                            "/"+username+"/" +
                                                            msgController.text;
                                                    // print("calling:" + s);
                                                    http.Response
                                                        response =
                                                        await http.get(s);
                                                    msgController.clear();
                                                  }),
                                            ],
                                          ),
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
                // MaterialButton(
                //   padding: EdgeInsets.all(20),
                //   onPressed: () async {
                //     final file = await pickVideoFile();
                //     if (file == null) return;
                //     setState(() {
                //       controller = VideoPlayerController.file(file);
                //       setVideo(controller);
                //     });
                //   },
                //   child: Container(
                //       padding: EdgeInsets.symmetric(
                //           horizontal: 25, vertical: 10),
                //       decoration: BoxDecoration(
                //         color: Color(0xffFF2929),
                //         borderRadius:
                //         BorderRadius.all(Radius.circular(20)),
                //       ),
                //       child: Text('ADD VIDEO')),
                // ),
              ],
            ),
          )),
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
