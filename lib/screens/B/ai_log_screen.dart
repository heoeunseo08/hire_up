import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hire_up/controller/audio_controller.dart';
import 'package:hire_up/utils/info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiLogScreen extends StatefulWidget {
  const AiLogScreen({super.key});

  @override
  State<AiLogScreen> createState() => _AiLogScreenState();
}

class _AiLogScreenState extends State<AiLogScreen> {
  final AudioController _audio = AudioController();

  List<Map<String, dynamic>> logs = [];
  int? playingIndex;
  bool isPlaying = false;
  Timer? positionTimer;
  int position = 0;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  @override
  void dispose() {
    positionTimer?.cancel();
    _audio.end();
    super.dispose();
  }

  Future<void> _loadLogs() async {
    final pref = await SharedPreferences.getInstance();
    final raw = pref.getStringList('interview_logs') ?? [];
    setState(() {
      logs = raw
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList()
          .reversed
          .toList();
    });
  }

  Future<void> _onCardTap(int index) async {
    final path = logs[index]['recordingPath'] as String;

    if (playingIndex == index) {
      if (isPlaying) {
        await _audio.stop();
        setState(() => isPlaying = false);
      } else {
        await _audio.play();
        setState(() => isPlaying = true);
      }
    } else {
      positionTimer?.cancel();
      await _audio.end();
      setState(() {
        playingIndex = index;
        isPlaying = true;
        position = 0;
      });
      await _audio.start(path);
      _startPositionTimer(index);
    }
  }

  void _startPositionTimer(int index) {
    positionTimer?.cancel();
    positionTimer =
        Timer.periodic(const Duration(milliseconds: 500), (_) async {
      final ms = await _audio.currentTime();
      final completed = await _audio.isCompleted();

      if (!mounted) return;
      setState(() => position = ms ~/ 1000);

      if (completed) {
        positionTimer?.cancel();
        setState(() {
          isPlaying = false;
          playingIndex = null;
          position = 0;
        });
        await _audio.end();
      }
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _onBack() async {
    positionTimer?.cancel();
    await _audio.end();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: _onBack,
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          "이전 면접 기록",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: logs.isEmpty ? _emptyView() : _logList(),
    );
  }

  Widget _emptyView() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic_none, size: 60, color: subText),
            const SizedBox(height: 16),
            Text(
              "면접 기록이 없습니다",
              style: TextStyle(
                  color: subText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              "AI 모의 면접을 시작해보세요",
              style: TextStyle(color: subText, fontSize: 14),
            ),
          ],
        ),
      );

  Widget _logList() => ListView.builder(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: logs.length,
        itemBuilder: (_, index) => _logCard(index),
      );

  Widget _logCard(int index) {
    final log = logs[index];
    final isThisPlaying = playingIndex == index && isPlaying;
    final isThisSelected = playingIndex == index;

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isThisSelected
              ? Border.all(color: mainColor, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isThisPlaying ? Icons.pause : Icons.play_arrow,
                color: mainColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log['job'] as String,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _tag(log['age'] as String),
                      const SizedBox(width: 6),
                      _tag(log['type'] as String),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    log['date'] as String,
                    style: TextStyle(color: subText, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isThisSelected
                      ? _formatTime(position)
                      : _formatTime(log['duration'] as int),
                  style: TextStyle(
                    color: isThisSelected ? mainColor : subText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(Icons.mic, color: subText, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: subText,
              fontSize: 11,
              fontWeight: FontWeight.w500),
        ),
      );
}
