import 'package:SyncPlayer/audioPlayer.dart';
import 'package:SyncPlayer/videoPlayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'Home2.dart';

Future<Map<String, dynamic>> getData() async {
  return Future.delayed(Duration(seconds: 0), () => {'Create':'-1','Join':'-1'});
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
    getData().then((values) {
      setState(() {
        data = values;
      });
    });
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return audioPlayer(RoomId: int.parse(data['Create']));
        break;
      case 1:
        return Home2(data: data,);
        break;
      case 2:
        return videoPlayer();
        break;
      default:
        return Home2(data: data,);
        break;
    }
  }

  int _currentIndex = 1;

  final SnakeShape snakeShape = SnakeShape.rectangle;
  final Color selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: getPage(_currentIndex),
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.pinned,
        snakeShape: snakeShape,
        padding: EdgeInsets.zero,
        shape: BeveledRectangleBorder(
            borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        )),

        ///configuration for SnakeNavigationBar.color
        snakeViewColor: Colors.black,

        selectedItemColor:
            snakeShape == SnakeShape.indicator ? Colors.pink : Colors.pink,
        unselectedItemColor: Colors.black,

        ///configuration for SnakeNavigationBar.gradient
        //snakeViewGradient: selectedGradient,
        //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
        //unselectedItemGradient: unselectedGradient,

        // showUnselectedLabels: showUnselectedLabels,
        showSelectedLabels: false,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.music_note_2), label: 'tickets'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings_solid,size: 40,), label: 'tickets'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.video_camera_solid), label: 'tickets'),
        ],
      ),
    );
  }
}