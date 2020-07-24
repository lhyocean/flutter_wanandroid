import 'package:flutter/material.dart';
import 'package:woandroid/pages/ArticleDetailPage.dart';
import 'package:woandroid/pages/BaseState.dart';
import 'package:woandroid/http/HttpUtilWithCookie.dart';
import 'package:woandroid/itemView/ArticleItem.dart';
import 'package:woandroid/http/Api.dart';
import 'package:woandroid/constant/Costants.dart';
import 'package:woandroid/view/EndLine.dart';
import 'package:woandroid/util/FlutterUtil.dart';
import 'package:woandroid/pages/LoginPage.dart';

class CollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CollectPageState();
  }
}

class CollectPageState extends BaseState<CollectPage> {
  int curPage = 0;
  Map<String, String> map = new Map();
  int listTotalSize = 0;
  ScrollController _controller = new ScrollController();
  List data=new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();

    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && data.length < listTotalSize) {
        _getData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text('我的收藏列表'),
      ),
      body: _createBody(),
    );
  }

  void _getData() {
    String url = Api.COLLECT_LIST;
    url += "$curPage/json";

    HttpUtil.get(url, (d) {
      if (d != null) {
        print(d);

        Map<String, dynamic> map = d;

        var _listData = map['datas'];

        listTotalSize = map["total"];

        setState(() {
          List list1 = new List();
          if (curPage == 0) {
            data.clear();
          }
          curPage++;
          list1.addAll(data);
          list1.addAll(_listData);
          if (list1.length >= listTotalSize) {
            list1.add(Constants.END_LINE_TAG);
          }
          data = list1;
        });
      }
   },
        params: map);
  }

  _createBody() {
    if (data == null || data.isEmpty) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      Widget listView = new ListView.builder(
        //
        physics: new AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, i) => buildItem(i),
        controller: _controller,
      );
      return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  Future<Null> _pullToRefresh() async{
    curPage = 0;
    _getData();
    return null;
  }

  buildItem(int i) {
    var itemData = data[i];

    if (i == data.length - 1 &&
        itemData.toString() == Constants.END_LINE_TAG) {
      return new EndLine();
    }

    Row row1 = new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Expanded(
            child: new Row(
              children: <Widget>[
                new Text('作者:  '),
                new Text(
                  itemData['author'],
                  style: new TextStyle(color: Theme.of(context).accentColor),
                ),
              ],
            )),
        new Text(itemData['niceDate'],style: TextStyle(color: Colors.deepPurple),)
      ],
    );

    Row title = new Row(
      children: <Widget>[
        new Expanded(
          child: new Text(
            itemData['title'],
            softWrap: true,
            style: new TextStyle(fontSize: 16.0, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );

    Row chapterName = new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new GestureDetector(
          child: new Icon(
//            isCollect ? Icons.favorite : Icons.favorite_border,
//            color: isCollect ? Colors.red : null,
            Icons.favorite, color: Colors.red,
          ),
          onTap: () {
            _handleListItemCollect(itemData);
          },
        )
      ],
    );

    Column column = new Column(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: row1,
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: title,
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child: chapterName,
        ),
      ],
    );

    return new Card(
      elevation: 4.0,
      child: new InkWell(
        onTap: () {
          _itemClick(itemData);
        },
        child: column,
      ),
    );
  }
  void _handleListItemCollect(itemData) {
    FlutterUtil.isLogin().then((isLogin) {
      if (!isLogin) {
        // 未登录
        _login();
      } else {
        _itemUnCollect(itemData);
      }
    });
  }

  void _itemClick(itemData) {
    FlutterUtil.jumpToPage(context, new ArticleDetailPage(title: itemData['title'], url: itemData['link']));

  }

  void _login() {

    FlutterUtil.jumpToPage(context, new LoginPage());
  }

  void _itemUnCollect(itemData) {

    String url;
    url = Api.UNCOLLECT_LIST;

    Map<String, String> map = new Map();
    map['originId'] = itemData['originId'].toString();
    url = url + itemData['id'].toString() + "/json";
    HttpUtil.post(url, (data) {
      setState(() {
        data.remove(itemData);
      });
    }, params: map);

  }
}
