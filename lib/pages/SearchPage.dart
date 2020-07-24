import 'package:flutter/material.dart';
import 'package:woandroid/pages/BaseState.dart';

class SearchPage extends StatefulWidget{
  String searchStr;
  SearchPage (this.searchStr);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SearchPageState(searchStr);
  }
}

class SearchPageState extends BaseState<SearchPage> {

  TextEditingController _editingController=new TextEditingController();

  String searchStr;

  SearchPageState(this.searchStr);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editingController = new TextEditingController(text: searchStr);
    changeContent();

  }

  @override
  Widget build(BuildContext context) {
    TextField searchField=new TextField(
      autofocus: true,
      decoration: new InputDecoration(
        border: InputBorder.none,
          hintText: "搜索关键词"
      ),
      controller: _editingController,
    );

    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: searchField,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),onPressed: (){
            changeContent();
          },)
          ,
          IconButton(
            icon: new Icon(Icons.close),
            onPressed: (){
              setState(() {
                _editingController.clear();
              });
            },
          )
        ],
      ),

    );
  }

  void changeContent() {
    setState(() {
      //
    });
  }

}



