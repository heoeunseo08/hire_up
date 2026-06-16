import 'package:flutter/material.dart';

Future<dynamic> toPage(BuildContext context, Widget page) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}
