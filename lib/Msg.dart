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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ChangeNotifierProvider(
              create: (context) => Chats(widget.username),
              child: Messages(roomid: widget.roomid, username: widget.username),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Container(
                  height: 30,
                  child: TextField(
                      controller: msgController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)))),
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
                      http.Response response = await http.get(s);
                      msgController.clear();
                    }),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
