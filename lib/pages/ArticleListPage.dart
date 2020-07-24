import 'dart:async';
import 'package:woandroid/pages/BaseState.dart';

import 'package:flutter/material.dart';
import 'package:woandroid/constant/Costants.dart';
import 'package:woandroid/view/EndLine.dart';
import 'package:woandroid/http/Api.dart';
import 'package:woandroid/http/HttpUtilWithCookie.dart';
import 'package:woandroid/itemView/ArticleItem.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ArticleListPage extends StatefulWidget {
  String id;

  ArticleListPage(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ArticleListPageState();
  }
}

class ArticleListPageState extends BaseState<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  int curPage = 0;
  Map<String, String> map = new Map();
  List listData = new List();
  int listTotalSize = 0;
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getArticleList();

    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels && listData.length < listTotalSize) {
        _getArticleList();
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
    if (listData == null || listData.isEmpty) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      Widget listView = new ListView.builder(
          key: new PageStorageKey(widget.id),
          physics: AlwaysScrollableScrollPhysics(),//  保证数据较少，不到一屏幕也可以刷新数据
          itemCount: listData.length,
          controller: _controller,

          itemBuilder: (context, i) =>

              AnimationConfiguration.staggeredList(
                  position: i,
                  duration: const Duration(milliseconds: 375),
                  child: new SlideAnimation(
                      verticalOffset: 50.0,
                      child: new FadeInAnimation(
                          child:  buildItem(i))
                      )
                  )
              );

      return new RefreshIndicator(child: AnimationLimiter(child: listView), onRefresh: _pushToRefresh);
    }
  }

  Future<Null> _pushToRefresh() async {
    curPage = 0;
    setState(() {
      listData.clear();
    });
    _getArticleList();
    return null;
  }

  Widget buildItem(i) {
    var item = listData[i];
    if (i == listData.length - 1 && item.toString() == Constants.END_LINE_TAG) {
      return new EndLine();
    }
    return ArticleItem(item);
  }

  void _getArticleList() {
    String url = Api.ARTICLE_LIST;
    url += "$curPage/json";
    map['cid'] = widget.id;
    HttpUtil.get(url, (data) {
      if (data != null) {
        Map<String, dynamic> map = data;
        var _listData = map['datas'];
        listTotalSize = map['total'];
        setState(() {
          List list1 = new List();
          if (curPage == 0) {
            listData.clear();
          }
          curPage++;
          list1.addAll(listData);
          list1.addAll(_listData);
          if (list1.length >= listTotalSize) {
            list1.add(Constants.END_LINE_TAG);
          }
          listData = list1;
        });
      }
    }, params: map);
  }
}
