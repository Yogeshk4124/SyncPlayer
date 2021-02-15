import 'dart:io';
import 'dart:ui';

import 'package:SyncPlayer/RadiantGradientIcon.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'MarqueeText.dart';

class audioPlayer extends StatefulWidget {
  audioPlayer({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _audioPlayerState createState() => _audioPlayerState();
}

// ignore: camel_case_types
class _audioPlayerState extends State<audioPlayer> {
  String mp3Uri = '';
  int current = 0;
  final assetsAudioPlayer = AssetsAudioPlayer();
  IconData pIcon;
  double seekerCurrent = 0;
  bool _add = false;
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
    Audio find(List<Audio> source, String fromPath) {
      return source.firstWhere((element) => element.path == fromPath);
    }

    return Scaffold(
      backgroundColor: Color(0xff14174E),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // StreamBuilder(
            //     stream: assetsAudioPlayer.current,
            //     builder: (context, asyncSnapshot) {
            //       Column returnval;
            //       if (asyncSnapshot.hasData)
            //         returnval = Column(
            //           children: <Widget>[
            //             Text(
            //               getSong(),
            //             ),
            //             StreamBuilder(
            //               stream: assetsAudioPlayer.currentPosition,
            //               builder: (context, asyncSnapshot) {
            //                 SleekCircularSlider s;
            //                 String time = "00:00";
            //                 final Duration position = asyncSnapshot.data;
            //                 time = _printDurationAsString(new Duration(
            //                     seconds: position.inSeconds.toInt()));
            //                 s = SleekCircularSlider(
            //                   appearance: CircularSliderAppearance(
            //                     angleRange: 360,
            //                     size: MediaQuery.of(context).size.width * 0.65,
            //                     startAngle: 270,
            //                     customWidths: CustomSliderWidths(
            //                         trackWidth: 1, progressBarWidth: 1),
            //                     customColors: CustomSliderColors(
            //                         progressBarColors: [
            //                           Color(0xffF9657F),
            //                           Color(0xffF61976)
            //                         ]),
            //                     animationEnabled: false, //#F9657F->#F61976
            //                   ),
            //                   min: 0,
            //                   max: assetsAudioPlayer.current.value == null
            //                       ? 1
            //                       : assetsAudioPlayer
            //                           .current.value.audio.duration.inSeconds
            //                           .toDouble(),
            //                   initialValue: position.inSeconds.toDouble(),
            //                   onChange: (double value) {
            //                     // callback providing a value while its being changed (with a pan gesture)
            //                     setState(
            //                       () {
            //                         Duration d =
            //                             new Duration(seconds: value.toInt());
            //                         d = _printDuration(d);
            //                         seekTo(d);
            //                       },
            //                     );
            //                   },
            //                   onChangeEnd: (double value) {
            //                     setState(
            //                       () {
            //                         Duration d =
            //                             new Duration(seconds: value.toInt());
            //                         d = _printDuration(d);
            //                         seekTo(d);
            //                       },
            //                     );
            //                   },
            //                   onChangeStart: (double value) {
            //                     // callback providing a value while its being changed (with a pan gesture)
            //                   },
            //                   innerWidget: (double value) {
            //                     return Icon(Icons.music_video_outlined);
            //                   },
            //                 );
            //                 return Column(
            //                   children: <Widget>[
            //                     Text(time),
            //                     s,
            //                   ],
            //                 );
            //               },
            //             ),
            //           ],
            //         );
            //       else {
            //         returnval = Column(
            //           children: [
            //             Text("Music"),
            //             SleekCircularSlider(
            //               min: 0,
            //               max: 1,
            //               initialValue: 0,
            //               appearance: CircularSliderAppearance(
            //                   angleRange: 360,
            //                   size: MediaQuery.of(context).size.width * 0.65,
            //                   startAngle: 270,
            //                   customWidths: CustomSliderWidths(
            //                       trackWidth: 1, progressBarWidth: 1),
            //                   customColors: CustomSliderColors(
            //                       progressBarColors: [
            //                         Color(0xffF9657F),
            //                         Color(0xffF61976)
            //                       ]),
            //                   animationEnabled: false
            //                   //#F9657F->#F61976
            //                   ),
            //               innerWidget: (double value) {
            //                 return Icon(Icons.music_video_outlined);
            //               },
            //             )
            //           ],
            //         );
            //       }
            //       return returnval;
            //     }),
            //this is real stream Builder

            StreamBuilder(
              stream: assetsAudioPlayer.current,
              builder: (context, asyncSnapshot) {
                String text = "Music";
                if (assetsAudioPlayer.current.value != null) {
                  text = getSong();
                }
                return Padding(
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
                      if (text == "Music")
                        Text(
                          text,
                          style: GoogleFonts.poiretOne(
                            fontWeight: FontWeight.w900,
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        )
                      else
                        Container(
                          height: 46,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: MarqueeText(
                            text: text,
                            textStyle: GoogleFonts.poiretOne(
                              fontWeight: FontWeight.w900,
                              fontSize: 40,
                              color: Colors.white,
                            ),
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
                );
              },
            ),
            StreamBuilder(
              stream: assetsAudioPlayer.currentPosition,
              builder: (context, asyncSnapshot) {
                SleekCircularSlider s;
                String time = "00:00";
                final Duration position = asyncSnapshot.data;
                if (assetsAudioPlayer.currentPosition.value == null ||
                    assetsAudioPlayer.currentPosition.value.inSeconds
                            .toString() ==
                        "0") {
                  print("check:" +
                      assetsAudioPlayer.currentPosition.value.inSeconds
                          .toString());
                  s = SleekCircularSlider(
                    min: 0,
                    max: 1,
                    initialValue: 0,
                    appearance: CircularSliderAppearance(
                      angleRange: 360,
                      size: MediaQuery.of(context).size.width * 0.65,
                      startAngle: 270,
                      animationEnabled: false,
                      animDurationMultiplier: 150,
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
                            height: MediaQuery.of(context).size.width * 0.58,
                            width: MediaQuery.of(context).size.width * 0.58,
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
                                    MediaQuery.of(context).size.width * 0.50,
                                width: MediaQuery.of(context).size.width * 0.50,
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
                                child: Icon(CupertinoIcons.double_music_note),
                              ),
                            ),
                          ),
                        ],
                      );

                      // Image.asset("assets/icon.png",scale: 4,);
                    },
                  );
                } else {
                  print("check2:" +
                      assetsAudioPlayer.currentPosition.value.inSeconds
                          .toString());
                  time = _printDurationAsString(
                      new Duration(seconds: position.inSeconds.toInt()));
                  s = SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      angleRange: 360,
                      size: MediaQuery.of(context).size.width * 0.65,
                      startAngle: 270,
                      customWidths: CustomSliderWidths(
                          trackWidth: 2, progressBarWidth: 3, handlerSize: 2),
                      customColors: CustomSliderColors(progressBarColors: [
                        Color(0xffF9657F),
                        Color(0xffF61976)
                      ], trackColors: [
                        Color(0x66F9657F),
                        Color(0x66F61976)
                      ]), //#F9657F->#F61976
                    ),
                    min: 0,
                    max: assetsAudioPlayer
                        .current.value.audio.duration.inSeconds
                        .toDouble(),
                    initialValue: position.inSeconds.toDouble() ==
                            assetsAudioPlayer
                                .current.value.audio.duration.inSeconds
                                .toDouble()
                        ? 0
                        : position.inSeconds.toDouble(),
                    onChange: (double value) {
                      // callback providing a value while its being changed (with a pan gesture)
                      setState(
                        () {
                          Duration d = new Duration(seconds: value.toInt());
                          d = _printDuration(d);
                          seekTo(d);
                        },
                      );
                    },
                    onChangeEnd: (double value) {
                      // setState(
                      //   () {
                      //     Duration d = new Duration(seconds: value.toInt());
                      //     d = _printDuration(d);
                      //     seekTo(d);
                      //   },
                      // );
                    },
                    onChangeStart: (double value) {
                      // callback providing a value while its being changed (with a pan gesture)
                    },
                    // onChangeEnd: (double endValue) {
                    //   // ucallback providing an ending value (when a pan gesture ends)
                    // },
                    innerWidget: (double value) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width * 0.58,
                            width: MediaQuery.of(context).size.width * 0.58,
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
                                MediaQuery.of(context).size.width * 0.50,
                                width: MediaQuery.of(context).size.width * 0.50,
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
                                child: Icon(CupertinoIcons.double_music_note),
                              ),
                            ),
                          ),
                        ],
                      );

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

            Padding(
              padding: EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        shuffle();
                      });
                    },
                    child: Icon(
                      Icons.shuffle,
                      size: 40,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        prev();
                      });
                    },
                    child: Icon(
                      Icons.skip_previous,
                      size: 60,
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
                              playOrpause();
                            });
                          },
                          child: RadiantGradientMask(
                              child: Icon(
                                pIcon,
                                size: 80,
                              ),
                              c1: Color(0xffF9657F),
                              c2: Color(0xffF61976)),
                        );
                      }),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        next();
                      });
                    },
                    child: Icon(
                      Icons.skip_next,
                      size: 60,
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
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            // SliderTheme(
            //   data: SliderTheme.of(context).copyWith(
            //     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
            //     overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
            //     // activeTrackColor: Color(0xffC38FFF),
            //     // thumbColor: Color(0xffC38FFF),
            //     // inactiveTrackColor: Color(0x55C38FFF),
            //     activeTrackColor: Color(0xff03DAC5),
            //     thumbColor: Color(0xff03DAC5),
            //     inactiveTrackColor: Color(0x5503DAC5),
            //     overlayColor: Color(0x5503DAC5),
            //   ),
            //   child: StreamBuilder(
            //     stream: assetsAudioPlayer.currentPosition,
            //     builder: (context, asyncSnapshot) {
            //       if (asyncSnapshot.data == null) {
            //         return Slider(
            //           value: 0.0,
            //           onChanged: (double value) => null,
            //         );
            //       } else {
            //         final Duration position = asyncSnapshot.data;
            //         return Slider(
            //             value: position.inSeconds.toDouble(),
            //             min: 0,
            //             max: assetsAudioPlayer.current.value == null
            //                 ? 100
            //                 : assetsAudioPlayer
            //                     .current.value.audio.duration.inSeconds
            //                     .toDouble(),
            //             onChanged: (double x) {
            //               setState(
            //                 () {
            //                   Duration d = new Duration(seconds: x.toInt());
            //                   d = _printDuration(d);
            //                   seekTo(d);
            //                 },
            //               );
            //             });
            //       }
            //     },
            //   ),
            // ),
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
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      for (File file in files) {
        audios.add(Audio.file(file.path));
      }
      assetsAudioPlayer.open(
        Playlist(audios: audios),
        autoStart: false,
      );
      _add = true;
    } else {
      // User canceled the picker
    }
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

  void deactivate() {
    assetsAudioPlayer.stop();
  }
}
