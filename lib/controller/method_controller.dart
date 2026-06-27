import 'package:flutter/services.dart';

class MethodController {
  static const MethodChannel smsChannel = MethodChannel('sms');

  Future<void> checkPermission() async {
    await smsChannel.invokeMethod('checkPermission');
  }
  
  Future<void> share(String text) async {
    await smsChannel.invokeMethod('share',{
      'text' : text
    });
  }
}
