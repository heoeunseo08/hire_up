import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hire_up/screens/B/ai_log_screen.dart';
import 'package:hire_up/utils/widget.dart';

import '../../utils/info.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  int jobSelectIndex = 0;
  int ageSelectIndex = 0;
  int typeSelectIndex = 0;

  List<String> jobList = [
    "프론트엔드 개발자",
    "백엔드 개발자",
    "UI/UX 디자이너",
    "모바일 앱 개발자",
    "데이터 분석가",
    "기획자/PM",
  ];
  List<IconData> jobIcons = [
    Icons.code_outlined,
    CupertinoIcons.layers_alt_fill,
    CupertinoIcons.paintbrush,
    Icons.phone_android_rounded,
    CupertinoIcons.chart_bar,
    Icons.lightbulb_outline_rounded,
  ];

  List<String> ageTitles = ["신입", "주니어", "미들", "시니어"];
  List<String> ages = ["0~1년", "2~3년", "4~7년", "8년+"];

  List<String> typeTitles = ['일반 면접', "실무 면접", "인성 면접"];
  List<String> typeSubs = [
    '직무 및 인성 관련 종합 질문',
    '직무 관련 기술 및 경험 질문',
    '인성 가치관, 조직문화 적합성 질문',
  ];
  List<IconData> typeIcons = [
    CupertinoIcons.chat_bubble_2,
    CupertinoIcons.briefcase,
    CupertinoIcons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: appbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleCard(),
              SizedBox(height: 40),
              jobSelect(),
              SizedBox(height: 40),
              ageSelect(),
              SizedBox(height: 40),
              typeSelect(),
              SizedBox(height: 40),
              startButton(),
              SizedBox(height: 20),
              logButton(),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget jobSelect() {
    return selectFrom(
      title: "1. 직무 선택",
      sub: "면접을 준비할 직무를 선택해주세요.",
      widgets: Wrap(
        runSpacing: 10,
        spacing: 12,
        children: List.generate(
          6,
          (index) {
            bool select = jobSelectIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() => jobSelectIndex = index);
              },
              child: Container(
                width: 175,
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: select ? mainColor : subText),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(jobIcons[index], color: select ? mainColor : subText),
                    SizedBox(width: 8),
                    Text(
                      jobList[index],
                      style: TextStyle(
                        color: select ? Colors.black : subText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget ageSelect() {
    return selectFrom(
      title: "2. 연차 선택",
      sub: "본인의 경력 연차를 선택해주세요.",
      widgets: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(4, (index) {
            bool select =
                ageSelectIndex == index; // jobSelectIndex → ageSelectIndex
            return GestureDetector(
              onTap: () => setState(() => ageSelectIndex = index),
              child: Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: select ? mainColor : Colors.white,
                ),
                child: Row(
                  children: [
                    Text(
                      ageTitles[index],
                      style: TextStyle(
                        color: select ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      ages[index],
                      style: TextStyle(
                        color: select ? Colors.white : subText,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget typeSelect() {
    return selectFrom(
      title: "3. 면접 유형 선택",
      of: '(선택)',
      sub: "특정 주제의 면접을 선택하면 더 맞춤형 질문을 제공해요.",
      widgets: GestureDetector(
        onTap: () => typeBottomSheet(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xffe6e6e6)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(typeIcons[typeSelectIndex], color: subText),
                  SizedBox(width: 14),
                  Text(typeTitles[typeSelectIndex]),
                ],
              ),
              Icon(Icons.keyboard_arrow_down_outlined, color: subText),
            ],
          ),
        ),
      ),
    );
  }

  void typeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: .min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: Color(0xffE7E7E7),
                ),
                height: 4,
                width: 40,
              ),
              SizedBox(height: 20),
              Text(
                "면접 유형 선택",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Color(0xffe6e6e6)),
              SizedBox(height: 14),
              Column(
                spacing: 20,
                children: List.generate(
                  3,
                  (index) {
                    bool select = typeSelectIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() => typeSelectIndex = index);
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: mainColor.withOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      typeIcons[index],
                                      color: mainColor,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      typeTitles[index],
                                      style: TextStyle(
                                        color: select ? mainColor : Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      typeSubs[index],
                                      style: TextStyle(
                                        color: subText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            select
                                ? Icon(
                                    CupertinoIcons.check_mark_circled_solid,
                                    color: mainColor,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  Widget selectFrom({
    required String title,
    String? of,
    required String sub,
    required Widget widgets,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            Text(
              of ?? '',
              style: TextStyle(
                color: subText,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          sub,
          style: TextStyle(
            color: subText,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 12),
        widgets,
      ],
    );
  }

  Widget titleCard() {
    return Container(
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "AI와 함께 ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "실전처럼",
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "면접을 준비해보세요",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "직무별 맞춤 질문으로\n실전 감각을 키울 수 있어요.",
                      style: TextStyle(
                        color: subText,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/ai_interviewer.png",
              height: 130,
            ),
          ),
        ],
      ),
    );
  }

  appbar() => AppBar(
    backgroundColor: bgColor,
    surfaceTintColor: bgColor,
    leading: null,
    title: Center(
      child: Text(
        textAlign: TextAlign.center,
        "AI 모의 면접",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 22,
        ),
      ),
    ),
  );

  startButton() => Container(
    padding: EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: mainColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: .center,
      children: [
        Icon(CupertinoIcons.sparkles, color: Colors.white,size: 25),
        Text(
          "면접 시작하기",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );

  logButton()  => GestureDetector(
    onTap: () => toPage(context, AiLogScreen()),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffe6e6e6)),
      ),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Icon(CupertinoIcons.time, color: subText,size: 25),
          SizedBox(width: 10),
          Text(
            "이전 면접 기록 보기",
            style: TextStyle(
              color: subText,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.arrow_forward_ios_rounded, color: subText,size: 25),
        ],
      ),
    ),
  );
}
