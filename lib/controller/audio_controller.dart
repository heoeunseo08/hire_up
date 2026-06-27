import 'package:flutter/services.dart';

class AudioController {
  static const MethodChannel _channel = MethodChannel('audio');

  // ── 재생 ──────────────────────────────────────────────────────
  Future<void> start(String url) async {
    await _channel.invokeMethod('start', {'url': url});
  }

  Future<void> play() async {
    await _channel.invokeMethod('play');
  }

  Future<void> stop() async {
    await _channel.invokeMethod('stop');
  }

  Future<void> end() async {
    await _channel.invokeMethod('end');
  }

  Future<int> currentTime() async {
    return await _channel.invokeMethod('currentTime') ?? 0;
  }

  /// 재생 완료 여부 (OnCompletionListener 기반, 읽으면 초기화됨)
  Future<bool> isCompleted() async {
    return await _channel.invokeMethod('isCompleted') ?? false;
  }

  /// 실시간 진폭 (0~128)
  Future<int> getAmplitude() async {
    return await _channel.invokeMethod('getAmplitude') ?? 0;
  }

  // ── 녹음 ──────────────────────────────────────────────────────
  Future<void> recodeStart(String path) async {
    await _channel.invokeMethod('recode_start', {'path': path});
  }

  Future<String?> recodeStop() async {
    return await _channel.invokeMethod('recode_stop');
  }
}
