import 'package:flutter/material.dart';
import 'package:hire_up/screens/A/search_screen.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            titleTexts(),
            SizedBox(height: 12),
            toSearchButton(),
          ],
        ),
      ),
    );
  }

  Widget toSearchButton() {
    return GestureDetector(
      onTap: () => toPage(context, SearchScreen()),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xffF7F8FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xffE7E9E8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.search,
              color: subText,
              weight: 35,
            ),
            SizedBox(width: 16),
            Text(
              "직무, 회사, 키워드 검색",
              style: TextStyle(
                color: subText,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget titleTexts() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "안녕하세요, ",
              style: TextStyle(
                color: subText,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "$userName님!",
              style: TextStyle(
                color: mainColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "새로운 기회",
              style: TextStyle(
                color: mainColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "를 찾아보세요.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Color(0xffF5F5F7),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/simbol/app_icon.png",
            width: 90,
          ),
          Icon(Icons.bookmark_outline_outlined, size: 35),
        ],
      ),
    );
  }
}
