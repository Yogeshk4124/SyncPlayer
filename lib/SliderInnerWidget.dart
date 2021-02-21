
import 'package:flutter/cupertino.dart';

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
          height: MediaQuery.of(context).size.width * 0.54,
          width: MediaQuery.of(context).size.width * 0.54,
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
              child: Center(
                  child: Icon(
                    CupertinoIcons.double_music_note,
                    size:
                    MediaQuery.of(context).size.width * 0.30,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
