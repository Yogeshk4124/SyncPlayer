import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

TextEditingController _jController = new TextEditingController();

class Configuration {
  final Map<String, dynamic> data;
  static Map<String, dynamic> data2;

  Configuration({@required this.data}) {
    data2 = data;
  }

  Widget w0 = Container(
      child: CircularProgressIndicator(
    backgroundColor: Colors.red,
  ));

  Widget joining = Column(
    children: <Widget>[
      TextField(
        controller: _jController,
      )
    ],
  );
  static Widget w1 = Column(
    children: [
      Text('Created:' + data2['Create'].toString()),
      // SpinKitDoubleBounce(
      //   color: Colors.white,
      //   size: 100.0,
      // ),
    ],
  );

  int getStatus(String op) {
    print("inStatus:" + data2['Create'].toString());
    data2 = data;
    if (op == 'c') {
      if (data['Create'] != '-1' && data['Join'] == '-1') return 1;
      if (data['Create'] == '-1' && data['Join'] != '-1') return 2;
      if (data['Join'] == '-1')
        return 2;
      else if (data['Create'] != '-1')
        return 3;
      else if (data['Join'] != '-1')
        return 4;
      else
        return 0;
    } else if (op == 'j') {
      if (data['Create'] != '-1' && data['Join'] == '-1') return 1;
      if (data['Create'] == '-1' && data['Join'] != '-1') return 2;
      if (data['Join'] == '-1')
        return 2;
      else if (data['Create'] != '-1')
        return 3;
      else if (data['Join'] != '-1')
        return 4;
      else
        return 0;
    }
  }

  Widget getWidget(String op) {
    int x = getStatus(op);
    print("getting Widget:" + x.toString());
    switch (x) {
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Created:' + data['Create'].toString(),
              style: TextStyle(fontSize: 30),
            ),
            SizedBox.fromSize(
              size: Size(10, 30),
            ),
            MaterialButton(
              onPressed: () {
                Future<http.Response> response = http.get(
                    'http://20.197.61.11:8000/closeRoom' +
                        data['Create'].toString());
                response.then((value) {
                  data['Create'] = '-1';
                  // setState(() {
                  //   print("setting:"+widget.data['Create'].toString());
                  //   w=Configuration(data: widget.data).getWidget('c');
                  // });
                });
              },
              child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text('Disconnect')),
            ),
          ],
        );
        break;
      case 2:
        return joining;
        break;
      case 3:
        break;
      case 4:
        return joining;
        break;
      default:
        break;
    }
  }
}
