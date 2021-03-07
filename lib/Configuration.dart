import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
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
      link = 'http://harmonpreet012.centralindia.cloudapp.azure.com:8000/createRoom';
  String Jjoining = 'Enter Room Id',
      Jbutton = "Join",
      Jlink = 'http://harmonpreet012.centralindia.cloudapp.azure.com:8000/addUser/';
  int get = 0;

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
      link = 'http://harmonpreet012.centralindia.cloudapp.azure.com:8000/closeRoom/' +
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
                fontSize: 20,
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
                      link = 'http://harmonpreet012.centralindia.cloudapp.azure.com:8000/closeRoom/' +
                          widget.data['Create'].toString();
                      button = "Disconnect";
                    } else {
                      widget.data['Create'] = '-1';
                      print("CD:2");
                      creating =
                          'You have not Created/Joined any room.Create Room?';
                      button = "Connect";
                      link = 'http://harmonpreet012.centralindia.cloudapp.azure.com:8000/createRoom';
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
                'You have already Joined a room Disconnect first then create',
                style: GoogleFonts.roboto(),
                textAlign: TextAlign.center),
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
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox.fromSize(
              size: Size(10, 10),
            ),
            Container(
              width: 100,
              height: 40,
              child: Center(
                  child: TextField(
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      style: BorderStyle.solid,
                    ),
                  ),
                  fillColor: Color(0xff404040),
                  // disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(5),
                  // enabledBorder: InputBorder.none,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                textAlign: TextAlign.center,
                controller: _joinController,
              )),
            ),
            if (get == 1)
              Container(
                margin: EdgeInsets.only(bottom: 20,top: 5),
                child: Text("Room Not Found",style: TextStyle(color: Colors.red),),
              )
            else
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
                      if (decodedData['status'].toString() !=
                          "room not found") {
                        // if (widget.data['Join'] == '-1') {
                        widget.data['Join'] = decodedData['room-id'].toString();
                        Jjoining = 'Joined:' + widget.data['Join'].toString();
                        Jbutton = "Leave";
                        get = 0;
                        // }
                      } else
                        get = 1;
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
                  child: Text(
                    Jbutton,
                    style: GoogleFonts.roboto(),
                    textAlign: TextAlign.center,
                  )),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      color:
                          _selected == 1 ? Colors.redAccent : Color(0xff181818),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.person_add_solid),
                          Text(
                            "Create",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.038),
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
                      color:
                          _selected == 2 ? Colors.redAccent : Color(0xff181818),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.dot_radiowaves_left_right),
                          Text(
                            "Join",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.038),
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
    );
  }
}
