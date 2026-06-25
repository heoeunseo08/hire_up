import 'package:flutter/material.dart';
import 'package:hire_up/controller/job_controller.dart';
import 'package:hire_up/model/job_model.dart';
import 'package:hire_up/model/recommended_model.dart';
import 'package:hire_up/screens/A/login_bottom_sheet.dart';
import 'package:hire_up/utils/info.dart';

Widget cirButton({
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
      child: Icon(icon, color: color, size: 22),
    ),
  );
}

Future<dynamic> toPage(BuildContext context, Widget page) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

OutlineInputBorder inputBorder(Color color) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: BorderSide(color: color, width: 1.5),
);

Widget tag({
  bool category = false,
  bool isSelect = false,
  required String text,
  GestureTapCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: category ? 28 : 22,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: isSelect ? mainColor : Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelect ? Colors.white : titleText,
        ),
      ),
    ),
  );
}

Future<void> showLoginBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (_) => LoginBottomSheet(),
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
                          await controller.toggleBookmark(recommendedJob.id);
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

Widget jobCard({
  required BuildContext context,
  required JobModel job,
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
            child: Image.network(job.companyLogo, width: 55),
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
                        if (!isLogin) {
                          await showLoginBottomSheet(context);
                        } else {
                          await controller.toggleBookmark(job.id);
                        }
                        onBookmarkChanged();
                      },
                      child: Icon(
                        controller.isBookmark(job.id)
                            ? Icons.bookmark
                            : Icons.bookmark_outline_outlined,
                        color: controller.isBookmark(job.id) ? mainColor : subText,
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
