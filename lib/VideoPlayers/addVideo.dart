import 'dart:async';
import 'dart:io';
import 'package:SyncPlayer/VideoPlayers/videoJoin.dart';
import 'package:SyncPlayer/VideoPlayers/videoPlayer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'videoCreate.dart';

class addVideo extends StatefulWidget {
  final int Roomid;
  final int type;

  addVideo({@required this.Roomid, @required this.type});

  @override
  _addVideoState createState() => _addVideoState();
}

class _addVideoState extends State<addVideo> {
  VideoPlayerController controller;
  FlickManager flickManager;
  List<String> urls = [];
  bool selected = false;
  String username;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getUsername();
    if (widget.Roomid != -1) createChatRoom();
  }

  createChatRoom() {
    String link =
        "http://harmonpreet012.centralindia.cloudapp.azure.com:8001/createRoom/" +
            widget.Roomid.toString();
    Future<http.Response> response = http.get(link);
  }

  void setVideo(VideoPlayerController controller) {
    flickManager =
        FlickManager(videoPlayerController: controller, onVideoEnd: () {});
  }

  getUsername() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.getString("Username");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            Column(
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
                    BuildContext dialogContext;
                    showDialog(
                        context: context,
                        builder: (dcontext) {
                          dialogContext = dcontext;
                          return SpinKitChasingDots(
                            color: Colors.red,
                            size: 50,
                          );
                        });
                    final file = await pickVideoFile();
                    if (file == null) {
                      Navigator.of(dialogContext).pop();
                      return;
                    }
                    controller = VideoPlayerController.file(file);
                    setVideo(controller);
                    selected = !selected;
                    Navigator.of(dialogContext).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        if (widget.type == 3)
                          return videoCreate(
                            flickManager: flickManager,
                            username: username,
                            id: widget.Roomid,
                          );
                        else if (widget.type == 2)
                          return videoJoin(
                            flickManager: flickManager,
                            username: username,
                            id: widget.Roomid,
                          );
                        else
                          return videoPlayer(
                            flickManager: flickManager,
                            username: username,
                            id: widget.Roomid,
                          );
                      }),
                    );
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
      ),
    );
  }

  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(
      withReadStream: true,
      type: FileType.video,
    ); //type: FileType.video
    if (result == null) return null;
    urls.add(result.files.single.path);
    return File(result.files.single.path);
  }
}
