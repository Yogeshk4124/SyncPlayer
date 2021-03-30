import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:SyncPlayer/ModalTrigger.dart';
import 'package:SyncPlayer/Utils/RadiantGradientIcon.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../BottomNav.dart';
import '../Utils/MarqueeText.dart';
import '../Utils/SliderInnerWidget.dart';

class audioPlayer extends StatefulWidget {
  audioPlayer({Key key}) : super(key: key);

  @override
  _audioPlayerState createState() => _audioPlayerState();
}

// ignore: camel_case_types
class _audioPlayerState extends State<audioPlayer> {
  String mp3Uri = '', song = ' null';
  int current = 0;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final assetsAudioPlayer = AssetsAudioPlayer();
  IconData pIcon;
  int i = 0, j = 0;
  ValueNotifier<double> valueNotifier = ValueNotifier<double>(0);
  final audios = <Audio>[];

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles();
  }

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
                  Navigator.pop(context);
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
  void dispose() {
    super.dispose();
    assetsAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _drawerKey,
        backgroundColor: Colors.black,
        endDrawerEnableOpenDragGesture: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: 50,
                        child: Icon(
                          Icons.arrow_back_outlined,
                          size: 35,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Home4()),
                          (route) => false,
                        );
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
              SliderInnerWidget(),
              assetsAudioPlayer.builderRealtimePlayingInfos(
                  builder: (context, RealtimePlayingInfos infos) {
                if (infos == null || assetsAudioPlayer.current.value == null) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        assetsAudioPlayer.current.value != null
                            ? Container(
                                height: 46,
                                width: MediaQuery.maybeOf(context).size.width *
                                    0.8,
                                child: MarqueeText(
                                  text: getSong(),
                                  textStyle: GoogleFonts.poiretOne(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Container(
                                height: 46,
                                child: Text(
                                  "Nothing to Play?",
                                  style: GoogleFonts.poiretOne(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 30),
                                ),
                              ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(_printDurationAsString(Duration(seconds: 0))),
                            Expanded(
                              child: Slider(
                                min: 0,
                                max: 1,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      Duration d =
                                          new Duration(seconds: value.toInt());
                                      d = _printDuration(d);
                                      seekTo(d);
                                    },
                                  );
                                },
                                value: 0,
                                activeColor: Color(0xffff0000),
                                inactiveColor: Colors.red.withOpacity(0.3),
                              ),
                            ),
                            Text(_printDurationAsString(Duration(seconds: 0))),
                          ],
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
                                    if (assetsAudioPlayer.volume.value
                                            .toInt() ==
                                        0)
                                      assetsAudioPlayer.setVolume(1);
                                    else
                                      assetsAudioPlayer.setVolume(0);
                                  });
                                },
                                child: getVolume(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    loop();
                                  });
                                },
                                child: Icon(
                                  CupertinoIcons.repeat,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      assetsAudioPlayer.current.value != null
                          ? Container(
                              height: 46,
                              width:
                                  MediaQuery.maybeOf(context).size.width * 0.8,
                              child: MarqueeText(
                                text: getSong(),
                                textStyle: GoogleFonts.poiretOne(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(
                              height: 46,
                              child: Text(
                                "Nothing to Play?",
                                style: GoogleFonts.poiretOne(
                                    fontWeight: FontWeight.w900, fontSize: 30),
                              ),
                            ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(_printDurationAsString(Duration(
                              seconds: assetsAudioPlayer
                                  .currentPosition.value.inSeconds))),
                          Expanded(
                            child: Slider(
                              min: 0,
                              max: assetsAudioPlayer
                                  .current.value.audio.duration.inSeconds
                                  .toDouble(),
                              onChanged: (value) {
                                setState(
                                  () {
                                    Duration d =
                                        new Duration(seconds: value.toInt());
                                    d = _printDuration(d);
                                    seekTo(d);
                                  },
                                );
                              },
                              value: assetsAudioPlayer
                                  .currentPosition.value.inSeconds
                                  .toDouble(),
                              activeColor: Color(0xffff0000),
                              inactiveColor: Colors.red.withOpacity(0.3),
                              label:
                                  "${assetsAudioPlayer.currentPosition.value.inMinutes}",
                            ),
                          ),
                          Text(_printDurationAsString(Duration(
                              seconds: assetsAudioPlayer
                                  .current.value.audio.duration.inSeconds))),
                        ],
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
                                  if (assetsAudioPlayer.volume.value.toInt() ==
                                      0)
                                    assetsAudioPlayer.setVolume(1);
                                  else
                                    assetsAudioPlayer.setVolume(0);
                                });
                              },
                              child: getVolume(),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  loop();
                                });
                              },
                              child: getLoopIcon(),
                              // Icons.loop_outlined,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              ModalTrigger(
                audios: audios,
                ap: assetsAudioPlayer,
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

  getVolume() {
    if (assetsAudioPlayer.volume.value == 0)
      return Icon(
        CupertinoIcons.volume_off,
      );
    else
      return Icon(CupertinoIcons.volume_up);
  }

  Widget getLoopIcon() {
    if (assetsAudioPlayer.currentLoopMode == LoopMode.single)
      return Icon(
        CupertinoIcons.repeat_1,
        color: Colors.red,
      );
    else if (assetsAudioPlayer.currentLoopMode == LoopMode.none)
      return Icon(
        CupertinoIcons.repeat,
        color: Colors.white,
      );
    else
      return Icon(
        CupertinoIcons.repeat,
        color: Colors.red,
      );
  }

  void open() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(withReadStream: true, allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      for (int i = 0; i < files.length; i++) {
        audios.add(Audio.file(files[i].path));
      }
      await assetsAudioPlayer.open(Playlist(audios: audios),
          autoStart: false, loopMode: LoopMode.playlist);

      setState(() {});
    }
  }

  void next() async {
    await assetsAudioPlayer.next();

    setState(() {});
  }

  void prev() async {
    await assetsAudioPlayer.previous();
    setState(() {});
  }

  void seekTo(Duration duration) async {
    await assetsAudioPlayer.seek(duration);
  }

  void loop() async {
    assetsAudioPlayer.toggleLoop();
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
