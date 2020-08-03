import 'package:flutter/material.dart';
import 'package:woandroid/http/Api.dart';
import 'package:woandroid/http/HttpUtil.dart';
import 'package:woandroid/pages/BaseState.dart';
import 'ArticleDetailPage.dart';
import 'SearchPage.dart';

class HotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HotPageState();
  }
}

class HotPageState extends BaseState<HotPage> {
  List<Widget> hotKeyWidgets = new List();
  List<Widget> friendWidgets = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getFriend();
    _getHotKey();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "热门搜索",
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child:  Wrap(
            spacing: 10.0,
            runSpacing: 0.0,
            children: hotKeyWidgets,
          ),
        ),

        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "常用网站",
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child:  Wrap(
            spacing: 10.0,
            runSpacing: 0.0,
            children: friendWidgets,
          ),
        ),
      ],
    );
  }

  void _getHotKey() {
    HttpUtil.get(Api.HOTKEY, (data) {
      if (data != null) {
        setState(() {
          List datas = data;
          hotKeyWidgets.clear();
          for (var itemData in datas) {
            Widget actionChip = ActionChip(
                backgroundColor: Theme.of(context).accentColor,
                label: Text(
                  itemData['name'],
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) {
                    return SearchPage(itemData['name']);
                  }));
                });
            hotKeyWidgets.add(actionChip);
          }
        });
      }
    });
  }

  void _getFriend() {
    HttpUtil.get(Api.FRIEND, (data) {
      setState(() {
        List datas = data;
        friendWidgets.clear();
        for (var itemdata in datas) {
          Widget child = ActionChip(
              backgroundColor: Theme.of(context).accentColor,
              label: Text(
                itemdata['name'],
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ArticleDetailPage(
                    title: itemdata['name'],
                    url: itemdata['link'],
                  );
                }));
              });
          friendWidgets.add(child);
        }
      });
    });
  }
}
