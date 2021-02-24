import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getData() async {
  return Future.delayed(Duration(seconds: 1), () => {'prop1': 'value1'});
}

class PageOne extends StatelessWidget {
  final Map<String, dynamic> data;

  PageOne({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: const Text('update preferences'),
        onPressed: () {
          data['prop2'] = 'value2';
        },
      ),
    );
  }
}

class PageTwo extends StatelessWidget {

  final Map<String, dynamic> data;

  PageTwo({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: const Text('Got It!'),
        onPressed: () {
          print("data is now: [$data]");
        },
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  //Map<String, dynamic> Data;
  Map<String, dynamic> data;

  /*
  StartFunc() async {
    Data = await getData();
    setState(() {});
  }
  */

  @override
  void initState() {
    //StartFunc();
    super.initState();
    getData().then((values) {
      setState(() {
        data = values;
      });
    });
  }

  /*
  PageOne(data:data) is an invalid value for an initializer:
   there is no way to access this at this point.
    Initializers are executed before the constructor,
    but this is only allowed to be accessed after the call
    to the super constructor.

  */
  /*
  var _pages = [
    PageOne(data:data),
    PageTwo(),
  ];
  */

  Widget getPage(int index) {
    switch (index){
      case 0:
        return PageOne(data:data);
        break;
      case 1:
        return PageTwo(data:data);
        break;
      default:
        return PageOne();
        break;
    }
  }

  int _currentIndex = 0;

  onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    /*
    return _currentIndex == 2
        ? PageTwo()
        : Scaffold(

    I use a MaterialApp because of material widgets (RaisedButton)
    It is not mandatory, but it is mainstream in flutter

     */
    return MaterialApp(
        title: 'My App',
        home: Scaffold(
          appBar: AppBar(title: Text("My App Bar")),
          body: getPage(_currentIndex),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.first_page), title: Text('')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.last_page), title: Text('')),
            ],
            onTap: onTabTapped,
            currentIndex: _currentIndex,
          ),
        ));
  }
}