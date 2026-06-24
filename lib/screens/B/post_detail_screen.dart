import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_up/controller/job_controller.dart';
import 'package:hire_up/model/detail_job_model.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/utils.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.id});

  final int id;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen>
    with TickerProviderStateMixin {
  JobController controller = JobController();
  late TabController tabController;
  DetailJobModel? jobModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
    load();
  }

  Future<void> load() async {
    await controller.loadBookmark();
    jobModel = await controller.detailsJob(widget.id);
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          appbar(),
          title(),
          tapbar(),
        ],
        body: Container(),
      ),
    );
  }

  appbar() => SliverAppBar(
    pinned: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        cirButtton(
          icon: Icons.arrow_back_ios_new_outlined,
          color: titleText,
          onTap: () => Navigator.pop(context),
        ),
        Row(
          children: [
            cirButtton(
              icon: Icons.ios_share,
              color: titleText,
              onTap: () => showMessage('text'),
            ),
            SizedBox(width: 15),
            cirButtton(
              icon: CupertinoIcons.bookmark,
              color: titleText,
              onTap: () => showMessage('text'),
            ),
          ],
        ),
      ],
    ),
  );

  title() => SliverToBoxAdapter(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      color: bgColor,
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    jobModel!.companyLogo,
                    width: 100,
                  ),
                ),
              ],
            ),
          ),
          Container(),
        ],
      ),
    ),
  );

  tapbar() => SliverAppBar(
    pinned: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 0,
    bottom: TabBar(
      labelColor: mainColor,
      indicatorColor: mainColor,
      controller: tabController,
      tabs:
          [
                '채용 정보',
                '주요 업무',
                '자격 요건',
                '복리후생',
              ]
              .map(
                (e) => Tab(
                  text: e,
                ),
              )
              .toList(),
    ),
  );

  cirButtton({
    required IconData icon,
    required Color color,
    required GestureTapCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
      ),
    );
  }
}
