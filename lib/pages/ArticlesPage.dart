import 'package:flutter/material.dart';
import 'package:woandroid/pages/BaseState.dart';
import 'package:woandroid/pages/ArticleListPage.dart';

class ArticlesPage extends StatefulWidget {
  var data;

  ArticlesPage(this.data, [String s]);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ArticlesPageState();
  }
}
class ArticlesPageState extends BaseState<ArticlesPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> tabs = new List();
  List<dynamic> list;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = widget.data['children'];
    for (var value in list) {
      tabs.add(new Tab(text: value['name']));
    }
    _tabController = new TabController(length: list.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.data['name'])),
      body: new DefaultTabController(
          length: list.length,
          child: new Scaffold(
            appBar: new TabBar(
              tabs: tabs,
              isScrollable: true,
              controller: _tabController,
              labelColor: Theme.of(context).accentColor,
              unselectedLabelColor: Colors.blue,
              indicatorColor: Theme.of(context).accentColor,
            ),
            body: new TabBarView(

                controller: _tabController,
                children: list.map((dynamic e) => new ArticleListPage(e['id'].toString())).toList()),
          )),
    );
  }
}
