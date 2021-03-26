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

class audioCreate extends StatefulWidget {
  audioCreate({Key key, @required this.RoomId}) : super(key: key);
  int RoomId;

  @override
  _audioCreateState createState() => _audioCreateState();
}

// ignore: camel_case_types
class _audioCreateState extends State<audioCreate> {
  String mp3Uri = '', song = ' null';
  int current = 0;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final assetsAudioPlayer = AssetsAudioPlayer();
  IconData pIcon;
  int i = 0, j = 0;
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
    Audio find(List<Audio> source, String fromPath) {
      return source.firstWhere((element) => element.path == fromPath);
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _drawerKey,
        backgroundColor: Colors.black,
        // backgroundColor: Color(0xff14174E),
        endDrawerEnableOpenDragGesture: false,
        body: SafeArea(
          child: Column(
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
              assetsAudioPlayer.builderRealtimePlayingInfos(
                  builder: (context, RealtimePlayingInfos infos) {
                if (infos == null) {
                  return SleekCircularSlider(
                    min: 0,
                    max: 1,
                    initialValue: 0,
                    appearance: CircularSliderAppearance(
                      angleRange: 360,
                      animationEnabled: false,
                      size: MediaQuery.maybeOf(context).size.width * 0.60,
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
                }
                print('infos: $infos');
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        angleRange: 360,
                        size: MediaQuery.maybeOf(context).size.width * 0.65,
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
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          assetsAudioPlayer.current.value != null
                              ? Container(
                                  height: 46,
                                  width:
                                      MediaQuery.maybeOf(context).size.width *
                                          0.8,
                                  child: MarqueeText(
                                    text: getSong(),
                                    textStyle: GoogleFonts.poiretOne(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Nothing to Play?",
                                  style: GoogleFonts.poiretOne(fontSize: 30),
                                ),
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
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    playOrpause();
                                  });
                                },
                                child: RadiantGradientMask(
                                  child: Icon(
                                    (!assetsAudioPlayer.isPlaying.value)
                                        ? Icons.play_circle_fill
                                        : Icons.pause_circle_filled,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                  c2: Color(0xffff0000),
                                  c1: Color(0xAAd70000),
                                ),
                              ),
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
                );
              }),
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
