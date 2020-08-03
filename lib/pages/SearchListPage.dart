import 'package:flutter/material.dart';
import 'package:woandroid/constant/Costants.dart';
import 'package:woandroid/pages/BaseState.dart';
import 'package:woandroid/http/Api.dart';
import 'package:woandroid/http/HttpUtilWithCookie.dart';
import 'package:woandroid/view/EndLine.dart';
import 'package:woandroid/itemView/ArticleItem.dart';

class SearchListPage extends StatefulWidget{
  String id;
  SearchListPage(ValueKey<String> key) : super(key: key) {

    this.id = key.value.toString();
    print("构造----"+id+TimeOfDay.now().toString()+this.hashCode.toString());
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print("createState----"+TimeOfDay.now().toString());
     return new SearchListPageState();
  }

}

class SearchListPageState extends BaseState<SearchListPage>
{

  int curPage=0;
  Map<String,String> map=Map();
  List listData=List();

  int listTotalSize=0;
  ScrollController _controller=ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(listData==null||listData.isEmpty){
      return Center(child: new  CircularProgressIndicator(),);
    }else{
      Widget listviw =ListView.builder(
          itemCount: listData.length,
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller,
          itemBuilder: (content,i)=>buildItem(i));
       return RefreshIndicator(child: listviw,onRefresh: pullToRefresh,);
    }

  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("_articleQuery--initState");

    _controller.addListener(() {
      var maxScroll=_controller.position.maxScrollExtent;
      var pixels=_controller.position.pixels;
      if(maxScroll==pixels&&listData.length<listTotalSize){
        _articleQuery();
      }

    });
    _articleQuery();

  }

  void _articleQuery() {
    print("_articleQuery");

    String url=Api.ARTICLE_QUERY;
    url+="$curPage/json";
    map['k']=widget.id;

    HttpUtil.post(url, (data){
      if(data!=null){
        Map <String ,dynamic> map=data;

        var _listData=map['datas'];
        listTotalSize=map['total'];
        setState(() {
          List list1=List();
          if(curPage==0){
            listData.clear();
          }
          curPage++;
          list1.addAll(listData);
          list1.addAll(_listData);
          if(list1.length>=listTotalSize){
            list1.add(Constants.END_LINE_TAG);
          }
          listData=list1;
        });
      }
    },params: map);
  }
  Widget buildItem(int i) {
     var itemData=listData[i];
     if(i==listData.length-1&&itemData.toString()==Constants.END_LINE_TAG)
      return EndLine();

     return ArticleItem(itemData,widget.id,true);
  }

  Future<Null> pullToRefresh() async {
    curPage=0;
    _articleQuery();
    return null;
  }


}

