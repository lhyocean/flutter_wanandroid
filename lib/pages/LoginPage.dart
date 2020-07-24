import 'package:flutter/material.dart';
import 'package:woandroid/util/FlutterUtil.dart';
import 'package:woandroid/http/HttpUtilWithCookie.dart';
import 'package:woandroid/http/Api.dart';
import 'package:woandroid/constant/Costants.dart';
import 'package:woandroid/event/LoginEvent.dart';
import 'package:woandroid/pages/BaseState.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginPageState();
  }
}
class LoginPageState extends BaseState<LoginPage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  bool isSHowPass=true;
  TextEditingController _nameController = TextEditingController(text: 'oceanll');
  TextEditingController _passwordController =
      TextEditingController(text: 'a123456');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Row headImg = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.account_box,
          color: Theme.of(context).accentColor,
          size: 100,
        )
      ],
    );

    TextField name = TextField(
      autofocus: true,
      decoration: new InputDecoration(
          labelText: '用户名',
          icon: new Icon(Icons.account_box,size: 24,color: Colors.blue,),
      ),
      controller: _nameController,
    );
    TextField pass = TextField(
      obscureText: isSHowPass,
      decoration: new InputDecoration(
          labelText: '密码',
          icon: Icon(Icons.vpn_key, color: Colors.blue, size: 24,),
          suffixIcon: new IconButton(
              icon: isSHowPass?
                  Icon(Icons.visibility_off,color: Colors.black,)
                  :Icon(Icons.visibility, color: Colors.black,),
              onPressed: (){
                _showPassInputType();
              })

      ),
      controller: _passwordController,
    );

    Row loginAndRegister = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, //布局平分
      children: <Widget>[
        new RaisedButton(
            child: Text(
              '登录',
              style: new TextStyle(color: Color(0xffffffff)),
            ),
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            disabledColor: Colors.blue,
            onPressed: () {
              _login();
            }),
        new OutlineButton(
            child: Text(
              '注册',
              style: TextStyle(color: Colors.black),
            ),
            color: Colors.blue,
            disabledTextColor: Colors.blue,

            borderSide: new BorderSide(color: Colors.yellow),
            textColor: Colors.black,
            onPressed: () {
              _register();
            })
      ],
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: new Padding(
        padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            headImg,
            name,
            pass,
            loginAndRegister,
          ],
        ),
      ),
    );
  }

  void _login() {
    String name = _nameController.text;
    String password = _passwordController.text;

    if(StringUtils.isStringEmpty(name)){
      _showMessage('姓名不能为空');
      return;
    }

    if(StringUtils.isStringEmpty(password)){
      _showMessage('密码不能为空');
      return;
    }

    Map<String, String> map = new Map();
    map['username'] = name;
    map['password'] = password;

    HttpUtil.post(
        Api.LOGIN,
            (data) async {
          FlutterUtil.saveLoginInfo(name).then((r) {
            Constants.eventBus.fire(new LoginEvent());
            Navigator.of(context).pop();
          });
        },
        params: map,
        errorCallback: (msg) {
          _showMessage(msg);
        });

  }

  void _register() {
    String name = _nameController.text;
    String password = _passwordController.text;

    if(StringUtils.isStringEmpty(name)){
      _showMessage('姓名不能为空');
      return;
    }

    if(StringUtils.isStringEmpty(password)){
      _showMessage('密码不能为空');
      return;
    }

    Map<String, String> map = new Map();
    map['username'] = name;
    map['password'] = password;
    map['repassword'] = password;

    HttpUtil.post(
        Api.REGISTER,
            (data) async {
          FlutterUtil.saveLoginInfo(name).then((r) {
            Constants.eventBus.fire(new LoginEvent());
            Navigator.of(context).pop();
          });
        },
        params: map,
        errorCallback: (msg) {
          _showMessage(msg);
        });
  }

  void _showMessage(String msg) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text(
      msg,
      style: new TextStyle(color: Colors.red),
    )));
  }

  void _showPassInputType() {
    setState(() {
      isSHowPass=!isSHowPass;
    });
  }
}
