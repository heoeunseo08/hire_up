import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_up/controller/job_controller.dart';
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
                  await controller.toggleBookmark(job.id);
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

}
