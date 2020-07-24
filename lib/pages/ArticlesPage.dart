import 'package:flutter/material.dart';
import 'package:woandroid/pages/BaseState.dart';

class ArticlesPage extends StatefulWidget{
  var data;
  ArticlesPage(this.data);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ArticlesPageState();
  }
}
class ArticlesPageState extends BaseState<ArticlesPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text('发现文章');
  }
}