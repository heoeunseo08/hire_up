import 'package:flutter/material.dart';
import 'package:hire_up/controller/resume_controller.dart';
import 'package:hire_up/model/resume_model.dart';
import 'package:hire_up/screens/C/resume_edit_screen.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/widget.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final ResumeController _controller = ResumeController();

  @override
  void initState() {
    super.initState();
    if (isLogin) _load();
  }

  Future<void> _load() async {
    await _controller.load();
    if (mounted) setState(() {});
  }

  Future<void> _createResume() async {
    await toPage(context, const ResumeEditScreen());
    await _load();
  }

  Future<void> _editResume(ResumeModel resume) async {
    await toPage(context, ResumeEditScreen(id: resume.id));
    await _load();
  }

  Future<void> _showMoreOptions(ResumeModel resume) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('수정'),
              onTap: () => Navigator.pop(context, '수정'),
            ),
            ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('대표 이력서로 설정'),
              onTap: () => Navigator.pop(context, '대표'),
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('복제'),
              onTap: () => Navigator.pop(context, '복제'),
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('삭제',
                  style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context, '삭제'),
            ),
          ],
        ),
      ),
    );

    if (action == null || !mounted) return;

    if (action == '수정') {
      await _editResume(resume);
    } else if (action == '삭제') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('이력서 삭제'),
          content: const Text('이력서를 삭제하시겠습니까?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('취소')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('삭제',
                    style: TextStyle(color: Colors.red))),
          ],
        ),
      );
      if (confirm == true) {
        _controller.delete(resume.id);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        title: const Text('이력서',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        actions: isLogin
            ? [
                IconButton(
                  key: const Key('resume_add_btn'),
                  icon: const Icon(Icons.add, color: Colors.black, size: 28),
                  onPressed: _createResume,
                )
              ]
            : null,
      ),
      body: !isLogin
          ? noLogin(
              context: context,
              isProfile: false,
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
    return SingleChildScrollView(
      key: const Key('resume_list_scroll'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _banner(),
          const SizedBox(height: 20),
          const Text('내 이력서',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          if (_controller.resumes.isEmpty)
            _emptyView()
          else
            ..._controller.resumes.map((r) => _resumeCard(r)).toList(),
        ],
      ),
    );
  }

  Widget _banner() {
    return GestureDetector(
      onTap: _createResume,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: mainColor, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('나만의 강점을 담은\n이력서를 만들어보세요',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Text('체계적인 이력서 작성으로 합격률을 높여보세요',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(99)),
                    child: const Text('+ 이력서 작성하기',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ],
              ),
            ),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.description_outlined,
                  color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resumeCard(ResumeModel resume) {
    final date = resume.updatedAt.length >= 10
        ? resume.updatedAt.substring(0, 10).replaceAll('-', '.')
        : resume.updatedAt;
    final displaySkills = resume.skills.take(3).toList();

    return GestureDetector(
      key: Key('resume_card_${resume.id}'),
      onTap: () => _editResume(resume),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.description_outlined,
                  color: mainColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(resume.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('최종 수정 $date',
                      style: TextStyle(color: subColor, fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: displaySkills
                        .map((s) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(s,
                                  style: TextStyle(
                                      fontSize: 11, color: subColor)),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showMoreOptions(resume),
              child: Icon(Icons.more_horiz, color: subColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyView() => Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.description_outlined, size: 60, color: subColor),
              const SizedBox(height: 16),
              Text('이력서가 없습니다',
                  style: TextStyle(
                      color: subColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text('이력서를 작성해보세요',
                  style: TextStyle(color: subColor, fontSize: 14)),
            ],
          ),
        ),
      );
}
