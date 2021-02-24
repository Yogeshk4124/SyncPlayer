import 'dart:convert';

import 'package:SyncPlayer/audioPlayer.dart';
import 'package:SyncPlayer/audioPlayerJoin.dart';
import 'package:SyncPlayer/videoPlayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _joinController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _joinController.dispose();
    super.dispose();
  }

  Future<http.Response> createRoom() async {
    http.Response response =
        await http.get('http://20.197.61.11:8000/createRoom');
    return response;
  }
  Future<void> _showMyDialog() async {
    String valueText="";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _joinController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    int codeDialog = int.parse(valueText);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return audioPlayerJoin(RoomId: codeDialog);
                      }),
                    );
                  });
                },
              ),

            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color(0xff14174E),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Future<http.Response> response = createRoom();
                  response.then((value) {
                    if (value.statusCode == 200) {
                      var decodedData=jsonDecode(value.body);
                      print("Room Id:" + decodedData['Room-id'].toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return audioPlayer(RoomId: decodedData['Room-id'],);
                          // return videoPlayer();
                        }),
                      );
                    } else
                      AlertDialog(title: Text("Error"));
                  });
                },
                child: IconText(
                  icon: CupertinoIcons.double_music_note,
                  text: "Create",
                  gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.redAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
              ),
              SizedBox.fromSize(
                size: Size(0, 60),
              ),
              GestureDetector(
                onTap: (){
                  _showMyDialog();
                },
                child: IconText(
                    icon: CupertinoIcons.double_music_note,
                    text: "Join",
                    gradient: LinearGradient(
                        colors: [Colors.lightBlueAccent, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final LinearGradient gradient;

  IconText({@required this.icon, @required this.text, @required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.all(
            Radius.circular(MediaQuery.of(context).size.height * 0.07)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              icon,
              size: MediaQuery.of(context).size.height * 0.20,
            ),
            SizedBox.fromSize(
              size: Size(10, 20),
            ),
            Text(
              text,
              style: GoogleFonts.poiretOne(
                  fontSize: 50, fontWeight: FontWeight.w800),
            )
          ],
        ),
      ),
    );
  }
}
