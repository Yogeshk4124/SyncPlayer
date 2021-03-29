import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'Chats.dart';
import 'Utils/Messages.dart';

class Msg extends StatefulWidget {
  Msg({@required this.roomid, @required this.username});

  final int roomid;
  final String username;

  @override
  _MsgState createState() => _MsgState();
}

class _MsgState extends State<Msg> {
  List msg;
  TextEditingController msgController;
  Column column;

  void initState() {
    msgController = new TextEditingController();
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   Provider.of<Chats>(context, listen: false)
    //       .getChats(context, widget.roomid);
    // });
    super.initState();
  }
  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    print("msgCalled");
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ChangeNotifierProvider(
            create: (context) => Chats(widget.username),
            child: Messages(
              roomid: widget.roomid,username: widget.username
            ),
          ),
          // Messages(roomid: widget.Roomid,),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 5,),
              Expanded(
                  child: Container(
                    height: 30,
                    child: TextField(
                        controller: msgController,
                        // decoration: InputDecoration(
                        //   // enabledBorder: InputBorder.none,
                        //   errorBorder: InputBorder.none,
                        //   // focusedBorder: InputBorder.none,
                        //   disabledBorder: InputBorder.none,
                        //   contentPadding: EdgeInsets.only(left: 15),
                        // ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(topRight:Radius.circular(20) ,bottomRight: Radius.circular(20))
                          )
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  )),
              IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () async {
                    String s =
                        "http://harmonpreet012.centralindia.cloudapp.azure.com:8001/sendMessage/" +
                            widget.roomid.toString() +
                            "/" +
                            widget.username +
                            "/" +
                            msgController.text;
                    // print("calling:" + s);
                    http.Response response = await http.get(s);
                    msgController.clear();
                  }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // Container(
          //   decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.all(Radius.circular(50))),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       Expanded(
          //           child: TextField(
          //               controller: msgController,
          //               decoration: InputDecoration(
          //                 enabledBorder: InputBorder.none,
          //                 errorBorder: InputBorder.none,
          //                 focusedBorder: InputBorder.none,
          //                 disabledBorder: InputBorder.none,
          //                 contentPadding: EdgeInsets.only(left: 15),
          //               ),
          //               style:
          //               TextStyle(fontSize: 16, color: Colors.black))),
          //       IconButton(
          //           icon: Icon(Icons.send, color: Colors.black),
          //           onPressed: () async {
          //             String s =
          //                 "http://harmonpreet012.centralindia.cloudapp.azure.com:8001/sendMessage/" +
          //                     widget.roomid.toString() +
          //                     "/" +
          //                     widget.username +
          //                     "/" +
          //                     msgController.text;
          //             // print("calling:" + s);
          //             http.Response response = await http.get(s);
          //             msgController.clear();
          //           }),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
