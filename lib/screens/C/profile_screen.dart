import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_up/controller/profile_controller.dart';
import 'package:hire_up/screens/B/ai_log_screen.dart';
import 'package:hire_up/screens/C/resume_screen.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = ProfileController();

  @override
  void initState() {
    super.initState();
    if (isLogin) _load();
  }

  Future<void> _load() async {
    await _controller.load();
    if (mounted) setState(() {});
  }

  Future<void> _onProfileImageTap() async {
    final hasImage = _controller.profileImagePath != null;
    final options = [
      '카메라로 촬영',
      '갤러리에서 선택',
      if (hasImage) '프로필 사진 삭제',
    ];

    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map((opt) => ListTile(
                    title: Text(opt,
                        style: TextStyle(
                            color: opt == '프로필 사진 삭제'
                                ? Colors.red
                                : Colors.black)),
                    onTap: () => Navigator.pop(context, opt),
                  ))
              .toList(),
        ),
      ),
    );

    if (picked == null || !mounted) return;

    if (picked == '프로필 사진 삭제') {
      await _controller.deleteProfileImage();
      setState(() {});
      return;
    }

    final source =
        picked == '카메라로 촬영' ? ImageSource.camera : ImageSource.gallery;
    final file = await ImagePicker().pickImage(source: source);
    if (file == null) return;

    await _controller.saveProfileImage(file.path);
    setState(() {});
  }

  Future<void> _onLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('확인', style: TextStyle(color: mainColor))),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    tkn = '';
    userName.value = '게스트';
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('로그아웃 되었습니다')));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: const Text('프로필',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: !isLogin
          ? noLogin(
              context: context,
              isProfile: true,
              onLoginTap: () async {
                await showLoginBottomSheet(context);
                if (isLogin) await _load();
                if (mounted) setState(() {});
              },
            )
          : _controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _body(),
    );
  }

  Widget _body() {
    final user = _controller.user;
    final stats = _controller.stats;
    if (user == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          _profileHeader(user.name, user.email, user.intro),
          const SizedBox(height: 20),
          if (stats != null)
            _statsCard(
                stats.bookmarkCount, stats.interviewCount, stats.resumeCount),
          const SizedBox(height: 16),
          _menuCard(),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _onLogout,
            child: Text('로그아웃',
                style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _profileHeader(String name, String email, String intro) {
    final imagePath = _controller.profileImagePath;
    return Column(
      children: [
        GestureDetector(
          onTap: _onProfileImageTap,
          child: CircleAvatar(
            radius: 44,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                imagePath != null ? FileImage(File(imagePath)) : null,
            child: imagePath == null
                ? Icon(CupertinoIcons.person,
                    size: 44, color: Colors.grey[400])
                : null,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text('회원님',
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(email, style: TextStyle(color: subColor, fontSize: 13)),
        const SizedBox(height: 4),
        Text(intro, style: TextStyle(color: subColor, fontSize: 13)),
      ],
    );
  }

  Widget _statsCard(int bookmark, int interview, int resume) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          _statItem(Icons.bookmark_outline, bookmark, '관심 공고'),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          _statItem(Icons.mic_none, interview, '면접'),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          _statItem(Icons.description_outlined, resume, '이력서'),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, int count, String label) => Expanded(
        child: Column(
          children: [
            Icon(icon, color: mainColor, size: 24),
            const SizedBox(height: 6),
            Text('$count',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: subColor, fontSize: 12)),
          ],
        ),
      );

  Widget _menuCard() {
    final menus = [
      {'icon': Icons.description_outlined, 'label': '이력서 관리'},
      {'icon': Icons.mic_none, 'label': 'AI 면접 기록'},
      {'icon': Icons.headset_mic_outlined, 'label': '고객센터'},
      {'icon': Icons.info_outline, 'label': '앱 정보'},
    ];

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: menus.asMap().entries.map((entry) {
          final i = entry.key;
          final m = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Icon(m['icon'] as IconData, color: subColor),
                title: Text(m['label'] as String,
                    style: const TextStyle(fontSize: 15)),
                trailing:
                    Icon(Icons.arrow_forward_ios, size: 14, color: subColor),
                onTap: () => _onMenuTap(m['label'] as String),
              ),
              if (i < menus.length - 1)
                Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _onMenuTap(String label) async {
    switch (label) {
      case '이력서 관리':
        await toPage(context, const ResumeScreen());
        break;
      case 'AI 면접 기록':
        await toPage(context, const AiLogScreen());
        break;
      case '고객센터':
        final uri = Uri.parse('http://support.hireup.com');
        if (await canLaunchUrl(uri)) launchUrl(uri);
        break;
      case '앱 정보':
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('준비 중입니다.')));
        }
        break;
    }
  }
}
