import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chats extends ChangeNotifier {
  List msg=[];
  int msgCall = 0;
  Column column=Column(
    children: <Widget>[],
  );
  getChats(int roomid) async {
    // print('calling');
    if (msgCall == 0) {
      msgCall=1;
      http.Response response = await http.get(
          "http://harmonpreet012.centralindia.cloudapp.azure.com:8001/getMessages/" +
              roomid.toString());
      var decodedData = jsonDecode(response.body);
      // print("\n\n\n\nGot" + decodedData.toString());
      List temp = new List();
      for (dynamic res in decodedData) {
        temp.add([res[0].toString(), res[1].toString()]);
      }
      if (temp.length != msg.length) {
        // print("Got" + decodedData.toString());
        // print(temp.length.toString() + ":" + msg.length.toString());
        msg = temp;
        print('msg:'+msg.toString());
        column.children.clear();
        for(dynamic m in msg)
        column.children.add(Column(
          children: <Widget>[
            Text(m[0].toString(),style: TextStyle(color: Colors.white),),
            Text(m[1].toString(),style: TextStyle(color: Colors.white),),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
        // print("msgs:"+msg.toString());
        notifyListeners();
      }


      msgCall=0;

    }
  }
  Column setChats()=>column;
}
