import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_up/controller/profile_controller.dart';
import 'package:hire_up/screens/B/ai_log_screen.dart';
import 'package:hire_up/screens/C/resume_screen.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/utils.dart';
import 'package:hire_up/utils/widget.dart' show showLoginBottomSheet, toPage;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final void Function(int)? onTabChange;

  const ProfileScreen({super.key, this.onTabChange});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = ProfileController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => isLoading = true);
    await controller.loadProfile();
    if (isLogin) await controller.getProfile();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        leading: null,
        title: Text(
          "프로필",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : !isLogin
          ? noLogin()
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  userInfo(),
                  SizedBox(height: 20),
                  logSession(),
                  SizedBox(height: 20),
                  buttons(),
                  SizedBox(height: 20),
                  logout(),
                  SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget noLogin() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Color(0xfff7f8fa),
            shape: BoxShape.circle,
          ),
          child: Icon(CupertinoIcons.person, color: subText, size: 50),
        ),
        SizedBox(height: 20),
        Text(
          "로그인이 필요합니다.",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "로그인 후 프로필을 확인할 수 있어요.",
          style: TextStyle(
            color: subText,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 24),
        GestureDetector(
          onTap: () async {
            await showLoginBottomSheet(context);
            _load();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 60),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "로그인",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(width: MediaQuery.widthOf(context), height: 40),
      ],
    );
  }

  Widget userInfo() {
    final user = controller.user;
    return Column(
      children: [
        GestureDetector(
          onTap: _showImageOptions,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Color(0xffECECEC),
              shape: BoxShape.circle,
            ),
            child: controller.profilePath != null
                ? ClipOval(
                    child: Image.file(
                      controller.profilePath as File,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.camera_alt_outlined, color: subText, size: 30),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user?.name ?? '',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "회원님",
                style: TextStyle(
                  color: mainColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          user?.email ?? '',
          style: TextStyle(color: titleText, fontSize: 14),
        ),
        if ((user?.intro ?? '').isNotEmpty) ...[
          SizedBox(height: 4),
          Text(
            user!.intro,
            style: TextStyle(color: subText, fontSize: 13),
          ),
        ],
      ],
    );
  }

  Widget logSession() {
    final stats = controller.stats;
    if (stats == null) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _statItem(
            icon: CupertinoIcons.bookmark,
            label: "관심공고",
            count: stats.bookmarkCount,
          ),
          Container(width: 1, height: 40, color: Color(0xffECECEC)),
          _statItem(
            icon: CupertinoIcons.mic,
            label: "면접",
            count: stats.interviewCount,
          ),
          Container(width: 1, height: 40, color: Color(0xffECECEC)),
          _statItem(
            icon: Icons.description_outlined,
            label: "이력서",
            count: stats.resumeCount,
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required String label,
    required int count,
    required IconData? icon,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: mainColor,
          ),
          SizedBox(height: 6),
          Text(
            "$count",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: subText, fontSize: 13)),
        ],
      ),
    );
  }

  Widget buttons() {
    final menus = [
      {
        'icon': Icons.description_outlined,
        'label': '이력서 관리',
        'onTap': () => toPage(context, ResumeScreen()),
      },
      {
        'icon': Icons.mic_none_outlined,
        'label': 'AI 면접 기록',
        'onTap': () => toPage(context, AiLogScreen()),
      },
      {
        'icon': Icons.headset_mic_outlined,
        'label': '고객센터',
        'onTap': () async {
          final uri = Uri.parse('http://support.hireup.com');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      },
      {
        'icon': Icons.info_outline,
        'label': '앱 정보',
        'onTap': () => showMessage("아직 준비 중입니다."),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: menus
            .map(
              (menu) => ListTile(
                leading: Icon(menu['icon'] as IconData, color: titleText),
                title: Text(
                  menu['label'] as String,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: subText,
                ),
                onTap: menu['onTap'] as void Function(),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget logout() {
    return GestureDetector(
      onTap: () async {
        final pref = await SharedPreferences.getInstance();
        await pref.remove('token');
        await pref.remove('userName');
        await pref.remove('userId');
        tkn = '';
        userName.value = '게스트';
        userId = 0;
        showMessage("로그아웃 되었습니다.");
        _load();
      },
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          "로그아웃",
          style: TextStyle(
            color: mainColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xffE7E7E7),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          ListTile(
            leading: Icon(Icons.camera_alt_outlined),
            title: Text("카메라로 촬영"),
            onTap: () async {
              Navigator.pop(context);
              await controller.pickImage(ImageSource.camera);
              setState(() {});
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library_outlined),
            title: Text("갤러리에서 선택"),
            onTap: () async {
              Navigator.pop(context);
              await controller.pickImage(ImageSource.gallery);
              setState(() {});
            },
          ),
          if (controller.profilePath != null)
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                "프로필 사진 삭제",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                Navigator.pop(context);
                await controller.removeImage();
                setState(() {});
              },
            ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
