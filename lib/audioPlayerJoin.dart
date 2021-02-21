import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:SyncPlayer/Utils/RadiantGradientIcon.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Utils/MarqueeText.dart';
import 'package:http/http.dart' as http;
import 'Utils/SliderInnerWidget.dart';

class audioPlayerJoin extends StatefulWidget {
  audioPlayerJoin({Key key, @required this.RoomId}) : super(key: key);
  final int RoomId;

  @override
  _audioPlayerJoinState createState() => _audioPlayerJoinState();
}

// ignore: camel_case_types
class _audioPlayerJoinState extends State<audioPlayerJoin> {
  String mp3Uri = '';
  int current = 0;
  int ct = -1;
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

  Future getSec() async {
    http.Response response = await http.get(
        'http://20.197.61.11:8000/getCurrentSecond/' +
            widget.RoomId.toString());
    var decodedData = jsonDecode(response.body);
    return decodedData['second'];
  }

  @override
  Widget build(BuildContext context) {
    Audio find(List<Audio> source, String fromPath) {
      return source.firstWhere((element) => element.path == fromPath);
    }

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      Future x = getSec();
      x.then((value) {
        int temp = int.parse(value.toString());
        if (ct != -2 && (temp - ct).abs() > 5) {
          ct = temp;
          seekTo(Duration(seconds: temp));
        }
        if (ct == -1)
          assetsAudioPlayer.pause();
        else if (assetsAudioPlayer.current.value != null)
          assetsAudioPlayer.play();
      });
    });
    return Scaffold(
      backgroundColor: Color(0xff14174E),
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
                      setState(() {});
                    },
                  ),
                  Text(
                    "Music",
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
            // min: 0,
            // max: assetsAudioPlayer.current.value == null
            //     ? 1
            //     : assetsAudioPlayer.current.value.audio.duration.inSeconds
            //     .toDouble(),
            // initialValue: assetsAudioPlayer.current.value == null
            //     ? 0
            //     : (ct == -1 ? 0 : ct.toDouble()),

            StreamBuilder(
                stream: assetsAudioPlayer.currentPosition,
                builder: (context, asyncSnapshot) {
                  if (assetsAudioPlayer.current != null)
                    return Column(
                      children: [
                        Text(_printDurationAsString(Duration(seconds: assetsAudioPlayer.currentPosition.value.inSeconds))),
                        SleekCircularSlider(
                          min: 0,
                          max: assetsAudioPlayer.current.value==null?1:assetsAudioPlayer.current.value.audio.duration.inSeconds.toDouble(),
                          initialValue: assetsAudioPlayer.currentPosition.value.inSeconds.toDouble(),
                          appearance: CircularSliderAppearance(
                            angleRange: 360,
                            animationEnabled: false,
                            size: MediaQuery.of(context).size.width * 0.65,
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
                        ),
                      ],
                    );
                  else
                    return Column(
                      children: [
                        Text("00:00"),
                        SleekCircularSlider(
                          min: 0,
                          max: 1,
                          initialValue: 0,
                          appearance: CircularSliderAppearance(
                            angleRange: 360,
                            animationEnabled: false,
                            size: MediaQuery.of(context).size.width * 0.65,
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
                        ),
                      ],
                    );
                }),
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
                            // prev();
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
                            // skipprev();
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
                            } else
                              pIcon = Icons.pause_circle_filled;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  // playOrpause();
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
                            // skipnext();
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

  void open() async {
    // FilePickerResult result =
    // await FilePicker.platform.pickFiles(allowMultiple: true);
    // if (result != null) {
    //   List<File> files = result.paths.map((path) => File(path)).toList();
    //   for (File file in files) {
    //     audios.add(Audio.file(file.path));
    //   }
    //   assetsAudioPlayer.open(
    //     Playlist(audios: audios),
    //     autoStart: false,
    //   );
    // } else {
    //   // User canceled the picker
    // }
    Future<FilePickerResult> result = FilePicker.platform.pickFiles();
    File file;
    // flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
    result.then((value) {
      if (value != null) {
        file = File(value.files.single.path);
        audios.add(Audio.file(file.path));
        assetsAudioPlayer.open(
          Playlist(audios: audios),
          autoStart: false,
        );
      } else {
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
  // ignore: must_call_super
  void deactivate() {
    assetsAudioPlayer.stop();
  }

  @override
  // ignore: must_call_super
  void dispose() {
    assetsAudioPlayer.stop();
  }
}
