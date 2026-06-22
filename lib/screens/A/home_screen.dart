import 'package:flutter/material.dart';
import 'package:hire_up/controller/job_controller.dart';
import 'package:hire_up/screens/A/bookmark_screen.dart';
import 'package:hire_up/screens/A/search_screen.dart';
import 'package:hire_up/screens/B/post_detail_screen.dart';
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

  final Map<String, String> _sortLabels = {
    'latest': '최신순',
    'popular': '인기순',
    'salary': '급여순',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await controller.loadBookmark();
    await controller.jobs();
    setState(() {});
  }

  void _categoryChanged(int index) {
    selectIndex = index;
    controller.category = categoryText[index]['code'];
    _load();
  }

  void _sortChanged(String sort) {
    controller.sort = sort;
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            _titleTexts(),
            SizedBox(height: 12),
            _searchButton(),
            SizedBox(height: 20),
            _categories(),
            SizedBox(height: 30),
            Expanded(child: _jobPosts()),
          ],
        ),
      ),
    );
  }

  Widget _jobPosts() {
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
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              iconColor: titleText,
              iconSize: 35,
              itemBuilder: (context) => _sortLabels.values
                  .map(
                    (label) => PopupMenuItem(
                      height: 56,
                      value: label,
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onSelected: (label) {
                final key = _sortLabels.entries
                    .firstWhere((e) => e.value == label)
                    .key;
                _sortChanged(key);
              },
              child: Row(
                children: [
                  Text(_sortLabels[controller.sort] ?? '최신순'),
                  Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        if (controller.isLoading)
          Expanded(child: Center(child: CircularProgressIndicator()))
        else
          Expanded(
            child: ListView.builder(
              itemCount: controller.model.length,
              itemBuilder: (context, index) {
                final job = controller.model[index];
                return jobCard(
                  context: context,
                  job: job,
                  controller: controller,
                  onBookmarkChanged: () => setState(() {}),
                  onTap: () => toPage(context, PostDetailScreen()),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _categories() {
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
              onTap: () => setState(() => _categoryChanged(index)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchButton() {
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
          children: [
            Icon(Icons.search, color: subText),
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

  Widget _titleTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            ValueListenableBuilder(
              valueListenable: userName,
              builder: (context, value, child) => Text(
                "$value님!",
                style: TextStyle(
                  color: mainColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: bgColor,
      surfaceTintColor: bgColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/simbol/app_icon.png", width: 90),
          GestureDetector(
            onTap: () async {
              await toPage(context, BookmarkScreen());
              await _load();
            },
            child: Icon(Icons.bookmark_outline_outlined, size: 35),
          ),
        ],
      ),
    );
  }
}
