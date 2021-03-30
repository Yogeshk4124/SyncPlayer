import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Chats extends ChangeNotifier {
  List msg = [];
  int msgCall = 0;
  String username="empty";

  Chats(String name){
    username=name;
  }
  Column column = Column(
    children: <Widget>[],
  );

  getChats(context, int roomid,ScrollController scrollController) async {

    if (msgCall == 0 && username!="empty"){
      msgCall = 1;
      http.Response response = await http.get(
          "http://harmonpreet012.centralindia.cloudapp.azure.com:8001/getMessages/" +
              roomid.toString());
      var decodedData = jsonDecode(response.body);
      List temp = [];
      for (dynamic res in decodedData) {
        temp.add([res[0].toString(), res[1].toString()]);
      }
      if (temp.length != msg.length) {
        msg = temp;
        print('msg:' + msg.toString());
        column.children.clear();
        for (dynamic m in msg)
          if (m[0].toString() != username)
            column.children.add(
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                            bottomLeft: Radius.circular(50)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 40, top: 12, bottom: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              m[0].toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              m[1].toString(),
                              style: GoogleFonts.notoSans(
                                  fontSize: 13, color: Colors.white),
                            ),

                            // decoration: new BoxDecoration(color: Colors.red),

                            // decoration: BoxDecoration(
                            //   color: Colors.red,
                            //   borderRadius: BorderRadius.only(
                            //       bottomLeft: Radius.circular(20),
                            //       bottomRight: Radius.circular(20),
                            //       topRight: Radius.circular(20)),
                            // ),
                            // child: Text(
                            //   m[1].toString(),
                            //   style: TextStyle(color: Colors.white),
                            // )

                          ],
                        ),
                      ),
                    ),
                    Container(),
                  ],
                ),
              ),
            );
          else
            column.children.add(
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Container(
                      decoration: BoxDecoration(
                        // color: Colors.blue,
                        gradient: LinearGradient(
                            colors: [Colors.black87, Colors.black12]),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(100),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 12, bottom: 12),
                        child: Container(
                          child: Text(
                            m[1].toString(),
                            style: GoogleFonts.notoSans(
                                fontSize: 13, color: Colors.white),
                          ),
                        ),
                        // decoration: new BoxDecoration(color: Colors.red),

                        // decoration: BoxDecoration(
                        //   color: Colors.red,
                        //   borderRadius: BorderRadius.only(
                        //       bottomLeft: Radius.circular(20),
                        //       bottomRight: Radius.circular(20),
                        //       topRight: Radius.circular(20)),
                        // ),
                        // child: Text(
                        //   m[1].toString(),
                        //   style: TextStyle(color: Colors.white),
                        // )
                      ),
                    ),
                  ],
                ),
              ),
            );
        notifyListeners();
        // scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(seconds: 0), curve: Curves.fastOutSlowIn);
        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(seconds: 0), curve: Curves.fastOutSlowIn);
      }
      msgCall = 0;
    }
  }

  // List setChats() => column.children;
  List setChats() => msg;
}
