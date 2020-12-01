import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';

void MyToast({String msg}) {
  showToast(
    "$msg",
    textPadding: EdgeInsets.all(10),
    backgroundColor: Colors.black54,
    radius: 100.0,
    textAlign: TextAlign.center,
    animationDuration: Duration(seconds: 3),
    textStyle: TextStyle(fontSize: 10.0),
    animationBuilder: Miui10AnimBuilder(),
    dismissOtherToast: true,
    animationCurve:Curves.easeOutCubic
  );
}