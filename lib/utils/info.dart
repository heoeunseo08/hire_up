import 'package:flutter/material.dart';

String baseUrl = "http://10.0.2.2:8000";
ValueNotifier<String> userName = ValueNotifier("게스트");
String tkn = '';
int userId =  0;

final GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

bool get isLogin => tkn.isNotEmpty;

Color mainColor = Color(0xff3366FF);
Color bgColor = Color(0xffF5F5F7);
Color titleText = Color(0xff666666);
Color subText = Color(0xff999999);

Color dDayColor(String state) {
  if (state == 'OPEN') return Color(0xff3366FF);
  if (state == 'CLOSED') return Color(0xff999999);
  return Color(0xffFF9500);
}

List<Map<String, String?>> categoryText = [
  {'label': '전체', "code": null},
  {'label': '개발', "code": 'DEV'},
  {'label': '디자인', "code": 'DESIGN'},
  {'label': '마케팅', "code": 'MARKETING'},
  {'label': 'HR', "code": 'HR'},
];
