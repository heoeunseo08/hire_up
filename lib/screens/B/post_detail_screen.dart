import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_up/controller/job_controller.dart';
import 'package:hire_up/controller/method_controller.dart';
import 'package:hire_up/model/detail_job_model.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/utils.dart';
import 'package:hire_up/utils/widget.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.id});

  final int id;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen>
    with TickerProviderStateMixin {
  JobController controller = JobController();
  MethodController methodController = MethodController();
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

  Future<void> share() async {
    await methodController.share(
      '[${jobModel!.jobTitle}]\n\n'
      '• 회사: ${jobModel!.companyName}\n'
      '• 위치: ${jobModel!.location}\n'
      '• 급여: ${jobModel!.salary}\n'
      '• 경력: 경력 ${jobModel!.career}년\n'
      '• 고용형태: ${jobModel!.employmentType}\n'
      '• 마감일: ${jobModel!.deadline}\n\n'
      '하이어업 앱에서 더 많은 채용 정보를 확인하세요!\n',
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                appbar(),
                title(),
                tapbar(),
              ],

              body: TabBarView(
                controller: tabController,
                children: [jobInfo(), tacks(), qualifications(), benefits()],
              ),
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 40),
        color: Colors.white,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xffe4e5e7)),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        if (!isLogin) {
                          await showLoginBottomSheet(context);
                        } else {
                          await controller.addBookmark(jobModel!.id);
                        }
                        setState(() {});
                      },
                      child: Icon(
                        controller.isBookmark(jobModel!.id)
                            ? Icons.bookmark
                            : Icons.bookmark_outline_outlined,
                        color: controller.isBookmark(jobModel!.id)
                            ? mainColor
                            : subText,
                        size: 28,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (!isLogin) {
                          await showLoginBottomSheet(context);
                        } else {
                          showMessage("지원하기 기능은 아직 준비 중입니다.");
                        }
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        height: 60,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color(0xffe4e5e7)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.send, color: Colors.white, size: 20),
                            SizedBox(width: 10),
                            Text(
                              "지원하기",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
              onTap: () => share(),
            ),
            SizedBox(width: 15),
            cirButtton(
              icon: CupertinoIcons.bookmark,
              color: titleText,
              onTap: () async {
                if (!isLogin) {
                  await showLoginBottomSheet(context);
                } else {
                  await controller.addBookmark(jobModel!.id);
                }
                setState(() {});
              },
            ),
          ],
        ),
      ],
    ),
  );

  title() {
    if (jobModel == null)
      return SliverToBoxAdapter(child: CircularProgressIndicator());
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        color: bgColor,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                    width: MediaQuery.widthOf(context),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      jobModel!.companyLogo,
                      width: 100,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: dDayColor(jobModel!.recruitStatus),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(
                      jobModel!.recruitStatus == 'OPEN'
                          ? '채용중'
                          : jobModel!.recruitStatus == 'CLOSING'
                          ? "마감임박"
                          : "마감",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    jobModel!.jobTitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => showMessage('아직 준비중입니다.'),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: Color(0xfff3f3f5),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            jobModel!.companyName,
                            style: TextStyle(
                              color: titleText,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: subText,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 90,
                    child: Column(
                      children: [
                        cirButtton(icon: Icons.send, color: mainColor),
                        SizedBox(height: 10),
                        Text(
                          jobModel!.location,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 2, height: 30, color: Color(0xffebebeb)),
                  SizedBox(
                    width: 90,
                    child: Column(
                      children: [
                        cirButtton(
                          icon: CupertinoIcons.briefcase,
                          color: mainColor,
                        ),
                        SizedBox(height: 10),
                        Text(
                          jobModel!.career,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 2, height: 30, color: Color(0xffebebeb)),
                  SizedBox(
                    width: 90,
                    child: Column(
                      children: [
                        cirButtton(
                          icon: Icons.calendar_month,
                          color: mainColor,
                        ),
                        SizedBox(height: 10),
                        Text(
                          jobModel!.salary,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

  tapbar() => SliverAppBar(
    pinned: true,
    primary: false,
    toolbarHeight: 0,
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

  jobInfo() {
    return contentsTab(
      Column(
        children: [
          tabItem(
            icon: Icons.description_outlined,
            titleName: '직무 정보',
            widgets: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xfff5f6f8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                spacing: 12,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.briefcase,
                            color: subText,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "직무",
                            style: TextStyle(
                              color: subText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          jobModel!.jobTitle,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: subText,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "고용형태",
                            style: TextStyle(
                              color: subText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          jobModel!.employmentType,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.calendar,
                            color: subText,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "마감일",
                            style: TextStyle(
                              color: subText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          jobModel!.deadline,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          tabItem(
            icon: Icons.info_outline,
            titleName: '포지션 소개',
            widgets: Text(
              jobModel!.positionIntro,
              style: TextStyle(
                color: subText,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  tacks() {
    return contentsTab(
      tabItem(
        icon: CupertinoIcons.briefcase,
        titleName: "주요 업무",
        widgets: Column(
          spacing: 12,
          children: List.generate(
            jobModel!.tasks.length,
            (index) => Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  jobModel!.tasks[index],
                  style: TextStyle(color: titleText, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  qualifications() {
    return contentsTab(
      tabItem(
        icon: CupertinoIcons.check_mark_circled,
        titleName: "자격 요건",
        widgets: Column(
          spacing: 12,
          children: List.generate(
            jobModel!.qualifications.length,
            (index) => Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(0xff25be8c).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.check_mark,
                    color: Color(0xff25be8c),
                    size: 15,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  jobModel!.qualifications[index],
                  style: TextStyle(color: titleText, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  benefits() {
    return contentsTab(
      tabItem(
        icon: Icons.star_border_outlined,
        titleName: "복리 후생",
        widgets: Wrap(
          runSpacing: 12,
          spacing: 12,
          children: List.generate(
            jobModel!.benefits.length,
            (index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: mainColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: mainColor, size: 20),
                  SizedBox(width: 10),
                  Text(
                    jobModel!.benefits[index],
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contentsTab(Widget item) {
    return Container(
      color: Color(0xfff3f3f5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: item,
        ),
      ),
    );
  }

  Widget tabItem({
    required IconData icon,
    required String titleName,
    required Widget widgets,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  icon,
                  color: mainColor,
                  size: 22,
                ),
              ),
            ),
            SizedBox(width: 15),
            Text(
              titleName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        widgets,
      ],
    );
  }

  cirButtton({
    required IconData icon,
    required Color color,
    GestureTapCallback? onTap,
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
