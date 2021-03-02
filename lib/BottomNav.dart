import 'package:SyncPlayer/audioPlayers/audioPlayerCreate.dart';
import 'package:SyncPlayer/audioPlayers/audioPlayerJoin.dart';
import 'package:SyncPlayer/videoPlayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'Configuration.dart';
import 'VideoPlayers/VideoCreate.dart';
import 'VideoPlayers/VideoJoin.dart';
import 'audioPlayers/audioPlayer.dart';

Future<Map<String, dynamic>> getData() async {
  return Future.delayed(
      Duration(seconds: 0), () => {'Create': '-1', 'Join': '-1'});
  // return Future.value({'Create':'-1','Join':'-1'});
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
    // getData().then((values) {
    //   setState(() {
    //     data = values;
    //   });
    // });
    data = {'Create': '-1', 'Join': '-1'};
  }

  Widget getPage(int index) {
    print(data.toString());
    switch (index) {
      case 0:
        if (data['Join'] == '-1' && data['Create'] == '-1') {
          print('C1');
          return audioPlayer();
        }
        else if (data['Join'] != '-1')
          return audioPlayerJoin(
            RoomId: int.parse(data['Join']),
          );
        else
          return audioPlayerCreate(RoomId: int.parse(data['Create']));
        break;
      case 1:
        return Home2(
          data: data,
        );
        break;
      case 2:
      // return videoPlayer(RoomId: int.parse(data['Create'])>int.parse(data['Join'])?int.parse(data['Create']):int.parse(data['Join']),);
        if (data['Join'] != '-1')
          return VideoJoin(
            Roomid: int.parse(data['Join']),
          );
        return VideoCreate(Roomid: int.parse(data['Create']));
        break;
      default:
        return Home2(
          data: data,
        );
        break;
    }
  }

  int _currentIndex = 1;

  // final SnakeShape snakeShape = SnakeShape.rectangle;
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

        //   BeveledRectangleBorder(
        //     borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(25),
        //   topRight: Radius.circular(25),
        // )),

        ///configuration for SnakeNavigationBar.color
        snakeViewColor: Colors.black,

        selectedItemColor:
        snakeShape == SnakeShape.indicator ? Color(0xffFF2929) : Color(
            0xffFF2929),
        unselectedItemColor: Color(0xff606060),

        ///configuration for SnakeNavigationBar.gradient
        //snakeViewGradient: selectedGradient,
        //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
        //unselectedItemGradient: unselectedGradient,

        // showUnselectedLabels: showUnselectedLabels,
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
