import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask(
      {@required this.child, @required this.c1, @required this.c2});

  final Widget child;
  final Color c1, c2;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [c1, c2],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
