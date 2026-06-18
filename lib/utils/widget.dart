import 'package:flutter/material.dart';
import 'package:hire_up/screens/A/login_bottom_sheet.dart';
import 'package:hire_up/utils/info.dart';

Future<dynamic> toPage(BuildContext context, Widget page) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

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

void showLoginBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (_) => LoginBottomSheet(),
  );
}
