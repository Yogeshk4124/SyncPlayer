import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class player extends StatefulWidget {
  player({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _playerState createState() => _playerState();
}

// ignore: camel_case_types
class _playerState extends State<player> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool _play = false;
  int duration = 100;
  int percent = 0;
  final audios = <Audio>[
    //Audio.network(
    //  "https://d14nt81hc5bide.cloudfront.net/U7ZRzzHfk8pvmW28sziKKPzK",
    //  metas: Metas(
    //    id: "Invalid",
    //    title: "Invalid",
    //    artist: "Florent Champigny",
    //    album: "OnlineAlbum",
    //    image: MetasImage.network(
    //        "https://image.shutterstock.com/image-vector/pop-music-text-art-colorful-600w-515538502.jpg"),
    //  ),
    //),
    Audio.network(
      "https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Music_for_Video/springtide/Sounds_strange_weird_but_unmistakably_romantic_Vol1/springtide_-_03_-_We_Are_Heading_to_the_East.mp3",
      metas: Metas(
        id: "Online",
        title: "Online",
        artist: "Florent Champigny",
        album: "OnlineAlbum",
        // image: MetasImage.network("https://www.google.com")
        image: MetasImage.network(
            "https://image.shutterstock.com/image-vector/pop-music-text-art-colorful-600w-515538502.jpg"),
      ),
    ),
    Audio(
      "assets/audios/song.mp3",
      //playSpeed: 2.0,
      metas: Metas(
        id: "Rock",
        title: "Rock",
        artist: "Florent Champigny",
        album: "RockAlbum",
        image: MetasImage.network(
            "https://static.radio.fr/images/broadcasts/cb/ef/2075/c300.png"),
      ),
    ),
  ];

//Listen to the current playing song

  @override
  Widget build(BuildContext context) {
    Audio find(List<Audio> source, String fromPath) {
      return source.firstWhere((element) => element.path == fromPath);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          assetsAudioPlayer.builderCurrent(
            builder: (BuildContext context, Playing playing) {
              if (playing != null) {
                final myAudio = find(this.audios, playing.audio.assetAudioPath);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: myAudio.metas.image.type == ImageType.network
                        ? Image.network(
                            myAudio.metas.image.path,
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            myAudio.metas.image.path,
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                  ),
                );
              }
              return SizedBox();
            },
          ),
          assetsAudioPlayer.builderCurrent(
            builder: (context, playing) {
              if (playing == null) {
                return SizedBox();
              }
              return Column(
                children: <Widget>[
                  assetsAudioPlayer.builderLoopMode(
                    builder: (context, loopMode) {
                      return PlayerBuilder.isPlaying(
                        player: assetsAudioPlayer,
                        builder: (context, isPlaying) {
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    playandpause();
                                  });
                                },
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.green,
                                  size: 80,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    playandpause();
                                  });
                                },
                                child: Icon(
                                  Icons.pause_circle_outline,
                                  color: Colors.green,
                                  size: 80,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
          assetsAudioPlayer.builderRealtimePlayingInfos(
            builder: (context, infos) {
              if (infos == null) {
                return SizedBox();
              }
              // print("infos:"+infos.duration.toString());
              return Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                      // activeTrackColor: Color(0xffC38FFF),
                      // thumbColor: Color(0xffC38FFF),
                      // inactiveTrackColor: Color(0x55C38FFF),
                      activeTrackColor: Color(0xff03DAC5),
                      thumbColor: Color(0xff03DAC5),
                      inactiveTrackColor: Color(0x5503DAC5),
                      overlayColor: Color(0x5503DAC5),
                    ),
                    child: Slider(
                      value: percent.toDouble(),
                      min: 0,
                      max: 100,
                      onChanged: (double x) {
                        setState(
                          () {
                            print("Duration:" + infos.duration.toString());
                            print("inPercent:" +
                                (infos.duration * (x / 100)).toString());
                            seekTo(infos.duration * (x / 100));
                            percent = x.round();
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          assetsAudioPlayer.builderCurrent(
            builder: (BuildContext context, Playing playing) {
              return Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      open();
                    });
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.green,
                    size: 80,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void playandpause() async {
    final Duration position = assetsAudioPlayer.currentPosition.value;
    // StreamBuilder(
    //     stream: assetsAudioPlayer.currentPosition,
    //     builder: (context, asyncSnapshot) {
    //       final Duration duration = asyncSnapshot.data;
    //       return Text(duration.toString());
    //     });

    // else

    await assetsAudioPlayer.playOrPause();
    print(!_play);
    _play = !_play;
  }

  void open() async {
    await assetsAudioPlayer.open(
      Audio(
        "assets/audios/song.mp3",
      ),
    );
  }

  void seekTo(Duration duration) async {}
}
