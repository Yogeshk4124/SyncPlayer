import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BottomNav.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home4())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: Image.asset(
          "assets/images/logo.png",
          width: MediaQuery.maybeOf(context).size.width * 0.5,
          fit: BoxFit.fill,
          height: MediaQuery.maybeOf(context).size.width * 0.5,
        ));
  }
}
