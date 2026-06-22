import 'package:flutter/services.dart';

class MethodController {
  static const MethodChannel smsChannel = MethodChannel('sms');

  Future<void> checkPermission() async {
    await smsChannel.invokeMethod('checkPermission');
  }
}
