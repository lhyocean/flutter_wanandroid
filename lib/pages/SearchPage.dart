import 'package:flutter/material.dart';
import 'package:woandroid/pages/BaseState.dart';
import 'HotPage.dart';
import 'SearchListPage.dart';

class SearchPage extends StatefulWidget {
  String searchStr;
  SearchPage(this.searchStr);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SearchPageState(searchStr);
  }
}

class SearchPageState extends BaseState<SearchPage> {
  TextEditingController _editingController = new TextEditingController();

  String searchStr;

  SearchPageState(this.searchStr);
  SearchListPage _searchListPage;

  //  控制输入框焦点变化，当点击🔍，输入框失去焦点，从而收起键盘
  FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editingController = new TextEditingController(text: searchStr);
    changeContent();
  }

  @override
  Widget build(BuildContext context) {
    TextField searchField = new TextField(
      autofocus: true,
      focusNode: _contentFocusNode,
      decoration:
          new InputDecoration(border: InputBorder.none,
              hintText: "搜索关键词"
              ,
              hintStyle: TextStyle(
                color: Colors.grey
              )
          ),
      controller: _editingController,
    );

    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: searchField,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _contentFocusNode.unfocus();
              changeContent();
            },
          ),
          IconButton(
            icon: new Icon(Icons.close),
            onPressed: () {
              setState(() {
                _editingController.clear();
              });
            },
          )
        ],
      ),
      body: (_editingController.text==null||_editingController.text.isEmpty)?
      new Center(child: HotPage(),):_searchListPage,
    );
  }

  void changeContent() {
    setState(() {

        _searchListPage=new SearchListPage(new ValueKey(_editingController.text));
    });
  }
}
