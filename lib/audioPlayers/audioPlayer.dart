import 'dart:io';
import 'dart:ui';
import 'package:SyncPlayer/Utils/RadiantGradientIcon.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/MarqueeText.dart';
import '../Utils/SliderInnerWidget.dart';
import 'package:http/http.dart' as http;

class audioPlayer extends StatefulWidget {
  @override
  _audioPlayerState createState() => _audioPlayerState();
}

// ignore: camel_case_types
class _audioPlayerState extends State<audioPlayer> {
  String mp3Uri = '', song = ' null';
  int current = 0;
  final assetsAudioPlayer = AssetsAudioPlayer();
  IconData pIcon;
  double seekerCurrent = 0;
  int i = 0, j = 0;
  ValueNotifier<double> valueNotifier = ValueNotifier<double>(0);
  final audios = <Audio>[];

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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top:true,
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
                      setState(() {});
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
                      size: MediaQuery.of(context).size.width * 0.60,
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
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width * 0.52,
                            width: MediaQuery.of(context).size.width * 0.52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // borderRadius: BorderRadius.all(Radius.circular(20)),
                              gradient: new LinearGradient(
                                colors: [
                                  Color(0xffF61976),
                                  Color(0xffF9657F),
                                ],
                              ),

                              // color: Colors.white,
                            ),
                            child: Center(
                              child: Container(
                                height:
                                MediaQuery.of(context).size.width * 0.46,
                                width: MediaQuery.of(context).size.width * 0.46,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: new LinearGradient(
                                    colors: [
                                      Color(0xffF9657F),
                                      Color(0xffF61976)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    // color: Colors.pink,
                                  ),
                                ),
                                child: Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Icon(
                                        CupertinoIcons.double_music_note,
                                        size:
                                        MediaQuery.of(context).size.width *
                                            0.30)),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // if (assetsAudioPlayer.isPlaying.value == false)
                  //   updateCurrentSec(-1);
                  // else

                  time = _printDurationAsString(
                      new Duration(seconds: position.inSeconds.toInt()));
                  s = SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      angleRange: 360,
                      size: MediaQuery.of(context).size.width * 0.65,
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
                    width: MediaQuery.of(context).size.width * 0.8,
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
                            } else {
                              print("good current");
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
                                  c1: Color(0xffF9657F),
                                  c2: Color(0xffF61976)),
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
    Future<FilePickerResult> result = FilePicker.platform.pickFiles();
    File file;
    // flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
    result.then((value) {
      if (value != null) {
        // List<File> files = value.paths.map((path) => File(path)).toList();
        // for (File file in files) {
        //   audios.add(Audio.file(file.path));
        //   song=file.path;
        // }
        song = "result received";
        file = File(value.files.single.path);
        audios.add(Audio.file(file.path));
        assetsAudioPlayer.open(
          Playlist(audios: audios),
          autoStart: false,
        );
        song = "result done";
      } else {
        song = "failed";
        // User canceled the picker
      }
    });

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
    print("start:" + assetsAudioPlayer.currentLoopMode.toString());
    assetsAudioPlayer.toggleLoop();
    print("done:" + assetsAudioPlayer.currentLoopMode.toString());
  }

  void skipnext() async {
    assetsAudioPlayer.seekBy(new Duration(seconds: 10));
  }

  void skipprev() async {
    assetsAudioPlayer.seekBy(new Duration(seconds: -10));
  }
  @override
  deactivate() {
    assetsAudioPlayer.stop();
  }
}
