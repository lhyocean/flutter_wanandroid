import 'package:flutter/material.dart';
import 'package:woandroid/pages/BaseState.dart';

class SearchListPage extends StatefulWidget{
  String id;
  SearchListPage(ValueKey<String> key) : super(key: key) {
    this.id = key.value.toString();
  }

  SearchListPageState searchListPageState;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
     return new SearchListPageState ();
  }
}

class SearchListPageState extends BaseState<SearchListPage>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("das");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}