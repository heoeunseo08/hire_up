import 'package:flutter/material.dart';

String baseUrl = "http://10.0.2.2:8000";
String userName = "게스트";
String tkn = '';

final GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey();

bool get isLogin => tkn.isNotEmpty;

Color mainColor = Color(0xff3366FF);
Color bgColor = Color(0xffF5F5F7);
Color titleText = Color(0xff666666);
Color subText = Color(0xff999999);

List<Map<String, String?>> categoryText = [
  {'label': '전체', "code": null},
  {'label': '개발', "code": 'DEV'},
  {'label': '디자인', "code": 'DESIGN'},
  {'label': '마케팅', "code": 'MARKETING'},
  {'label': 'HR', "code": 'HR'},
];
