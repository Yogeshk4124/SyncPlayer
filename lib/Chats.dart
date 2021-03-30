import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chats extends ChangeNotifier {
  List msg = [];
  int msgCall = 0;
  String username = "empty";

  Chats(String name) {
    username = name;
  }

  getChats(context, int roomid, ScrollController scrollController) async {
    if (msgCall == 0 && username != "empty") {
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
        notifyListeners();
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 0), curve: Curves.fastOutSlowIn);
      }
      msgCall = 0;
    }
  }

  List setChats() => msg;
}
