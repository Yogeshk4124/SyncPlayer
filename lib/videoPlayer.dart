import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'videoPlayerWidget.dart';
class videoPlayer extends StatefulWidget {
  // final int RoomId;
  // videoPlayer({@required this.RoomId});
  @override
  _videoPlayerState createState() => _videoPlayerState();
}
class _videoPlayerState extends State<videoPlayer> {
  final File file = null;
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    if (file!=null&&file.existsSync()) {
      controller = VideoPlayerController.file(file)
        ..addListener(() => setState(() {}))
        ..setLooping(true)
        ..initialize().then((_) => controller.play());
    }
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 1), (Timer t) async {
      http.Response response = await http.get(
          'http://20.197.61.11:8000/getCurrentSecond/');
    });
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            VideoPlayerWidget(controller: controller),
            buildAddButton(),
          ],
        ),
      ),);
  }
  Widget buildAddButton() => Container(
    padding: EdgeInsets.all(10) ,
    child: GestureDetector(
      child: Icon(Icons.add,size: 80),
      onTap: () async {
        final file = await pickVideoFile();
        if (file == null) return;

        controller = VideoPlayerController.file(file)
          ..addListener(() => setState(() {}))
          ..setLooping(true)
          ..initialize().then((_) {
            controller.play();
            setState(() {});
          });
      },
    ),
  );
  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles();//type: FileType.video
    if (result == null) return null;
    return File(result.files.single.path);
  }
}
