import 'package:flutter/material.dart';
import 'package:woandroid/http/HttpUtilWithCookie.dart';
import 'package:woandroid/http/Api.dart';
import 'package:woandroid/util/FlutterUtil.dart';
import 'package:woandroid/pages/BaseState.dart';
import 'package:woandroid/pages/ArticlesPage.dart';



class FavoritePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new FavoritePageState();
  }
}
class FavoritePageState extends BaseState<FavoritePage>{

  List listData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData();
    
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(listData==null){
      return new Center(child: Text('没有数据'),);
    }else{
      Widget lv=ListView.builder(
          itemCount: listData.length,
          itemBuilder: (context,d){
         return buildItem(d);
      });
      return lv;
    }
  }

  void _getData()async {

    HttpUtil.get(Api.TREE, (data){
      setState(() {
        listData=data;
      });
    });
  }

  Widget buildItem(int pos) {
    var itemDate=listData[pos];

    Text name=new Text(
      itemDate['name'],
      softWrap: true,
      style: new TextStyle(fontSize: 16,
          color: Colors.black),
    );

    List l=itemDate['children'];
    String string='';
    if(l!=null&&l.isNotEmpty){
      for(var v in l){
        string +='${v['name']}  ';
      }
    }

    Text content=Text(string,
      softWrap: true,
      style: new TextStyle(
          color: Colors.indigoAccent,
          fontStyle: FontStyle.italic),
      textAlign: TextAlign.left,
    );

   Card card= Card(
     elevation: 4,
     child: InkWell(
       onTap: (){
        _handleItemClick(itemDate);

       },
       child: new Container(
         padding: EdgeInsets.all(15),
         child: Row(
           children: <Widget>[
             Expanded(child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Container(
                   padding: EdgeInsets.only(bottom: 6),
                   child: name,
                 ),content
               ],

             )),
             Icon(Icons.chevron_right,color: Colors.blue,)
           ],
         ),
       ),
     ),//  水波纹效果的view
   );
   return card;

  }

  void _handleItemClick(itemDate) {
     if(itemDate!=null){
       FlutterUtil.jumpToPage(context, new ArticlesPage(itemDate));
     }
  }
}