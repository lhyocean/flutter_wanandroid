import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlutterUtil{

  static final String KEY_IS_LOGIN='isLogin';
  static final String KEY_USER_NAME='userName';

  static Future saveLoginInfo(String name) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    await sharedPreferences.setBool(KEY_IS_LOGIN, true);
    await sharedPreferences.setString(KEY_USER_NAME, name);

  }

  static Future clearLoginInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    print('clean');
    return sp.clear();
  }


  static Future<String> getUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(KEY_USER_NAME);
  }


  static Future<bool> isLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool b = sp.getBool(KEY_IS_LOGIN);
    return true == b;
  }



  static  jumpToPage(BuildContext context,Widget widget){
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }



  static showToast(String msg){

    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        textColor: Colors.white
    );
  }


}

class StringUtils {
  // 保存用户登录信息，data中包含了token等信息
  static TextSpan getTextSpan(String text, String key) {
    if (text == null || key == null) {
      return null;
    }

    if (text == null || key == null) {
      return null;
    }

    String splitString1 = "<em class='highlight'>";
    String splitString2 = "</em>";

    String textOrigin =
    text.replaceAll(splitString1, '').replaceAll(splitString2, '');

    TextSpan textSpan = new TextSpan(
        text: key, style: new TextStyle(color: Colors.red));

    List<String> split = textOrigin.split(key);

    List<TextSpan> list = new List<TextSpan>();

    for (int i = 0; i < split.length; i++) {
      list.add(new TextSpan(text: split[i]));
      list.add(textSpan);
    }

    list.removeAt(list.length - 1);

    return new TextSpan(children: list);
  }

  static bool isStringEmpty(String s){
    return s==null||s.length==0;
  }
}