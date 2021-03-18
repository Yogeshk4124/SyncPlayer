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
                // Color(0xffF61976),
                // Color(0xffF9657F),
                // Colors.red, Colors.deepOrange,
                // Color(0xffff0000),
                // Color(0xAAd70000),
                // Color(0x88c60000),
                // Color(0xAAb70000),
                // Color(0xff9b0000)
                Color(0x559b0000),
                Colors.red,
                Color(0x559b0000),
              ],
              begin: Alignment.topRight,
              end:Alignment.bottomLeft,

            ),
            // color: Colors.white,
          ),
          child: Center(
            child: Container(
              height: MediaQuery.maybeOf(context).size.width * 0.46,
              width: MediaQuery.maybeOf(context).size.width * 0.46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: new LinearGradient(
                  colors: [
                    // Color(0xffF9657F),
                    // Color(0xffF61976)
                    // Color(0xff9b0000),
                    // Color(0xAAb70000),
                    // Color(0x88c60000),
                    // Color(0xAAd70000),
                    // Color(0xffff0000),

                    // Color(0xffff0000),
                    Colors.red,
                    Color(0x559b0000),
                    Colors.red,

                    // Color(0xffff0000),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  // color: Colors.pink,
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
