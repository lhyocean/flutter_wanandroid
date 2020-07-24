import 'package:flutter/material.dart';
import 'package:woandroid/pages/BaseState.dart';
import 'package:woandroid/view/SlideView.dart';
import 'package:woandroid/http/HttpUtilWithCookie.dart';
import 'package:woandroid/http/Api.dart';
import 'package:woandroid/constant/Costants.dart';
import 'package:woandroid/view/EndLine.dart';
import 'package:woandroid/itemView/ArticleItem.dart';
import 'package:woandroid/view/BannerView.dart';
class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomePageState();
  }
}

class HomePageState extends BaseState<HomePage>{
  List listData=new List();
  var bannerData;
  var curPage=0;
  var listTotalSize=0;

  BannerView _bannerView;

  ScrollController _controller=new ScrollController();
  TextStyle titleTextStyle = new TextStyle(fontSize: 15.0);
  TextStyle subtitleTextStyle =
  new TextStyle(color: Colors.blue, fontSize: 12.0);

  HomePageState(){
    _controller.addListener((){
      var maxScroll=_controller.position.maxScrollExtent;
      var pix=_controller.position.pixels;

      if(maxScroll==pix && listData.length<listTotalSize){
        getHomeArticleList();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    curPage=0;
    getBannerData();
    getHomeArticleList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

 Future<Null> _pullToRefreshData()async{
    curPage=0;
    getBannerData();
    getHomeArticleList();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(listData==null){

      return new Center(child: new CircularProgressIndicator(),);
    }else{

      Widget listView= new ListView.builder(
        itemCount: listData.length+1,
          controller: _controller,
          itemBuilder: (context,i){
          return buildItem(i);
          });

      return RefreshIndicator(child: listView,onRefresh: _pullToRefreshData,);
    }



  }

  void getBannerData() {

    HttpUtil.get(Api.BANNER, (data){
      if(data!=null){
        setState(() {
          bannerData=data;
          _bannerView=new BannerView(bannerData);
        });
      }
    });
  }

  void getHomeArticleList() {
    String url=Api.ARTICLE_LIST;
    url+="$curPage/json";

    HttpUtil.get(url, (data){
      if(data!=null){
        Map<String,dynamic> map=data;

        var _listData=map['datas'];
        listTotalSize=map['total'];
        setState(() {
          List ll=new List();
          if(curPage==0){
            listData.clear();
          }
          ll.addAll(listData);
          ll.addAll(_listData);
          if(ll.length>=listTotalSize)
          ll.add(Constants.END_LINE_TAG);
          listData=ll;
          curPage++;  //
        });
      }
    });
  }

  Widget buildItem(int pos) {
    if(pos==0){
      return new Container(
        height: 180.0,
        child: _bannerView,
      );
    }

    var itemData=listData[pos-1];
    if(itemData is String && itemData==Constants.END_LINE_TAG){
      return EndLine();
    }
    return ArticleItem(itemData);
  }
}