import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Chats.dart';

class Messages extends StatefulWidget {
  Messages({@required this.roomid});

  final int roomid;

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List msg;
  Column column;

  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
       Provider.of<Chats>(context, listen: false).getChats(context,widget.roomid);
    });
    super.initState();
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    return
    SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:
          Consumer<Chats>(
        builder: (context, data, child) {
          if(data.setChats()!=null)
          print('Data:' + data.setChats().children.length.toString());
          return Column(crossAxisAlignment:CrossAxisAlignment.start,children: data.setChats().children,);
        },
      ),
    );
  }
}
