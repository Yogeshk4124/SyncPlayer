import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Chats.dart';

class Messages extends StatefulWidget {
  Messages({@required this.roomid, @required this.username});

  final int roomid;
  final String username;

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List msg;
  Column column;
  ScrollController scroller = new ScrollController();
  dynamic curScroll;
  Timer timer;

  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      Provider.of<Chats>(context, listen: false)
          .getChats(context, widget.roomid, scroller);
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.width * 0.319,
        child: Consumer<Chats>(builder: (context, data, child) {
          List l = data.setChats();
          CustomScrollView sc = CustomScrollView(
              controller: scroller,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
                    child: Container(
                      padding: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            l[index][0].toString(),
                            style: GoogleFonts.roboto(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l[index][1].toString(),
                            style: GoogleFonts.notoSans(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: l.length))
              ]);
          // scroller.jumpTo(scroller.position.maxScrollExtent);
          return sc;
        }));
  }
}
