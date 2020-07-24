import 'package:flutter/material.dart';
import 'package:woandroid/pages/BaseState.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
class ArticleDetailPage extends StatefulWidget{

  String title;
  String url;


  ArticleDetailPage({
    Key key,
    @required this.title,
    @required this.url,
  }) : super(key: key);



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ArticleDetailPageState();
  }
}
class ArticleDetailPageState extends BaseState<ArticleDetailPage>{
  bool isLoad=true;

  final flutterWebViewPlugin=new FlutterWebviewPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    flutterWebViewPlugin.onStateChanged.listen((state){
      if(state.type==WebViewState.finishLoad){
        setState(() {
          isLoad=false;
        });

      }else if(state.type==WebViewState.startLoad){
        setState(() {
          isLoad=true;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WebviewScaffold(url: widget.url,
    appBar: new AppBar(title: Text(widget.title),
    bottom: new PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: isLoad
            ? new LinearProgressIndicator()
            : new Divider(
          height: 1.0,
          color: Theme.of(context).primaryColor,
        )),

    ),
    withJavascript: true,
    withLocalStorage: true,
    withZoom: true,

    );
  }
}