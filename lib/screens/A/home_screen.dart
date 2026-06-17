import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hire_up/controller/job_controller.dart';
import 'package:hire_up/screens/A/search_screen.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  JobController controller = JobController();
  int selectIndex = 0;

  List<String> sortTitles = ["최신순", "인기순", "급여순"];

  @override
  void initState() {
    super.initState();
    loadJob();
  }

  Future<void> loadJob() async {
    await controller.jobs();
    log("${controller.category}");
    setState(() {});
  }

  void categoryChanged(int index) {
    selectIndex = index;
    controller.category = categoryText[index]['code'];
    loadJob();
  }

  void sortChanged(String sort) {
    controller.sort = sort;
    loadJob();
  }

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
            SizedBox(height: 20),
            categories(),
            SizedBox(height: 30),
            jobPosts(),
          ],
        ),
      ),
    );
  }

  Widget postUi({
    required String companyLogo,
    required String companyName,
    required String jobTitle,
    required String location,
    required String employmentType,
    required String career,
    required String salary,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(companyLogo, width: 45),
          SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                companyName,
                style: TextStyle(
                  color: titleText,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                jobTitle,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "$location-$employmentType-$career",
                style: TextStyle(
                  color: subText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                salary,
                style: TextStyle(
                  color: mainColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget jobPosts() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "전체 공고",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
            ),
            PopupMenuButton<String>(
              color: Colors.white,
              offset: Offset(-6, 0),
              // 위치 조절 가능
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              iconColor: titleText,
              iconSize: 35,
              itemBuilder: (context) => sortTitles
                  .map(
                    (e) => PopupMenuItem(
                      height: 56,
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onSelected: (val) {
                if (val == '최신순') sortChanged('latest');
                if (val == '인기순') sortChanged('popular');
                if (val == '급여순') sortChanged('salary');
              },

              child: Row(
                children: [
                  Text(
                    controller.sort == 'latest'
                        ? '최신순'
                        : controller.sort == 'popular'
                        ? '인기순'
                        : '급여순',
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ],
        ),
        postUi(
          companyLogo: "assets/images/company/naver.png",
          companyName: "NAVER",
          jobTitle: "Frontend 개발자",
          location: "경기 성남",
          employmentType: "정규직",
          career: "경력 3년",
          salary: "5,000 ~ 7,000만원",
        ),
      ],
    );
  }

  Widget categories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categoryText.length,
          (index) => Padding(
            padding: EdgeInsets.only(right: 10),
            child: tag(
              category: true,
              text: categoryText[index]['label']!,
              isSelect: selectIndex == index,
              onTap: () => setState(() {
                categoryChanged(index);
              }),
            ),
          ),
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
