import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hire_up/controller/resume_controller.dart';
import 'package:hire_up/screens/C/resume_edit_screen.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/utils.dart';
import 'package:hire_up/utils/widget.dart' show showLoginBottomSheet;

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final ResumeController controller = ResumeController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => isLoading = true);
    if (isLogin) await controller.getResumes();
    setState(() => isLoading = false);
  }

  Future<void> _openEdit([ResumeController? c]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResumeEditScreen(controller: c ?? ResumeController())),
    );
    _load();
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
          "이력서",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        actions: isLogin
            ? [IconButton(icon: Icon(Icons.add, size: 28), onPressed: () => _openEdit())]
            : null,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : !isLogin
              ? _noLogin()
              : _memberBody(),
    );
  }

  Widget _noLogin() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(color: Color(0xfff7f8fa), shape: BoxShape.circle),
          child: Icon(CupertinoIcons.doc_text, color: subText, size: 40),
        ),
        SizedBox(height: 20),
        Text(
          "로그인이 필요합니다.",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        SizedBox(height: 8),
        Text(
          "로그인 후 이력서를 관리할 수 있어요.",
          style: TextStyle(color: subText, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        SizedBox(height: 24),
        GestureDetector(
          onTap: () async {
            await showLoginBottomSheet(context);
            _load();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 60),
            decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(8)),
            child: Text(
              "로그인",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
        ),
        SizedBox(width: MediaQuery.widthOf(context), height: 40),
      ],
    );
  }

  Widget _memberBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          _banner(),
          SizedBox(height: 24),
          Text(
            "내 이력서",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          SizedBox(height: 16),
          ...controller.items.map((item) => _resumeCard(item)),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _banner() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "나만의 강점을 담은\n이력서를 만들어보세요",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 6),
                Text(
                  "체계적인 이력서 작성으로 합격률을 높여보세요",
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _openEdit(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "+ 이력서 작성하기",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.description_outlined, color: Colors.white, size: 36),
          ),
        ],
      ),
    );
  }

  Widget _resumeCard(ResumeItem item) {
    return GestureDetector(
      onTap: () => _openEdit(ResumeController()..loadFromItem(item)),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.description_outlined, color: mainColor, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "최종 수정 ${item.formattedDate}",
                    style: TextStyle(color: subText, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: item.skills.take(3).map((s) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
                      child: Text(s, style: TextStyle(color: titleText, fontSize: 12)),
                    )).toList(),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _moreSheet(item),
              child: Icon(Icons.more_horiz, color: subText),
            ),
          ],
        ),
      ),
    );
  }

  void _moreSheet(ResumeItem item) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Color(0xffE7E7E7), borderRadius: BorderRadius.circular(99)),
          ),
          ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text("수정"),
            onTap: () async {
              Navigator.pop(context);
              await _openEdit(ResumeController()..loadFromItem(item));
            },
          ),
          ListTile(
            leading: Icon(Icons.copy_outlined),
            title: Text("복제"),
            onTap: () async {
              Navigator.pop(context);
              final ok = await controller.duplicateResume(item.id);
              if (ok) {
                showMessage("이력서를 복제했습니다.");
                _load();
              } else {
                showMessage(controller.error ?? "복제에 실패했습니다.");
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red),
            title: Text("삭제", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _deleteDialog(item);
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  void _deleteDialog(ResumeItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("이력서 삭제"),
        content: Text("'${item.title}' 이력서를 삭제하시겠습니까?\n삭제된 이력서는 복구할 수 없습니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("취소", style: TextStyle(color: subText)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final ok = await controller.deleteResume(item.id);
              if (ok) {
                showMessage("이력서를 삭제했습니다.");
                _load();
              } else {
                showMessage(controller.error ?? "삭제에 실패했습니다.");
              }
            },
            child: Text("삭제", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
