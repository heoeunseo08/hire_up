import 'package:flutter/material.dart';

void showMessage(BuildContext context, String text) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        color: Colors.white,
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Material(
          color: Colors.white,
          child: Text(text),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(
    Duration(milliseconds: 800),
    entry.remove,
  );
}
