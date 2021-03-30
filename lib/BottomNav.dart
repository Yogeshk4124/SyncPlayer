import 'package:SyncPlayer/VideoPlayers/addVideo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'Configuration.dart';
import 'audioPlayers/audioCreate.dart';
import 'audioPlayers/audioJoin.dart';
import 'audioPlayers/audioPlayer.dart';

Future<Map<String, String>> getData() async {
  return Future.delayed(
      Duration(seconds: 0), () => {'Create': '-1', 'Join': '-1'});
}

class Home4 extends StatefulWidget {
  @override
  _Home4State createState() => _Home4State();
}

class _Home4State extends State<Home4> {
  Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = {'Create': '-1', 'Join': '-1'};
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        if (data['Join'] == '-1' && data['Create'] == '-1') {
          return new audioPlayer();
        } else if (data['Join'] != '-1')
          return audioJoin(
            RoomId: int.parse(data['Join']),
          );
        else
          return new audioCreate(RoomId: int.parse(data['Create']));
        break;
      case 1:
        return new Home2(
          data: data,
        );
        break;
      case 2:
        int id, type;
        if (data['Join'] == '-1' && data['Create'] == '-1') {
          {
            id = -1;
            type = 1;
          }
        } else if (data['Join'] != '-1') {
          id = int.parse(data['Join']);
          type = 2;
        } else {
          type = 3;
          id = int.parse(data['Create']);
        }
        return new addVideo(Roomid: id, type: type);
        break;
      default:
        return new Home2(
          data: data,
        );
        break;
    }
  }

  int _currentIndex = 1;
  final SnakeShape snakeShape = SnakeShape.circle;
  final Color selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: getPage(_currentIndex),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.pinned,
        snakeShape: snakeShape,
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        snakeViewColor: Colors.black,
        selectedItemColor: snakeShape == SnakeShape.indicator
            ? Color(0xffFF2929)
            : Color(0xffFF2929),
        unselectedItemColor: Color(0xff606060),
        showSelectedLabels: false,
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.music_note_2), label: 'tickets'),
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.settings_solid,
                size: 40,
              ),
              label: 'tickets'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.video_camera_solid), label: 'tickets'),
        ],
      ),
    );
  }
}
