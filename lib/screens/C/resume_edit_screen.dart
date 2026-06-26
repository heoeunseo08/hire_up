import 'package:flutter/material.dart';
import 'package:hire_up/controller/resume_controller.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/utils.dart';

class ResumeEditScreen extends StatefulWidget {
  final ResumeController controller;

  const ResumeEditScreen({super.key, required this.controller});

  @override
  State<ResumeEditScreen> createState() => _ResumeEditScreenState();
}

class _ResumeEditScreenState extends State<ResumeEditScreen>
    with SingleTickerProviderStateMixin {
  late ResumeController controller;
  late TabController tabController;

  final _titleCtrl = TextEditingController();
  final _jobRoleCtrl = TextEditingController();
  final _oneLineCtrl = TextEditingController();
  final _introCtrl = TextEditingController();
  final _skillInputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    tabController = TabController(length: 4, vsync: this);
    _titleCtrl.text = controller.title;
    _jobRoleCtrl.text = controller.jobRole;
    _oneLineCtrl.text = controller.oneLineIntro;
    _introCtrl.text = controller.intro;
  }

  @override
  void dispose() {
    tabController.dispose();
    _titleCtrl.dispose();
    _jobRoleCtrl.dispose();
    _oneLineCtrl.dispose();
    _introCtrl.dispose();
    _skillInputCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    controller.title = _titleCtrl.text;
    controller.jobRole = _jobRoleCtrl.text;
    controller.oneLineIntro = _oneLineCtrl.text;
    controller.intro = _introCtrl.text;

    final success = await controller.saveResume();
    if (success) {
      showMessage("이력서가 저장되었습니다.");
      Navigator.pop(context);
    } else {
      showMessage(controller.error ?? '저장에 실패했습니다.');
    }
  }

  OutlineInputBorder _border([Color? color]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color ?? Color(0xffE8E8E8)),
      );

  InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: subText, fontSize: 14),
        fillColor: bgColor,
        filled: true,
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(mainColor),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );

  TextStyle _labelStyle() =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: titleText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "이력서 수정",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              "저장",
              style: TextStyle(
                color: mainColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          labelColor: mainColor,
          unselectedLabelColor: subText,
          indicatorColor: mainColor,
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: "기본 정보"),
            Tab(text: "경력"),
            Tab(text: "프로젝트"),
            Tab(text: "기술 스택"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _basicInfoTab(),
          _careerTab(),
          _projectTab(),
          _skillTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.fromLTRB(14, 12, 14, 30),
        child: GestureDetector(
          onTap: _save,
          child: Container(
            alignment: Alignment.center,
            height: 50,
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "저장하기",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _basicInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _section(
            "프로필",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Color(0xffECECEC),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt_outlined, color: subText, size: 28),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("이름", style: _labelStyle()),
                          SizedBox(height: 6),
                          TextField(controller: _titleCtrl, decoration: _inputDeco("예: 홍길동")),
                          SizedBox(height: 12),
                          Text("직무", style: _labelStyle()),
                          SizedBox(height: 6),
                          TextField(controller: _jobRoleCtrl, decoration: _inputDeco("예: 프론트엔드 개발자")),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text("한 줄 소개", style: _labelStyle()),
                SizedBox(height: 6),
                TextField(
                  controller: _oneLineCtrl,
                  maxLength: 50,
                  onChanged: (_) => setState(() {}),
                  decoration: _inputDeco("예: 사용자 경험을 고민하는 개발자"),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          _section(
            "소개",
            child: TextField(
              controller: _introCtrl,
              maxLength: 300,
              maxLines: 5,
              onChanged: (_) => setState(() {}),
              decoration: _inputDeco("주요 경험, 강점, 목표를 자유롭게 작성해주세요"),
            ),
          ),
          SizedBox(height: 16),
          _section(
            "학력",
            trailing: GestureDetector(
              onTap: _showAddEducationSheet,
              child: Text(
                "+ 추가",
                style: TextStyle(color: mainColor, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            child: Column(
              children: controller.educations.asMap().entries.map((e) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${e.value.schoolName}·${e.value.major}",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            if (e.value.degree.isNotEmpty)
                              Text(
                                "${e.value.degree}·${e.value.startDate} - ${e.value.endDate}",
                                style: TextStyle(color: subText, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => controller.educations.removeAt(e.key)),
                        child: Icon(Icons.delete_outline, color: Colors.red, size: 22),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _careerTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          ...controller.careers.asMap().entries.map((e) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${e.value.companyName}·${e.value.position}",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${e.value.startDate} - ${e.value.isCurrent ? '재직중' : e.value.endDate}",
                          style: TextStyle(color: subText, fontSize: 13),
                        ),
                        if (e.value.description.isNotEmpty) ...[
                          SizedBox(height: 4),
                          Text(e.value.description, style: TextStyle(color: titleText, fontSize: 13)),
                        ],
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => controller.careers.removeAt(e.key)),
                    child: Icon(Icons.delete_outline, color: Colors.red, size: 22),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 12),
          GestureDetector(
            onTap: _showAddCareerSheet,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: mainColor),
              ),
              child: Text("+ 경력 추가", style: TextStyle(color: mainColor, fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _projectTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          ...controller.projects.asMap().entries.map((e) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.value.name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        SizedBox(height: 4),
                        Text(e.value.period, style: TextStyle(color: subText, fontSize: 13)),
                        if (e.value.description.isNotEmpty) ...[
                          SizedBox(height: 4),
                          Text(e.value.description, style: TextStyle(color: titleText, fontSize: 13)),
                        ],
                        if (e.value.techStack.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            children: e.value.techStack.map((t) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
                              child: Text(t, style: TextStyle(color: titleText, fontSize: 12)),
                            )).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => controller.projects.removeAt(e.key)),
                    child: Icon(Icons.delete_outline, color: Colors.red, size: 22),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 12),
          GestureDetector(
            onTap: _showAddProjectSheet,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: mainColor),
              ),
              child: Text("+ 프로젝트 추가", style: TextStyle(color: mainColor, fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skillTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: _section(
        "기술 스택",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _skillInputCtrl,
                    decoration: _inputDeco("기술을 입력하고 추가하세요 (예: Flutter)"),
                    onSubmitted: (_) => _addSkill(),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: _addSkill,
                  child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.skills.map((s) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(s, style: TextStyle(color: mainColor, fontWeight: FontWeight.w600, fontSize: 14)),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => setState(() => controller.skills.remove(s)),
                      child: Icon(Icons.close, size: 16, color: mainColor),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _addSkill() {
    final text = _skillInputCtrl.text.trim();
    if (text.isEmpty) return;
    if (controller.skills.contains(text)) {
      showMessage("이미 추가된 기술입니다.");
      return;
    }
    setState(() {
      controller.skills.add(text);
      _skillInputCtrl.clear();
    });
  }

  void _showAddEducationSheet() {
    final schoolCtrl = TextEditingController();
    final majorCtrl = TextEditingController();
    final degreeCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("학력 추가", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              SizedBox(height: 20),
              Text("학교명", style: _labelStyle()),
              SizedBox(height: 6),
              TextField(controller: schoolCtrl, decoration: _inputDeco("예: 한국대학교")),
              SizedBox(height: 14),
              Text("전공", style: _labelStyle()),
              SizedBox(height: 6),
              TextField(controller: majorCtrl, decoration: _inputDeco("예: 컴퓨터공학과")),
              SizedBox(height: 14),
              Text("학위", style: _labelStyle()),
              SizedBox(height: 6),
              TextField(controller: degreeCtrl, decoration: _inputDeco("예: 학사")),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("입학", style: _labelStyle()),
                        SizedBox(height: 6),
                        TextField(controller: startCtrl, decoration: _inputDeco("YYYY.MM")),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("졸업", style: _labelStyle()),
                        SizedBox(height: 6),
                        TextField(controller: endCtrl, decoration: _inputDeco("YYYY.MM")),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  if (schoolCtrl.text.trim().isEmpty) {
                    showMessage("학교명을 입력해주세요.");
                    return;
                  }
                  setState(() {
                    controller.educations.add(Education(
                      schoolName: schoolCtrl.text.trim(),
                      major: majorCtrl.text.trim(),
                      degree: degreeCtrl.text.trim(),
                      startDate: startCtrl.text.trim(),
                      endDate: endCtrl.text.trim(),
                    ));
                  });
                  Navigator.pop(ctx);
                },
                child: _saveBtn(),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCareerSheet() {
    final companyCtrl = TextEditingController();
    final positionCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    bool isCurrent = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("경력 추가", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: 20),
                Text("회사명", style: _labelStyle()),
                SizedBox(height: 6),
                TextField(controller: companyCtrl, decoration: _inputDeco("예: 테크스타트업")),
                SizedBox(height: 14),
                Text("직책", style: _labelStyle()),
                SizedBox(height: 6),
                TextField(controller: positionCtrl, decoration: _inputDeco("예: 프론트엔드 개발자")),
                SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("입사", style: _labelStyle()),
                          SizedBox(height: 6),
                          TextField(controller: startCtrl, decoration: _inputDeco("YYYY.MM")),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("퇴사", style: _labelStyle()),
                          SizedBox(height: 6),
                          TextField(controller: endCtrl, enabled: !isCurrent, decoration: _inputDeco("YYYY.MM")),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: isCurrent,
                      activeColor: mainColor,
                      onChanged: (v) => setSheet(() => isCurrent = v ?? false),
                    ),
                    Text("재직 중", style: _labelStyle()),
                  ],
                ),
                SizedBox(height: 14),
                Text("담당 업무", style: _labelStyle()),
                SizedBox(height: 6),
                TextField(controller: descCtrl, maxLines: 3, decoration: _inputDeco("주요 업무와 성과를 입력해주세요")),
                SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    if (companyCtrl.text.trim().isEmpty) {
                      showMessage("회사명을 입력해주세요.");
                      return;
                    }
                    setState(() {
                      controller.careers.add(Career(
                        companyName: companyCtrl.text.trim(),
                        position: positionCtrl.text.trim(),
                        startDate: startCtrl.text.trim(),
                        endDate: endCtrl.text.trim(),
                        isCurrent: isCurrent,
                        description: descCtrl.text.trim(),
                      ));
                    });
                    Navigator.pop(ctx);
                  },
                  child: _saveBtn(),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddProjectSheet() {
    final nameCtrl = TextEditingController();
    final periodCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final techCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("프로젝트 추가", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              SizedBox(height: 20),
              Text("프로젝트명", style: _labelStyle()),
              SizedBox(height: 6),
              TextField(controller: nameCtrl, decoration: _inputDeco("예: HireUp 채용 플랫폼")),
              SizedBox(height: 14),
              Text("기간", style: _labelStyle()),
              SizedBox(height: 6),
              TextField(controller: periodCtrl, decoration: _inputDeco("예: 2024.01 - 2024.06")),
              SizedBox(height: 14),
              Text("설명", style: _labelStyle()),
              SizedBox(height: 6),
              TextField(controller: descCtrl, maxLines: 3, decoration: _inputDeco("프로젝트 내용과 본인의 역할을 입력해주세요")),
              SizedBox(height: 14),
              Text("사용 기술", style: _labelStyle()),
              SizedBox(height: 6),
              TextField(controller: techCtrl, decoration: _inputDeco("쉼표로 구분 (예: Flutter, Dart)")),
              SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  if (nameCtrl.text.trim().isEmpty) {
                    showMessage("프로젝트명을 입력해주세요.");
                    return;
                  }
                  final techStack = techCtrl.text
                      .split(',')
                      .map((t) => t.trim())
                      .where((t) => t.isNotEmpty)
                      .toList();
                  setState(() {
                    controller.projects.add(Project(
                      name: nameCtrl.text.trim(),
                      period: periodCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      techStack: techStack,
                    ));
                  });
                  Navigator.pop(ctx);
                },
                child: _saveBtn(),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, {required Widget child, Widget? trailing}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
              if (trailing != null) trailing,
            ],
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _saveBtn() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(12)),
      child: Text("저장", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }
}
