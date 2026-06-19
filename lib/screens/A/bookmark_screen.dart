import 'package:flutter/material.dart';
import 'package:hire_up/controller/job_controller.dart';
import 'package:hire_up/model/job_model.dart';
import 'package:hire_up/screens/A/home_screen.dart';
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
    loadBookmark();
  }

  Future<void> loadBookmark() async {
    await controller.loadBookmark();
    await controller.jobs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          appBar(),
          isLogin ? bookmarkWidget() : Expanded(child: noLogin()),
        ],
      ),
    );
  }

  Widget bookmarkWidget() {
    final bookmarkJobs = controller.model
        .where((element) => controller.isBookmark(element.id))
        .toList();

    if (bookmarkJobs.isEmpty) {
      return Expanded(
        child: Center(
          child: Text("관심 공고가 없습니다,"),
        ),
      );
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 14),
          itemCount: bookmarkJobs.length,
          itemBuilder: (context, index) => postUi(
            bookmarkJobs[index],
          ),
        ),
      ),
    );
  }

  Widget postUi(JobModel job) {
    return GestureDetector(
      onTap: () => showMessage(context, "공고 상세보기는 아직 준비중입니다."),
      onHorizontalDragEnd: (details) async {
        if (details.primaryVelocity! > 0) {
          await controller.removeBookmark(job.id);
          setState(() {});
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(job.companyLogo, width: 55),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 6,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        job.companyName,
                        style: TextStyle(
                          color: titleText,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        job.deadline,
                        style: TextStyle(
                          color: subText,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    job.jobTitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${job.location} • ${job.employmentType} • ${job.career}",
                        style: TextStyle(
                          color: subText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await controller.removeBookmark(job.id);
                          setState(() {});
                        },
                        child: Icon(
                          controller.isBookmark(job.id)
                              ? Icons.bookmark
                              : Icons.bookmark_outline_outlined,
                          color: controller.isBookmark(job.id)
                              ? mainColor
                              : subText,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    job.salary,
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: .center,
          children: [
            Icon(
              Icons.lock_outlined,
              size: 60,
              color: subText,
            ),
            Positioned(
              bottom: 16,
              child: Container(
                width: 12,
                height: 12,
                color: bgColor,
              ),
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
            color: subText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 22),
        GestureDetector(
          onTap: () {
            showLoginBottomSheet(context);
            setState(() {});
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

  Widget appBar() {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
              setState(() {});
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 25,
            ),
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
