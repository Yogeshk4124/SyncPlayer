import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class SliderInnerWidget extends StatelessWidget {
  const SliderInnerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.maybeOf(context).size.width * 0.54,
          width: MediaQuery.maybeOf(context).size.width * 0.54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: new LinearGradient(
              colors: [
                Color(0x559b0000),
                Colors.red,
                Color(0x559b0000),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Center(
            child: Container(
              height: MediaQuery.maybeOf(context).size.width * 0.46,
              width: MediaQuery.maybeOf(context).size.width * 0.46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: new LinearGradient(
                  colors: [
                    Colors.red,
                    Color(0x559b0000),
                    Colors.red,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                  child: Icon(
                CupertinoIcons.double_music_note,
                size: MediaQuery.maybeOf(context).size.width * 0.30,
              )),
            ),
          ),
        ),
      ],
    );
  }
}
