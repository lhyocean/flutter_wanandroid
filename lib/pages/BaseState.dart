
import 'package:flutter/material.dart';
import 'package:woandroid/constant/Costants.dart';

//  封装BaseState,当定义页面时state都继承于这个类，这样可以打印所有类名
abstract class BaseState<E extends StatefulWidget> extends State<E>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(Constants.IS_DEBUG)
          print(this.widget);
  }
  
}
