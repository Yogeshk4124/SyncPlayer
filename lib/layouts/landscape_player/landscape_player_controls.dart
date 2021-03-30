import 'dart:ui';
import '../../Msg.dart';
import 'play_toggle.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popup_window/popup_window.dart';

class LandscapePlayerControls extends StatelessWidget {
  LandscapePlayerControls(
      {this.iconSize = 20,
      this.fontSize = 12,
      @required this.id,
      @required this.username,
      @required this.chatEnabled});

  final bool chatEnabled;
  final int id;
  final String username;
  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlickShowControlsAction(
          child: FlickSeekVideoAction(
            child: Center(
              child: FlickVideoBuffer(
                child: FlickAutoHideChild(
                  showIfVideoNotInitialized: false,
                  child: LandscapePlayToggle(),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlickPlayToggle(
                        size: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlickCurrentPosition(
                        fontSize: fontSize,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: FlickVideoProgressBar(
                            flickProgressBarSettings: FlickProgressBarSettings(
                              height: 10,
                              handleRadius: 10,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 8,
                              ),
                              backgroundColor: Colors.white24,
                              bufferedColor: Colors.white38,
                              getPlayedPaint: (
                                  {double handleRadius,
                                  double height,
                                  double playedPart,
                                  double,
                                  width}) {
                                return Paint()
                                  ..shader = LinearGradient(colors: [
                                    Color.fromRGBO(108, 165, 242, 1),
                                    Color.fromRGBO(97, 104, 236, 1)
                                  ], stops: [
                                    0.0,
                                    0.5
                                  ]).createShader(
                                    Rect.fromPoints(
                                      Offset(0, 0),
                                      Offset(width, 0),
                                    ),
                                  );
                              },
                              getHandlePaint: (
                                  {double handleRadius,
                                  double height,
                                  double playedPart,
                                  double,
                                  width}) {
                                return Paint()
                                  ..shader = RadialGradient(
                                    colors: [
                                      Color.fromRGBO(97, 104, 236, 1),
                                      Color.fromRGBO(97, 104, 236, 1),
                                      Colors.white,
                                    ],
                                    stops: [0.0, 0.4, 0.5],
                                    radius: 0.4,
                                  ).createShader(
                                    Rect.fromCircle(
                                      center: Offset(playedPart, height / 2),
                                      radius: handleRadius,
                                    ),
                                  );
                              },
                            ),
                          ),
                        ),
                      ),
                      FlickTotalDuration(
                        fontSize: fontSize,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      if (chatEnabled)
                        Center(
                          child: PopupWindowButton(
                            offset: Offset(
                                MediaQuery.of(context).size.width / 1.35,
                                -MediaQuery.of(context).size.height + 2),
                            buttonBuilder: (BuildContext context) {
                              return Icon(Icons.chat);
                            },
                            windowBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return Center(
                                child: FadeTransition(
                                  opacity: animation,
                                  child: SizeTransition(
                                    sizeFactor: animation,
                                    child: Container(
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.80,
                                      // height: MediaQuery.of(context).size.width - 435,
                                      child: Msg(
                                        roomid: id,
                                        username: username,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            onWindowShow: () {
                              print('PopupWindowButton window show');
                            },
                            onWindowDismiss: () {
                              print('PopupWindowButton window dismiss');
                            },
                          ),
                        ),
                      if (chatEnabled)
                        SizedBox(
                          width: 10,
                        ),
                      FlickSoundToggle(
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 10,
          child: GestureDetector(
            onTap: () {
              SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              Navigator.pop(context);
            },
            child: Icon(
              Icons.cancel,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
