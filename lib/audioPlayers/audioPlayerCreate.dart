import 'dart:io';
import 'dart:ui';
import 'package:SyncPlayer/Utils/RadiantGradientIcon.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../BottomNav.dart';
import '../Utils/MarqueeText.dart';
import '../Utils/SliderInnerWidget.dart';
import 'package:http/http.dart' as http;

class audioPlayerCreate extends StatefulWidget {
  audioPlayerCreate({Key key, @required this.RoomId}) : super(key: key);
  int RoomId;

  @override
  _audioPlayerCreateState createState() => _audioPlayerCreateState();
}

// ignore: camel_case_types
class _audioPlayerCreateState extends State<audioPlayerCreate> {
  String mp3Uri = '',
      song = ' null';
  int current = 0;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final assetsAudioPlayer = AssetsAudioPlayer();
  IconData pIcon;
  double seekerCurrent = 0;
  int current_divider = -1;
  int i = 0,
      j = 0;
  ValueNotifier<double> valueNotifier = ValueNotifier<double>(0);
  final audios = <Audio>[];
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

//Listen to the current playing song
  Duration _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    Duration d = new Duration(
        hours: int.parse(twoDigits(duration.inHours)),
        minutes: int.parse(twoDigitMinutes),
        seconds: int.parse(twoDigitSeconds));
    return d;
  }

  String _printDurationAsString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (twoDigits(duration.inHours) == "00")
      return "$twoDigitMinutes:$twoDigitSeconds";
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String getSong() {
    final Playing playing = assetsAudioPlayer.current.value;
    if (playing == null)
      return "music";
    else {
      int x = playing.audio.assetAudioPath.lastIndexOf('/');
      return playing.audio.assetAudioPath.substring(x + 1);
    }
  }

  void updateCurrentSec(int sec) {
    // print("updating sec and room:" +
    //     widget.RoomId.toString() +
    //     "," +
    //     sec.toString());
    Future<http.Response> response = http.get(
        'http://harmonpreet012.centralindia.cloudapp.azure.com:8000/seekTo/' +
            widget.RoomId.toString() +
            '/' +
            sec.toString());
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    Audio find(List<Audio> source, String fromPath) {
      return source.firstWhere((element) => element.path == fromPath);
    }

    List<Widget> getAudio() {
      if (audios.isEmpty) return [];
      List<Widget> l = [];
      for (int x = 0; x <= current_divider; x++)
        l.add(ListTile(
          key: ValueKey(x),
          title: Text(
            audios[x].path.substring(audios[x].path.lastIndexOf('/') + 1),
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {},
        ));
      return l;
    }

    List<Widget> getPendingAudio() {
      if (audios.isEmpty) return [];
      List<Widget> l = [];
      for (int x = 1; x < audios.length; x++)
        l.add(ListTile(
          key: ValueKey(x),
          title: Text(
              audios[x].path.substring(audios[x].path.lastIndexOf('/') + 1)),
          onTap: () {},
        ));
      return l;
    }

    assetsAudioPlayer.playlistAudioFinished.listen((Playing playing) {
      print('deleting at ' + 0.toString());
      audios.removeAt(0);
      print(audios.toString());
      setState(() {
      });
    });
    String current;
    if (audios.isNotEmpty) {
      current = audios[0]
          .path
          .substring(audios[0].path.lastIndexOf('/') + 1);
      // audios.removeAt(0);
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _drawerKey,
        backgroundColor: Colors.black,
        // backgroundColor: Color(0xff14174E),
        endDrawerEnableOpenDragGesture: false,
        drawer: SafeArea(
          child: Drawer(
            child: Container(
              child: ReorderableListView(
                header: Column(
                  children: [
                    Text(
                      'Playlist',
                      style: GoogleFonts.merriweather(
                          color: Colors.black, fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    if (audios.isNotEmpty)
                      Container(
                        child: ListTile(
                          title: Text(
                            current,
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {},
                        ),
                      ),
                  ],
                ),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    print("old:" + oldIndex.toString() + " new:" +
                        newIndex.toString());
                    dynamic temp = audios[oldIndex+1];
                    audios.removeAt(oldIndex+1);
                    if (oldIndex > newIndex)
                      audios.insert(newIndex+1, temp);
                    else
                      audios.insert(newIndex, temp);
                    // if (oldIndex > newIndex) {
                    //   audios[oldIndex + 1 + current_divider] = audios[newIndex+current_divider];
                    //   audios[newIndex+current_divider] = temp;
                    // }
                    // else{
                    //   audios[oldIndex + 1 + current_divider] = audios[newIndex-1+current_divider];
                    //   audios[newIndex-1+current_divider] = temp;
                    // }
                    }
                    );
                },
                padding: EdgeInsets.zero,
                children: getPendingAudio(),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.playlist_play_outlined,
                        size: 50,
                      ),
                      onTap: () {
                        _drawerKey.currentState.openDrawer();
                      },
                    ),
                    Text(
                      'Music',
                      style: GoogleFonts.poiretOne(
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.add,
                        size: 50,
                      ),
                      onTap: () {
                        setState(() {
                          open();
                        });
                      },
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: assetsAudioPlayer.currentPosition,
                builder: (context, asyncSnapshot) {
                  SleekCircularSlider s;
                  String time = "00:00";
                  final Duration position = asyncSnapshot.data;
                  if (assetsAudioPlayer.currentPosition.value == null ||
                      assetsAudioPlayer.current.value == null) {
                    s = SleekCircularSlider(
                      min: 0,
                      max: 1,
                      initialValue: 0,
                      appearance: CircularSliderAppearance(
                        angleRange: 360,
                        animationEnabled: false,
                        size: MediaQuery
                            .maybeOf(context)
                            .size
                            .width * 0.60,
                        startAngle: 270,
                        animDurationMultiplier: 300,
                        customWidths: CustomSliderWidths(
                            trackWidth: 2, progressBarWidth: 3, handlerSize: 4),
                        customColors: CustomSliderColors(progressBarColors: [
                          Color(0xffF9657F),
                          Color(0xffF61976)
                        ], trackColors: [
                          Color(0x66F9657F),
                          Color(0x66F61976)
                        ]),
                        //#F9657F->#F61976
                      ),
                      innerWidget: (double value) {
                        return SliderInnerWidget();
                      },
                    );
                  } else {
                    // if (assetsAudioPlayer.isPlaying.value == false)
                    //   updateCurrentSec(-1);
                    // else
                    if (assetsAudioPlayer.isPlaying.value == true)
                      updateCurrentSec(
                          assetsAudioPlayer.currentPosition.value.inSeconds);
                    // print("check2:" +
                    //     assetsAudioPlayer.currentPosition.value.inSeconds
                    //         .toString());

                    time = _printDurationAsString(
                        new Duration(seconds: position.inSeconds.toInt()));
                    s = SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        angleRange: 360,
                        size: MediaQuery
                            .maybeOf(context)
                            .size
                            .width * 0.65,
                        startAngle: 270,
                        animDurationMultiplier: 300,
                        customWidths: CustomSliderWidths(
                            trackWidth: 2, progressBarWidth: 4, handlerSize: 4),
                        customColors: CustomSliderColors(progressBarColors: [
                          Color(0xffF9657F),
                          Color(0xffF61976)
                        ], trackColors: [
                          Color(0x66F9657F),
                          Color(0x66F61976)
                        ]),
                        //#F9657F->#F61976
                      ),
                      min: 0,
                      max: assetsAudioPlayer
                          .current.value.audio.duration.inSeconds
                          .toDouble(),
                      initialValue: assetsAudioPlayer
                          .currentPosition.value.inSeconds
                          .toDouble() >
                          assetsAudioPlayer
                              .current.value.audio.duration.inSeconds
                              .toDouble()
                          ? 0
                          : assetsAudioPlayer.currentPosition.value.inSeconds
                          .toDouble(),
                      onChange: (double value) {
                        setState(
                              () {
                            Duration d = new Duration(seconds: value.toInt());
                            d = _printDuration(d);
                            seekTo(d);
                          },
                        );
                      },
                      onChangeEnd: (double value) {
                        setState(
                              () {
                            Duration d = new Duration(seconds: value.toInt());
                            d = _printDuration(d);
                            seekTo(d);
                          },
                        );
                      },
                      onChangeStart: (double value) {},
                      innerWidget: (double value) {
                        return SliderInnerWidget();
                      },
                    );
                  }
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(time),
                      ),
                      s,
                    ],
                  );
                },
              ),
              StreamBuilder(
                stream: assetsAudioPlayer.current,
                builder: (context, asyncSnapshot) {
                  String text = "Music";
                  if (assetsAudioPlayer.current.value != null) {
                    text = getSong();
                    return Container(
                      height: 46,
                      width: MediaQuery
                          .maybeOf(context)
                          .size
                          .width * 0.8,
                      child: MarqueeText(
                        text: text,
                        textStyle: GoogleFonts.poiretOne(
                          fontWeight: FontWeight.w900,
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    return Text(
                      "Nothing to Play?",
                      style: GoogleFonts.poiretOne(fontSize: 30),
                    );
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              prev();
                            });
                          },
                          child: Icon(
                            Icons.skip_previous,
                            size: 40,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              skipprev();
                            });
                          },
                          child: Icon(
                            CupertinoIcons.backward_fill,
                            size: 30,
                          ),
                        ),
                        StreamBuilder(
                            stream: assetsAudioPlayer.isPlaying,
                            builder: (context, asyncSnapshot) {
                              final bool isPlaying = asyncSnapshot.data;
                              if (assetsAudioPlayer.isPlaying.value == false) {
                                pIcon = Icons.play_circle_fill;
                                updateCurrentSec(-1);
                              } else {
                                // print("good current");
                                // updateCurrentSec(
                                //     assetsAudioPlayer.currentPosition.value.inSeconds);
                                pIcon = Icons.pause_circle_filled;
                              }
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    playOrpause();
                                  });
                                },
                                child: RadiantGradientMask(
                                  child: Icon(
                                    pIcon,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                  c2: Color(0xffff0000),
                                  c1: Color(0xAAd70000),
                                ),
                              );
                            }),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              skipnext();
                            });
                          },
                          child: Icon(
                            CupertinoIcons.forward_fill,
                            size: 30,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              next();
                            });
                          },
                          child: Icon(
                            Icons.skip_next,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                shuffle();
                              });
                            },
                            child: Icon(
                              Icons.shuffle,
                              size: 30,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                loop();
                              });
                            },
                            child: Icon(
                              Icons.loop_outlined,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void playOrpause() {
    assetsAudioPlayer.playOrPause();
  }

  void shuffle() {
    assetsAudioPlayer.toggleShuffle();
  }

  void open() {
    song = "entering";
    Future<FilePickerResult> result = FilePicker.platform
        .pickFiles(withReadStream: true, allowMultiple: true);
    result.then((value) {
      if (value != null) {
        // List<File> files = value.paths.map((path) => File(path)).toList();
        // for (File file in files) {
        //   audios.add(Audio.file(file.path));
        //   song=file.path;
        // }
        List<File> files = value.paths.map((path) => File(path)).toList();
        for (int i = 0; i < files.length; i++) {
          audios.add(Audio.file(files[i].path));
        }
        // song = "result received";
        // file = File(value.files.single.path);
        // audios.add(Audio.file(file.path));
        setState(() {
          current_divider = 0;
          assetsAudioPlayer.open(Playlist(audios: audios),
              autoStart: false, loopMode: LoopMode.playlist);
        });

        // song = "result done";
      } else {
        song = "failed";
        // User canceled the picker
      }
    });
    // FilePickerResult result =
    //     await FilePicker.platform.pickFiles();
    // song="stuck";
    // flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
    // if (result != null) {
    //   song="getting";
    //   List<File> files = result.paths.map((path) => File(path)).toList();
    //   song="here";
    //   for (File file in files) {
    //     audios.add(Audio.file(file.path));
    //     song=file.path;
    //   }
    //   song="open";
    //   assetsAudioPlayer.open(
    //     Playlist(audios: audios),
    //     autoStart: false,
    //   );
    //   song="start";
    // } else {
    //   song="failed";
    //   // User canceled the picker
    // }
  }

  void next() {
    assetsAudioPlayer.next();
  }

  void prev() {
    assetsAudioPlayer.previous();
  }

  void seekTo(Duration duration) async {
    await assetsAudioPlayer.seek(duration);
  }

  void loop() async {
    // print("start:" + assetsAudioPlayer.currentLoopMode.toString());
    assetsAudioPlayer.toggleLoop();
    // print("done:" + assetsAudioPlayer.currentLoopMode.toString());
  }

  void skipnext() async {
    assetsAudioPlayer.seekBy(new Duration(seconds: 10));
  }

  void skipprev() async {
    assetsAudioPlayer.seekBy(new Duration(seconds: -10));
  }

  @override
  void deactivate() {
    _clearCachedFiles();
    assetsAudioPlayer.stop();
    super.deactivate();
  }
}
