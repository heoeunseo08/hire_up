import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hire_up/controller/audio_controller.dart';
import 'package:hire_up/utils/info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const _jobRoleMap = {
  "프론트엔드 개발자": "FRONTEND",
  "백엔드 개발자": "BACKEND",
  "UI/UX 디자이너": "DESIGN",
  "모바일 앱 개발자": "MOBILE",
  "데이터 분석가": "DATA",
  "기획자/PM": "PM",
};

const _careerMap = {
  "신입": "NEW",
  "주니어": "JUNIOR",
  "미들": "MIDDLE",
  "시니어": "SENIOR",
};

const _typeMap = {
  "일반 면접": "GENERAL",
  "실무 면접": "PRACTICAL",
  "인성 면접": "PERSONALITY",
};

class AiPlayScreen extends StatefulWidget {
  final String job;
  final String age;
  final String type;

  const AiPlayScreen({
    super.key,
    required this.job,
    required this.age,
    required this.type,
  });

  @override
  State<AiPlayScreen> createState() => _AiPlayScreenState();
}

class _AiPlayScreenState extends State<AiPlayScreen> {
  final AudioController _audio = AudioController();
  final Random _random = Random();

  // 질문 데이터
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  int total = 0;
  bool isLoading = true;

  // 오디오 상태
  bool isAnswering = false; // false: 질문 듣는 중 / true: 답변해주세요
  int position = 0; // 현재 재생 위치 (초)

  // 타이머
  int totalSeconds = 0;
  Timer? totalTimer;
  Timer? positionTimer;

  // 파형 + 립싱크
  List<double> waveHeights = List.generate(20, (_) => 0.2);
  int amplitude = 0; // 0~128

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTotalTimer();
    _startRecording();
  }

  @override
  void dispose() {
    totalTimer?.cancel();
    positionTimer?.cancel();
    _audio.end();
    super.dispose();
  }

  // ── 타이머 ───────────────────────────────────────────────────
  void _startTotalTimer() {
    totalTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => totalSeconds++);
    });
  }

  // ── 녹음 시작 ─────────────────────────────────────────────────
  Future<void> _startRecording() async {
    final path =
        '/data/user/0/com.example.hire_up/cache/interview_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _audio.recodeStart(path);
  }

  // ── 질문 로드 ─────────────────────────────────────────────────
  Future<void> _loadQuestions() async {
    try {
      final jobRole = _jobRoleMap[widget.job] ?? 'FRONTEND';
      final career = _careerMap[widget.age] ?? 'NEW';
      final type = _typeMap[widget.type] ?? 'GENERAL';

      final uri = Uri.parse('$baseUrl/interview/questions').replace(
        queryParameters: {
          'jobRole': jobRole,
          'career': career,
          'type': type,
          if (!isLogin) 'userId': '1',
        },
      );

      final res = await http.get(
        uri,
        headers: {
          if (isLogin) 'Authorization': 'Bearer $tkn',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          questions = List<Map<String, dynamic>>.from(
            data['data']['questions'],
          );
          total = data['data']['total'];
          isLoading = false;
        });
        await _playCurrentQuestion();
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // ── 현재 질문 오디오 재생 ──────────────────────────────────────
  Future<void> _playCurrentQuestion() async {
    if (questions.isEmpty) return;
    setState(() {
      isAnswering = false;
      position = 0;
    });
    final audioUrl = questions[currentIndex]['audioUrl'] as String;
    await _audio.start(audioUrl);
    _startPositionTimer();
  }

  // ── 재생 위치 폴링 + 파형 + 완료 감지 ─────────────────────────
  void _startPositionTimer() {
    positionTimer?.cancel();
    positionTimer = Timer.periodic(const Duration(milliseconds: 150), (
      _,
    ) async {
      final ms = await _audio.currentTime();
      final amp = await _audio.getAmplitude();
      final completed = await _audio.isCompleted();

      if (!mounted) return;
      setState(() {
        position = ms ~/ 1000;
        amplitude = amp;

        if (!isAnswering) {
          // 진폭 기반 파형
          waveHeights = List.generate(
            20,
            (i) => amp > 5 ? 0.15 + (amp / 128.0) * _random.nextDouble() : 0.15,
          );
        } else {
          waveHeights = List.generate(20, (_) => 0.15);
        }

        // OnCompletionListener 기반 완료 감지
        if (completed && !isAnswering) {
          isAnswering = true;
          positionTimer?.cancel();
        }
      });
    });
  }

  // ── 다음 질문 ─────────────────────────────────────────────────
  Future<void> _onNext() async {
    positionTimer?.cancel();
    await _audio.end();
    setState(() {
      currentIndex++;
      position = 0;
    });
    await _playCurrentQuestion();
  }

  // ── 기록 저장 ─────────────────────────────────────────────────
  Future<void> _saveLog(String? recordingPath) async {
    final pref = await SharedPreferences.getInstance();
    final logs = pref.getStringList('interview_logs') ?? [];
    final now = DateTime.now();
    final date =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final log = jsonEncode({
      'job': widget.job,
      'age': widget.age,
      'type': widget.type,
      'date': date,
      'duration': totalSeconds,
      'recordingPath': recordingPath ?? '',
    });
    logs.add(log);
    await pref.setStringList('interview_logs', logs);
  }

  // ── 면접 완료 ─────────────────────────────────────────────────
  Future<void> _onComplete() async {
    positionTimer?.cancel();
    totalTimer?.cancel();
    await _audio.end();
    String? path;
    try {
      path = await _audio.recodeStop();
    } catch (_) {}
    await _saveLog(path);
    if (!mounted) return;
    _showCompleteDialog();
  }

  // ── 완료 다이얼로그 ────────────────────────────────────────────
  void _showCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("면접 완료"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("총 ${total}개의 질문에 답변하셨습니다."),
            const SizedBox(height: 8),
            const Text("녹음이 저장되었습니다."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("확인", style: TextStyle(color: mainColor)),
          ),
        ],
      ),
    );
  }

  // ── 종료 다이얼로그 ────────────────────────────────────────────
  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("면접 종료"),
        content: const Text("면접을 종료하시겠습니까? 녹음된 내용은 저장됩니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () async {
              positionTimer?.cancel();
              totalTimer?.cancel();
              await _audio.end();
              String? path;
              try {
                path = await _audio.recodeStop();
              } catch (_) {}
              await _saveLog(path);
              if (!mounted) return;
              Navigator.pop(context); // 종료 다이얼로그 닫기
              _showCompleteDialog();
            },
            child: const Text("종료", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _mouthImage() {
    if (isAnswering || amplitude <= 5)
      return 'assets/images/lv0_mouth_closed.png';
    if (amplitude <= 40) return 'assets/images/lv1_mouth_small.png';
    if (amplitude <= 80) return 'assets/images/lv2_mouth_medium.png';
    return 'assets/images/lv3_mouth_large.png';
  }

  Widget _avatar() {
    return SizedBox(
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/avatar_base.png', height: 130),
          Positioned(
            bottom: 22,
            child: Image.asset(_mouthImage(), width: 38),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── UI ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentIndex];
    final duration = question['duration'] as int;
    final isLast = currentIndex == total - 1;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _header(),
            const SizedBox(height: 20),
            _questionCard(question, duration),
            const Spacer(),
            _nextButton(isLast),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
    backgroundColor: bgColor,
    surfaceTintColor: bgColor,
    leading: Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Image.asset(
        'assets/simbol/logo_vertical.png',
        fit: BoxFit.contain,
      ),
    ),
    title: const Text(
      "AI 모의 면접",
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
    ),
    centerTitle: true,
    actions: [
      TextButton(
        onPressed: _showEndDialog,
        child: const Text(
          "면접 종료",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );

  Widget _header() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "${widget.job} 면접",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Text(
            "질문 ${currentIndex + 1} / $total",
            style: TextStyle(color: subText, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: total > 0 ? (currentIndex + 1) / total : 0,
              backgroundColor: Colors.grey[200],
              color: mainColor,
              borderRadius: BorderRadius.circular(99),
              minHeight: 6,
            ),
          ),
        ],
      ),
    ],
  );

  Widget _questionCard(Map<String, dynamic> question, int duration) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // 아바타 (립싱크)
            _avatar(),
            const SizedBox(height: 16),
            // 상태 텍스트
            Text(
              isAnswering ? "재생 완료" : "면접관 질문 재생 중...",
              style: TextStyle(color: subText, fontSize: 13),
            ),
            const SizedBox(height: 6),
            // 재생 시간
            Text(
              "${_formatTime(position)} / ${_formatTime(duration)}",
              style: TextStyle(color: subText, fontSize: 13),
            ),
            const SizedBox(height: 16),
            // 파형 (전체 너비)
            SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(20, (i) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: 48 * waveHeights[i],
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isAnswering
                            ? Colors.grey[300]
                            : mainColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            // 질문 텍스트
            Text(
              "Q. ${question['questionText']}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // 상태 뱃지
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isAnswering
                    ? Colors.green.withOpacity(0.1)
                    : mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                isAnswering ? "답변해주세요" : "질문 듣는 중",
                style: TextStyle(
                  color: isAnswering ? Colors.green : mainColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _nextButton(bool isLast) => GestureDetector(
    onTap: isLast ? _onComplete : _onNext,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isLast ? "면접 완료" : "다음 질문",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    ),
  );
}
