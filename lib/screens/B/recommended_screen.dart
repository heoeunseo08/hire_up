import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_up/controller/job_controller.dart';
import 'package:hire_up/model/job_model.dart';
import 'package:hire_up/model/recommended_model.dart';
import 'package:hire_up/screens/B/post_detail_screen.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/widget.dart';

class RecommendedScreen extends StatefulWidget {
  const RecommendedScreen({super.key});

  @override
  State<RecommendedScreen> createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  JobController controller = JobController();
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await controller.loadBookmark();
    await controller.recommendedJobs();
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
          controller.isRecommendedLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _bookmarkList(),
        ],
      ),
    );
  }

  Widget _bookmarkList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 14),
          itemCount: controller.recommendedModel.length,
          itemBuilder: (context, index) {
            final job = controller.model[index];
            final recommendedJob = controller.recommendedModel[index];
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
              child: recommendedJobCard(
                context: context,
                job: job,
                recommendedJob: recommendedJob,
                controller: controller,
                onBookmarkChanged: () async {
                  await controller.removeBookmark(job.id);
                  setState(() {});
                },
                onTap: () => toPage(context, PostDetailScreen(id: job.id)),
              ),
            );
          },
        ),
      ),
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
            "오늘의 추천 공고",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          Icon(
            CupertinoIcons.sparkles,
            color: Color(0xfff9d634),
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget recommendedJobCard({
    required BuildContext context,
    required JobModel job,
    required RecommendedModel recommendedJob,
    required JobController controller,
    required VoidCallback onBookmarkChanged,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(recommendedJob.companyLogo, width: 55),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        recommendedJob.companyName,
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
                    recommendedJob.jobTitle,
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
                        "${recommendedJob.location} • ${recommendedJob.employmentType} • ${recommendedJob.career}",
                        style: TextStyle(
                          color: subText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!isLogin) {
                            await showLoginBottomSheet(context);
                          } else {
                            await controller.addBookmark(recommendedJob.id);
                          }
                          onBookmarkChanged();
                        },
                        child: Icon(
                          controller.isBookmark(recommendedJob.id)
                              ? Icons.bookmark
                              : Icons.bookmark_outline_outlined,
                          color: controller.isBookmark(recommendedJob.id)
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
}
