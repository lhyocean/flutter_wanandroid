import 'package:woandroid/util/FlutterUtil.dart';
import 'package:flutter/material.dart';
import 'package:woandroid/pages/ArticleDetailPage.dart';

class BannerView extends StatefulWidget{
  List data;
  BannerView(this.data);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new BannerViewState();
  }
}

class BannerViewState extends State<BannerView> with SingleTickerProviderStateMixin{

  PageController _pageController=new PageController();
  TabController _tabController;
  int currentPage=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController=new TabController(length: widget.data.length, vsync: this);

  }

  @override
  void dispose() {
    // TODO: implement dispose

    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    Stack stack=new Stack(
      children: <Widget>[
      PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _buildItems(),
      ),
      new Align(
        alignment: FractionalOffset.bottomCenter,
        child: new Container(
          width: 1000.0,
          color: const Color(0x50000000),
          padding: const EdgeInsets.all(5.0),
          child: new Text(widget.data[currentPage]['title'],
              style: new TextStyle(
                  color: Colors.white, fontSize: 15.0)),
        ),
      ),

      new Container(
        padding: EdgeInsets.only(bottom: 5.0,right: 5.0),
        child: new Align(
          alignment: FractionalOffset.bottomRight,

          child: new TabPageSelector(
            indicatorSize: 10,
            controller: _tabController,
            color: null,
            selectedColor: Colors.white,
          ),
        ),
      )
      ,


      ],
    );



    Container container=new Container(
      height: 150,
      child: stack,
    );
    // TODO: implement build
    return container;
  }

  void _onPageChanged(int pos) {
    setState(() {
      currentPage=pos;
      _tabController.animateTo(pos);
      print(currentPage);
    });
  }

  List<Widget> _buildItems() {
    List<Widget> list=[];

    if (widget.data != null && widget.data.length > 0) {
      for (var i = 0; i < widget.data.length; i++) {
        var item = widget.data[i];
        var imgUrl = item['imagePath'];

        item['link'] = item['url'];
        list.add(new GestureDetector(
            onTap: () {
              _handOnItemClick(item);
            },
            child: AspectRatio(
              aspectRatio: 2.0 / 1.0,
              child: new Stack(
                children: <Widget>[
                  new Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    width: 1000.0,
                  ),
                ],
              ),
            )));
      }
    }
    return list;
  }

  void _handOnItemClick(itemData) {
    FlutterUtil.jumpToPage(context, new ArticleDetailPage(title: itemData['title']
      ,url: itemData['link'],));

  }
}

