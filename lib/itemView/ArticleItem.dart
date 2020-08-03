import 'package:flutter/material.dart';
import 'package:woandroid/http/Api.dart';
import 'package:woandroid/util/FlutterUtil.dart';
import 'package:woandroid/pages/LoginPage.dart';
import 'package:woandroid/http/HttpUtilWithCookie.dart';
import 'package:woandroid/pages/ArticleDetailPage.dart';

class ArticleItem extends StatefulWidget{
  var data;
  bool isSearch=false;
  String id;
  ArticleItem(var itemData,[String id,bool isSearch]){
    this.data=itemData;
    this.isSearch=isSearch==null?false:isSearch;
    this.id=id;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ArticleItemState();
  }
}
class ArticleItemState extends State<ArticleItem>{
  @override
  Widget build(BuildContext context) {

    bool isCollect=this.widget.data['collect'];
    if(isCollect==null){
      isCollect = true;
    }

    Row r1=new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Expanded(child: Row(
          children: <Widget>[
            Text('作者: ',style: TextStyle(color: Colors.black)),
            Text(widget.data['author'],
              style: TextStyle(color: Colors.cyan),)
          ],
        )),
        Text(widget.data['niceDate'],
          style: TextStyle(color: Colors.indigoAccent),)

      ],
    );

    Row title=Row(
      children: <Widget>[
        Expanded(
          child: Text.rich(
            widget.isSearch?StringUtils.getTextSpan(widget.data['title'], widget.id):
            TextSpan(text: widget.data['title']),
          softWrap: true,
           style: TextStyle(fontSize: 15,color: Colors.black),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );

    Row chapterName=new Row(

      children: <Widget>[
        new Expanded(child:
        Text(widget.isSearch?'':widget.data['chapterName'],
         softWrap: true,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 15,color: Colors.deepPurple),
        )),

         IconButton(
           color: isCollect?Colors.red:null,
           icon: isCollect?Icon(Icons.favorite):Icon(Icons.favorite_border),
           onPressed: (){
             _handleItemCollect(widget.data);
         },)

      ],
    );

    Column column = new Column(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: r1,
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
        child: column,
        onTap: () {
          _itemClick(widget.data);
        },
      ),
    );

  }

  void _itemClick(data) {

     FlutterUtil.jumpToPage(context, new ArticleDetailPage(title: data['title'], url: data['link']));
  }

  void _handleItemCollect(data) {
    FlutterUtil.isLogin().then((isLogin){
      if(isLogin){
        _itemCollect(data);
      }else{
        _login();
      }
    });
  }
  void _login() {
    FlutterUtil.jumpToPage(context, new LoginPage());
  }

  void _itemCollect(data) {
    String url;
    if(data['collect']){
      url=Api.UNCOLLECT_ORIGINID;
    }else{
      url=Api.COLLECT;
    }
    url+='${data['id']}/json';
    HttpUtil.post(url, (d){
      setState(() {
        data['collect']=!data['collect'];
        if(data['collect']){
          FlutterUtil.showToast("收藏成功");
        }else{
          FlutterUtil.showToast("取消收藏");
        }
      });
    });

  }
}