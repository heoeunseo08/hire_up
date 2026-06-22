import 'package:flutter/material.dart';
import 'package:hire_up/utils/info.dart';

void showMessage(String text) {
  final overlay = navigatorKey.currentState?.overlay;
  if (overlay == null) return;
  late OverlayEntry e;
  e = OverlayEntry(
    builder: (_) => Positioned(
      bottom: 0, left: 0, right: 0,
      child: Material(
        child: Container(
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text(text),
        ),
      ),
    ),
  );
  overlay.insert(e);
  Future.delayed(Duration(milliseconds: 800), e.remove);
}
