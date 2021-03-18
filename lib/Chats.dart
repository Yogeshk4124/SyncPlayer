import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Chats extends ChangeNotifier {
  List msg = [];
  int msgCall = 0;
  Column column = Column(
    children: <Widget>[],
  );

  getChats(context, int roomid) async {
    if (msgCall == 0) {
      msgCall = 1;
      http.Response response = await http.get(
          "http://harmonpreet012.centralindia.cloudapp.azure.com:8001/getMessages/" +
              roomid.toString());
      var decodedData = jsonDecode(response.body);
      List temp = new List();
      for (dynamic res in decodedData) {
        temp.add([res[0].toString(), res[1].toString()]);
      }
      if (temp.length != msg.length) {
        msg = temp;
        print('msg:' + msg.toString());
        column.children.clear();
        for (dynamic m in msg)
          if (m[0].toString() != "ME")
            column.children.add(Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                        bottomLeft: Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 30, top: 4, bottom: 4),
                    child: Column(
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
                )));
          else
            column.children.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      gradient: LinearGradient(colors: [Colors.black87,Colors.black12]),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 30, top: 4, bottom: 4),
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
            );
        notifyListeners();
      }
      msgCall = 0;
    }
  }

  Column setChats() => column;
}
