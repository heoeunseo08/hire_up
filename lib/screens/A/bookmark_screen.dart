import 'package:flutter/material.dart';
import 'package:hire_up/controller/job_controller.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/utils.dart';
import 'package:hire_up/utils/widget.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  JobController controller = JobController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          _appBar(),
          isLogin ? _bookmarkList() : Expanded(child: _noLogin()),
        ],
      ),
    );
  }

  Widget _bookmarkList() {
    final bookmarkJobs = controller.model
        .where((job) => controller.isBookmark(job.id))
        .toList();

    if (bookmarkJobs.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "관심 공고가 없습니다.",
            style: TextStyle(color: subColor, fontSize: 16),
          ),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 14),
          itemCount: bookmarkJobs.length,
          itemBuilder: (context, index) {
            final job = bookmarkJobs[index];
            return Dismissible(
              key: ValueKey(job.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) async {
                await controller.removeBookmark(job.id);
                setState(() {});
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: jobCard(
                context: context,
                job: job,
                controller: controller,
                onBookmarkChanged: () async {
                  await controller.removeBookmark(job.id);
                  setState(() {});
                },
                onTap: () => showMessage("공고 상세보기는 아직 준비중입니다."),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _noLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.lock_outlined, size: 60, color: subColor),
            Positioned(
              bottom: 16,
              child: Container(width: 12, height: 12, color: bgColor),
            ),
          ],
        ),
        SizedBox(height: 25),
        Text(
          "로그인이 필요합니다.",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "로그인 후 관심공고를 확인할 수 있어요.",
          style: TextStyle(
            color: subColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 22),
        GestureDetector(
          onTap: () async {
            await showLoginBottomSheet(context);
            setState(() {});
            await _load();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 68, vertical: 15),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "로그인",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _appBar() {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 25),
          ),
          SizedBox(width: 20),
          Text(
            "관심 공고",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
