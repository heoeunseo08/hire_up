import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hire_up/controller/job_controller.dart';
import 'package:hire_up/controller/search_keyword_controller.dart';
import 'package:hire_up/screens/B/post_detail_screen.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/utils.dart';
import 'package:hire_up/utils/widget.dart' show inputBorder;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();
  SearchKeywordController keywordController = SearchKeywordController();
  JobController jobController = JobController();

  bool isSelected = true;
  Timer? delay;

  @override
  void dispose() {
    delay?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadPopularKeyword();
    keywordController.loadRecentKeywords();
  }

  Future<void> loadPopularKeyword() async {
    await keywordController.getKeywords();
    setState(() {});
  }

  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      setState(() => isSelected = true);
      return;
    }
    await keywordController.addRentKeywords(keyword);
    jobController.keyword = keyword;
    await jobController.jobs();
    setState(() => isSelected = false);
  }

  void clearPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("전체 삭제"),
        content: Text("모든 최근 검색어를 삭제하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("취소"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              keywordController.clearRecentKeyword();
              showMessage("최근 검색어를 모두 삭제했습니다.");
              setState(() {});
            },
            child: Text("삭제"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          appBar(),
          if (isSelected)
            Column(
              children: [
                SizedBox(height: 50),
                recentWidget(),
                SizedBox(height: 40),
                popularWidget(),
              ],
            )
          else
            jobController.model.isEmpty
                ? Expanded(child: noResultWidget())
                : searchList(),
        ],
      ),
    );
  }

  Widget searchList() {
    return Expanded(
      child: ListView.builder(
        itemCount: jobController.model.length,

        itemBuilder: (context, index) {
          final job = jobController.model[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        job.companyLogo,
                        height: 55,
                      ),
                    ),

                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            job.companyName,
                            style: TextStyle(
                              color: titleText,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                job.jobTitle,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: subText,
                                size: 20,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "${job.location}·${job.employmentType}",
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget popularWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "인기 검색어",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,

          runSpacing: 8,
          children: keywordController.popularKeywords
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    controller.text = e;
                    search(e);
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: Color(0xffECECEC)),
                    ),
                    child: Text(
                      e,
                      style: TextStyle(
                        color: titleText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget recentWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "최근 검색어",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () => clearPopup(),
                child: Text(
                  "전체 삭제",
                  style: TextStyle(
                    color: titleText,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,

          runSpacing: 8,
          children: keywordController.recentKeywords
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    controller.text = e;
                    search(e);
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: Color(0xffECECEC)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          e,
                          style: TextStyle(
                            color: titleText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            keywordController.removeRecentKeyword(e);
                            setState(() {});
                          },
                          child: Icon(
                            Icons.close_outlined,
                            color: subText,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget noResultWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_rounded,
          color: subText,
          size: 70,
          weight: 1000,
        ),
        SizedBox(height: 10),
        Text(
          "검색 결과가 없습니다",
          style: TextStyle(
            color: titleText,
            fontWeight: FontWeight.w400,
            fontSize: 19,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "다른 키워드로 검색해보세요",
          style: TextStyle(color: subText, fontSize: 14),
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  appBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios_new_outlined, size: 20),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              onChanged: (value) {
                delay?.cancel();
                delay = Timer(
                  Duration(seconds: 1),
                  () => search(value),
                );
                setState(() {});
              },
              decoration: InputDecoration(
                border: inputBorder(Color(0xffE9E7E8)),
                disabledBorder: inputBorder(Color(0xffE9E7E8)),
                enabledBorder: inputBorder(Color(0xffE9E7E8)),
                focusedBorder: inputBorder(mainColor),
                fillColor: Color(0xffF7F8FA),
                filled: true,

                prefixIcon: Icon(
                  Icons.search,
                  color: subText,
                  size: 25,
                ),

                suffixIcon: controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          controller.clear();
                          jobController.model = [];
                          setState(() => isSelected = true);
                        },
                        child: Icon(
                          Icons.close,
                          size: 25,
                          color: subText,
                        ),
                      )
                    : null,

                hint: Text(
                  "직무, 회사, 키워드 검색",
                  style: TextStyle(
                    color: subText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                focusColor: mainColor,
              ),
              cursorColor: mainColor,
            ),
          ),
        ],
      ),
    );
  }

}
