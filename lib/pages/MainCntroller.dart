import 'package:flutter/material.dart';
import 'package:woandroid/pages/FavoritePage.dart';
import 'package:woandroid/pages/MinePage.dart';
import 'package:woandroid/pages/HomePage.dart';

import 'package:woandroid/pages/SearchPage.dart';
import 'package:woandroid/pages/BaseState.dart';


class MainController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MainControllerState();
  }
}

class MainControllerState extends BaseState<MainController> with TickerProviderStateMixin{
  int _tabIndex=0;
  List<BottomNavigationBarItem> _navigationItems;

  List<String> tabNames=['home','favorite','user'];

  var _body;

  final navigationKey=GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {

    initData();

    // TODO: implement build
    return MaterialApp(
      navigatorKey: navigationKey,
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.cyan
      ),
      home: Scaffold(
        body: _body,
        appBar: AppBar(
          title: Text(tabNames[_tabIndex],
          style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(icon: new Icon(Icons.search),
                onPressed: (){
              navigationKey.currentState.push(new MaterialPageRoute(builder: (context){
                return new SearchPage("");
              }));
            })
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: _navigationItems.map((BottomNavigationBarItem bar)=>bar).
            toList(),
          currentIndex: _tabIndex,
          type: BottomNavigationBarType.fixed,
            onTap: (index){
              setState(() {
                _tabIndex=index;
              });
            },
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _navigationItems=[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text(tabNames[0]),
        backgroundColor: Colors.blue
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        title: Text(tabNames[1]),
        backgroundColor: Colors.blue
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        title: Text(tabNames[2]),
        backgroundColor: Colors.blue
      ),
    ];
  }

   initData() {
    _body=IndexedStack(
      children: <Widget>[HomePage(),FavoritePage(),MinePage()],
      index: _tabIndex,
    );
  }
}