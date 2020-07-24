import 'package:flutter/material.dart';
import 'package:woandroid/util/FlutterUtil.dart';
import 'package:woandroid/constant/Costants.dart';
import 'package:woandroid/event/LoginEvent.dart';
import 'package:woandroid/pages/AboutUsPage.dart';
import 'package:woandroid/pages/LoginPage.dart';
import 'package:woandroid/pages/CollectPage.dart';
import 'package:woandroid/pages/BaseState.dart';


class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MinePageState();
  }
}

class MinePageState extends BaseState<MinePage> {
  String userName;

  gotoPage(BuildContext c, Widget b) {
    Navigator.of(c).push(new MaterialPageRoute(builder: (c) {
      return b;
    }));
  }

  @override
  Widget build(BuildContext context) {

    Widget img = Image.asset(
      Constants.imgPath,
      width: 100,
      height: 100,
    );

    Widget text =
        Align(
            alignment: Alignment.center,
            child: Text(userName == null ? '未登录' : userName,
            style: TextStyle(fontSize: 20, color: Color(0xff333333))),)
         ;

    Widget collectItem = ListTile(
      leading: const Icon(
        Icons.favorite,
        color: Color(0xffff0000),
      ),
      title: Text(
        '我的收藏',
        style: TextStyle(fontSize: 20, color: Color(0xff333333)),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Color(0xff0000ff),
        size: 30,
      ),
      onTap: () async {
        await FlutterUtil.isLogin().then((isLogin) {
          if (isLogin) {
            gotoPage(context, new CollectPage());

          } else {
            gotoPage(context, new LoginPage());
          }
        });
      },
    );
    Widget aboutUS = ListTile(
      leading: const Icon(
        Icons.album,
        color: Color(0xff336f20),
      ),
      title: Text(
        '关于我们',
        style: TextStyle(fontSize: 20, color: Color(0xff333333)),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Color(0xff0000ff),
        size: 30,
      ),
      onTap: () {
        gotoPage(context, new AboutUsPage());
      },
    );

    Widget button = Padding(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
                color: Theme.of(context).accentColor,
                elevation: 3,
                child: Text(
                  userName == null ? "登录" : '退出登录',
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: ()async{
                  await FlutterUtil.isLogin().then((isLogin){
                    if(isLogin){
                      _showDialog();
                    }else{
                      gotoPage(context, new LoginPage());
                    }
                  });
                }),
          )
        ],
      ),
    );

    // TODO: implement build
    return ListView(
      padding: EdgeInsets.only(top: 10),
      children: <Widget>[img, text, collectItem, aboutUS, button],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState-----');

    _getName();
    //  注册EventBus,登录成功更新数据
    Constants.eventBus.on<LoginEvent>().listen((e) {
      _getName();
    });
  }

  void _getName() {
    FlutterUtil.getUserName().then((name) {
      setState(() {
        userName = name;
      });
    });
  }

  void _showDialog() {

    print("退出登录");

    showDialog(context: context,
    builder: (_) =>AlertDialog(

        title: new Text("LoginOut"),
        content: new Text("Are you shure you want to loginout?"),
        actions:<Widget>[
          new FlatButton(child:new Text("CANCEL",style: TextStyle(color: Colors.red),), onPressed: (){
            Navigator.of(context).pop();

          },),
          new FlatButton(child:new Text("OK"), onPressed: (){
            Navigator.of(context).pop();
            FlutterUtil.clearLoginInfo();
            setState(() {
              userName=null;
            });
          },)
        ]
    )

    );







  }
}
