import 'package:flutter/material.dart';
import 'package:hire_up/screens/A/home_screen.dart';
import 'package:hire_up/screens/B/ai_screen.dart';
import 'package:hire_up/screens/C/profile_screen.dart';
import 'package:hire_up/screens/C/resume_screen.dart';
import 'package:hire_up/utils/info.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int currentIndex = 0;

  late List<Widget> pageList;

  @override
  void initState() {
    super.initState();
    pageList = [
      HomeScreen(),
      AiScreen(),
      ResumeScreen(),
      ProfileScreen(onTabChange: (index) => setState(() => currentIndex = index)),
    ];
  }

  List<Icon> iconList = [
    Icon(Icons.home),
    Icon(Icons.mic_none),
    Icon(Icons.description_outlined),
    Icon(Icons.person_outlined),
  ];

  List<String> labelList = [
    "홈",
    "AI 면접",
    "이력서",
    "프로필",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffFFFFFF),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: mainColor,
        unselectedItemColor: subText,
        iconSize: 35,
        selectedLabelStyle: style(),
        unselectedLabelStyle: style(),
        onTap: (value) => setState(() => currentIndex = value),
        items: List.generate(
          4,
          (index) => BottomNavigationBarItem(
            icon: iconList[index],
            label: labelList[index],
          ),
        ),
      ),
    );
  }

  TextStyle style() => TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
}
