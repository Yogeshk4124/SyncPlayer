import 'dart:convert';
import 'dart:ui';

import 'package:SyncPlayer/Utils/Configuration.dart';
import 'package:SyncPlayer/audioPlayer.dart';
import 'package:SyncPlayer/audioPlayerJoin.dart';
import 'package:SyncPlayer/videoPlayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Home2 extends StatefulWidget {
  final Map<String, dynamic> data;

  Home2({@required this.data});

  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  final _joinController = TextEditingController();
  int _selected = 1;
  String creating = 'You have not Created/Joined any room.Create Room?',
      button = "Connect",
      link = 'http://20.197.61.11:8000/createRoom';
  String Jjoining = 'Enter Room Id',
      Jbutton = "Join",
      Jlink = 'http://20.197.61.11:8000/addUser/';

  @override
  void initState() {
    super.initState();
    if (widget.data['Create'] == '-1' && widget.data['Join'] != '-1') {
      _selected = 2;
      Jjoining = 'Joined:' + widget.data['Join'].toString();
      Jbutton = "Leave";
    } else if (widget.data['Create'] != '-1' && widget.data['Join'] == '-1') {
      _selected = 1;
      creating = 'Created:' + widget.data['Create'].toString();
      link = 'http://20.197.61.11:8000/closeRoom/' +
          widget.data['Create'].toString();
      button = "Disconnect";
    }
  }

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
    String valueText = "";

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
    Widget createDestroy() {
      print("error:" + widget.data.toString());
      if (widget.data['Join'] == '-1')
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              creating,
              style: TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox.fromSize(
              size: Size(10, 30),
            ),
            MaterialButton(
              onPressed: () {
                print("link:" + link);
                Future<http.Response> response = http.get(link);
                response.then((value) {
                  var decodedData = jsonDecode(value.body);

                  setState(() {
                    if (widget.data['Create'] == '-1') {
                      print("CD:1");
                      widget.data['Create'] = decodedData['Room-id'].toString();
                      creating = 'Created:' + widget.data['Create'].toString();
                      link = 'http://20.197.61.11:8000/closeRoom/' +
                          widget.data['Create'].toString();
                      button = "Disconnect";
                    } else {
                      widget.data['Create'] = '-1';
                      print("CD:2");
                      creating =
                          'You have not Created/Joined any room.Create Room?';
                      button = "Connect";
                      link = 'http://20.197.61.11:8000/createRoom';
                    }
                  });
                });
              },
              child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(button)),
            ),
          ],
        );
      else {
        return Container(
          child: Center(
            child: Text(
                'You have already Joined a room Disconnect first then create'),
          ),
        );
      }
    }

    Widget join() {
      print("error:" + widget.data.toString());
      if (widget.data['Create'] == '-1') {
        print("per");
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Jjoining,
              style: TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox.fromSize(
              size: Size(10, 30),
            ),
            Container(
              width: 80,
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                ),
                controller: _joinController,
              ),
            ),
            SizedBox.fromSize(
              size: Size(40, 30),
            ),
            MaterialButton(
              onPressed: () {
                // print("link:" + link);
                if (widget.data['Join'] == '-1') {
                  Future<http.Response> response =
                      http.get(Jlink + _joinController.text);
                  response.then((value) {
                    var decodedData = jsonDecode(value.body);
                    print("eBody:" + decodedData.toString());
                    setState(() {
                      if (widget.data['Join'] == '-1') {
                        widget.data['Join'] = decodedData['room-id'].toString();
                        Jjoining = 'Joined:' + widget.data['Join'].toString();
                        Jbutton = "Leave";
                      }
                    });
                  });
                } else {
                  setState(() {
                    print("ipart:" + widget.data['Join'].toString());
                    setState(() {
                      widget.data['Join'] = '-1';
                      Jbutton = 'Join';
                      Jjoining = "Enter Room id";
                    });
                  });
                }
              },
              child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(Jbutton)),
            ),
          ],
        );
      } else {
        return Container(
          child: Center(
            child: Text(
                'You have already hosting a room Disconnect first then join'),
          ),
        );
      }
    }

    Widget w;
    if (_selected == 1)
      w = createDestroy();
    else
      w = join();
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Text(
                "Configuration",
                style: GoogleFonts.poiretOne(
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                ),
                maxLines: 1,
              ),
              SizedBox.fromSize(
                size: Size(10, 40),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text('Sync Player Setting',style: GoogleFonts.poiretOne(fontSize: 30),),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selected = 1;
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.height * 0.20,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                            MediaQuery.of(context).size.width * 0.02)),
                        // color: Color(0xff2C353D),
                        color: _selected == 1
                            ? Colors.redAccent
                            : Color(0xff181818),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.person_add_solid),
                            Text(
                              "Create",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.038),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(10, 10),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Configuration c = new Configuration(data: widget.data);
                      setState(() {
                        _selected = 2;
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.height * 0.20,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                            MediaQuery.of(context).size.width * 0.02)),
                        // color: Color(0xff2C353D),
                        color: _selected == 2
                            ? Colors.redAccent
                            : Color(0xff181818),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.dot_radiowaves_left_right),
                            Text(
                              "Join",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.038),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Color(0xff181818)),
                  child: w,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
