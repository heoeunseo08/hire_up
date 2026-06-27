import 'package:flutter/material.dart';
import 'package:hire_up/controller/resume_controller.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/widget.dart';

// ── 직무 목록 ──────────────────────────────────────────────────
const _jobRoles = [
  '프론트엔드 개발자',
  '백엔드 개발자',
  'UI/UX 디자이너',
  '모바일 앱 개발자',
  '데이터 분석가',
  '기획자/PM',
];

class ResumeEditScreen extends StatefulWidget {
  final int? id;
  const ResumeEditScreen({super.key, this.id});

  @override
  State<ResumeEditScreen> createState() => _ResumeEditScreenState();
}

class _ResumeEditScreenState extends State<ResumeEditScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final ResumeController _controller = ResumeController();

  // ── 기본정보 ──────────────────────────────────────────────────
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _birthCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _linkCtrl = TextEditingController();
  final _oneLineCtrl = TextEditingController();
  final _introCtrl = TextEditingController();
  String? _selectedJobRole;

  // ── 학력 ──────────────────────────────────────────────────────
  List<Map<String, String>> _educations = [];

  // ── 경력 ──────────────────────────────────────────────────────
  List<Map<String, dynamic>> _careers = [];

  // ── 프로젝트 ──────────────────────────────────────────────────
  List<Map<String, dynamic>> _projects = [];

  // ── 기술스택 ──────────────────────────────────────────────────
  final _skillCtrl = TextEditingController();
  List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _birthCtrl.dispose();
    _locationCtrl.dispose();
    _linkCtrl.dispose();
    _oneLineCtrl.dispose();
    _introCtrl.dispose();
    _skillCtrl.dispose();
    super.dispose();
  }

  // ── 저장 ─────────────────────────────────────────────────────
  Future<void> _save() async {
    final jobRole = _selectedJobRole ?? '';
    final body = {
      'title': jobRole.isNotEmpty ? '$jobRole 이력서' : '이력서',
      'jobRole': jobRole,
      'oneLineIntro': _oneLineCtrl.text,
      'intro': _introCtrl.text,
      'educations': _educations,
      'careers': _careers,
      'projects': _projects,
      'skills': _skills,
    };

    final id = await _controller.save(id: widget.id, body: body);
    if (!mounted) return;

    if (id != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이력서가 저장되었습니다')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.error ?? '저장에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text('이력서 수정',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('저장',
                style: TextStyle(
                    color: mainColor, fontWeight: FontWeight.w600)),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          labelColor: mainColor,
          unselectedLabelColor: subColor,
          indicatorColor: mainColor,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(key: Key('tab_basic'), text: '기본 정보'),
            Tab(key: Key('tab_career'), text: '경력'),
            Tab(key: Key('tab_project'), text: '프로젝트'),
            Tab(key: Key('tab_skill'), text: '기술 스택'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _basicInfoTab(),
          _careerTab(),
          _projectTab(),
          _skillTab(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: GestureDetector(
            key: const Key('save_bottom_btn'),
            onTap: _save,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('저장하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // 기본정보 탭
  // ══════════════════════════════════════════════════════════════
  Widget _basicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _sectionCard('프로필', _profileSection()),
          const SizedBox(height: 12),
          _sectionCard('개인 정보', _personalSection()),
          const SizedBox(height: 12),
          _sectionCard('소개', _introSection()),
          const SizedBox(height: 12),
          _educationSection(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _profileSection() {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('준비 중입니다.'))),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[200]),
                child:
                    Icon(Icons.camera_alt_outlined, color: subColor, size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('이름'),
                  _field(key: const Key('name_field'), ctrl: _nameCtrl, hint: '홍길동'),
                  const SizedBox(height: 10),
                  _label('직무'),
                  _dropdown(),
                  const SizedBox(height: 10),
                  _label('한 줄 소개'),
                  _field(
                    key: const Key('one_line_field'),
                    ctrl: _oneLineCtrl,
                    hint: '한 줄 소개를 입력하세요',
                    maxLength: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _personalSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('이메일'), _field(ctrl: _emailCtrl, hint: 'hong@example.com'),
            ])),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('연락처'), _field(ctrl: _phoneCtrl, hint: '010-0000-0000'),
            ])),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('생년월일'), _field(ctrl: _birthCtrl, hint: 'YYYY.MM.DD'),
            ])),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('위치'), _field(ctrl: _locationCtrl, hint: '서울특별시'),
            ])),
          ],
        ),
        const SizedBox(height: 10),
        _label('링크'),
        _field(ctrl: _linkCtrl, hint: 'https://github.com/...'),
      ],
    );
  }

  Widget _introSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _introCtrl,
          maxLines: 5,
          maxLength: 300,
          decoration: InputDecoration(
            hintText: '자신을 소개해주세요',
            hintStyle: TextStyle(color: subColor, fontSize: 13),
            border: inputBorder(Colors.grey.shade300),
            enabledBorder: inputBorder(Colors.grey.shade300),
            focusedBorder: inputBorder(mainColor),
            counterStyle: TextStyle(color: subColor, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _educationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('학력',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              GestureDetector(
                key: const Key('education_add_btn'),
                onTap: _showAddEducation,
                child: Text('+ 추가',
                    style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ),
            ],
          ),
          ..._educations.asMap().entries.map((e) => _educationCard(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _educationCard(int index, Map<String, String> edu) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${edu['schoolName']} · ${edu['major'] ?? ''}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                if ((edu['degree'] ?? '').isNotEmpty ||
                    (edu['startDate'] ?? '').isNotEmpty)
                  Text(
                      '${edu['degree'] ?? ''} · ${edu['startDate'] ?? ''} - ${edu['endDate'] ?? ''}',
                      style: TextStyle(color: subColor, fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _educations.removeAt(index)),
            child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddEducation() async {
    final schoolCtrl = TextEditingController();
    final majorCtrl = TextEditingController();
    final degreeCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20, right: 20, top: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('학력 추가',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _label('학교명'), _field(key: const Key('school_name_field'), ctrl: schoolCtrl, hint: '예: 한국대학교'),
              const SizedBox(height: 10),
              _label('전공'), _field(key: const Key('major_field'), ctrl: majorCtrl, hint: '예: 컴퓨터공학과'),
              const SizedBox(height: 10),
              _label('학위'), _field(ctrl: degreeCtrl, hint: '예: 학사'),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _label('입학'), _field(ctrl: startCtrl, hint: 'YYYY.MM'),
                ])),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _label('졸업'), _field(ctrl: endCtrl, hint: 'YYYY.MM'),
                ])),
              ]),
              const SizedBox(height: 20),
              GestureDetector(
                key: const Key('education_save_btn'),
                onTap: () {
                  if (schoolCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('학교명을 입력해주세요.')));
                    return;
                  }
                  setState(() => _educations.add({
                        'schoolName': schoolCtrl.text.trim(),
                        'major': majorCtrl.text.trim(),
                        'degree': degreeCtrl.text.trim(),
                        'startDate': startCtrl.text.trim(),
                        'endDate': endCtrl.text.trim(),
                      }));
                  Navigator.pop(ctx);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text('저장',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // 경력 탭
  // ══════════════════════════════════════════════════════════════
  Widget _careerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ..._careers.asMap().entries.map((e) => _careerCard(e.key, e.value)),
          const SizedBox(height: 12),
          GestureDetector(
            key: const Key('career_add_btn'),
            onTap: _showAddCareer,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: mainColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('+ 경력 추가',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: mainColor, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _careerCard(int index, Map<String, dynamic> career) {
    final isCurrent = career['isCurrent'] == true;
    final period = isCurrent
        ? '${career['startDate']} - 재직중'
        : '${career['startDate']} - ${career['endDate']}';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${career['companyName']} · ${career['position'] ?? ''}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(period, style: TextStyle(color: subColor, fontSize: 12)),
                if ((career['description'] ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(career['description'],
                        style: TextStyle(color: subColor, fontSize: 12)),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _careers.removeAt(index)),
            child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddCareer() async {
    final companyCtrl = TextEditingController();
    final positionCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    bool isCurrent = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 20, right: 20, top: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('경력 추가',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                _label('회사명'), _field(key: const Key('company_name_field'), ctrl: companyCtrl, hint: '예: 테크스타트업'),
                const SizedBox(height: 10),
                _label('직책'), _field(key: const Key('position_field'), ctrl: positionCtrl, hint: '예: 프론트엔드 개발자'),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label('입사'), _field(ctrl: startCtrl, hint: 'YYYY.MM'),
                  ])),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label('퇴사'),
                    AbsorbPointer(
                      absorbing: isCurrent,
                      child: _field(
                          ctrl: endCtrl,
                          hint: 'YYYY.MM',
                          enabled: !isCurrent),
                    ),
                  ])),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Checkbox(
                    value: isCurrent,
                    activeColor: mainColor,
                    onChanged: (v) => setModal(() => isCurrent = v ?? false),
                  ),
                  const Text('재직 중'),
                ]),
                _label('담당 업무'),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: '주요 업무와 성과를 입력해주세요',
                    hintStyle: TextStyle(color: subColor, fontSize: 13),
                    border: inputBorder(Colors.grey.shade300),
                    enabledBorder: inputBorder(Colors.grey.shade300),
                    focusedBorder: inputBorder(mainColor),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  key: const Key('career_save_btn'),
                  onTap: () {
                    if (companyCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('회사명을 입력해주세요.')));
                      return;
                    }
                    setState(() => _careers.add({
                          'companyName': companyCtrl.text.trim(),
                          'position': positionCtrl.text.trim(),
                          'startDate': startCtrl.text.trim(),
                          'endDate': endCtrl.text.trim(),
                          'isCurrent': isCurrent,
                          'description': descCtrl.text.trim(),
                        }));
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text('저장',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // 프로젝트 탭
  // ══════════════════════════════════════════════════════════════
  Widget _projectTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ..._projects.asMap().entries.map((e) => _projectCard(e.key, e.value)),
          const SizedBox(height: 12),
          GestureDetector(
            key: const Key('project_add_btn'),
            onTap: _showAddProject,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: mainColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('+ 프로젝트 추가',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: mainColor, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _projectCard(int index, Map<String, dynamic> project) {
    final techStack = (project['techStack'] as List<String>?) ?? [];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project['name'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 4),
                if ((project['period'] ?? '').isNotEmpty)
                  Text(project['period'],
                      style: TextStyle(color: subColor, fontSize: 12)),
                if ((project['description'] ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(project['description'],
                        style: TextStyle(color: subColor, fontSize: 12)),
                  ),
                if (techStack.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Wrap(
                      spacing: 6,
                      children: techStack
                          .map((t) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(t,
                                    style: TextStyle(
                                        fontSize: 11, color: subColor)),
                              ))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _projects.removeAt(index)),
            child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddProject() async {
    final nameCtrl = TextEditingController();
    final periodCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final techCtrl = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20, right: 20, top: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('프로젝트 추가',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _label('프로젝트명'),
              _field(key: const Key('project_name_field'), ctrl: nameCtrl, hint: '예: HireUp 채용 플랫폼'),
              const SizedBox(height: 10),
              _label('기간'),
              _field(ctrl: periodCtrl, hint: '예: 2024.01 - 2024.06'),
              const SizedBox(height: 10),
              _label('설명'),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '프로젝트 내용과 본인의 역할을 입력해주세요',
                  hintStyle: TextStyle(color: subColor, fontSize: 13),
                  border: inputBorder(Colors.grey.shade300),
                  enabledBorder: inputBorder(Colors.grey.shade300),
                  focusedBorder: inputBorder(mainColor),
                ),
              ),
              const SizedBox(height: 10),
              _label('사용 기술'),
              _field(key: const Key('project_tech_field'), ctrl: techCtrl, hint: '쉼표로 구분 (예: Flutter, Dart)'),
              const SizedBox(height: 20),
              GestureDetector(
                key: const Key('project_save_btn'),
                onTap: () {
                  if (nameCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                        content: Text('프로젝트명을 입력해주세요.')));
                    return;
                  }
                  final techStack = techCtrl.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();
                  setState(() => _projects.add({
                        'name': nameCtrl.text.trim(),
                        'period': periodCtrl.text.trim(),
                        'description': descCtrl.text.trim(),
                        'techStack': techStack,
                      }));
                  Navigator.pop(ctx);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text('저장',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // 기술스택 탭
  // ══════════════════════════════════════════════════════════════
  Widget _skillTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('기술 스택',
                style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('skill_field'),
                    controller: _skillCtrl,
                    decoration: InputDecoration(
                      hintText: '기술을 입력하고 추가하세요 (예: ...',
                      hintStyle: TextStyle(color: subColor, fontSize: 13),
                      border: inputBorder(Colors.grey.shade300),
                      enabledBorder: inputBorder(Colors.grey.shade300),
                      focusedBorder: inputBorder(mainColor),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    onSubmitted: (_) => _addSkill(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  key: const Key('skill_add_btn'),
                  onTap: _addSkill,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s,
                                style: TextStyle(
                                    color: mainColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _skills.remove(s)),
                              child: Icon(Icons.close,
                                  size: 14, color: mainColor),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _addSkill() {
    final skill = _skillCtrl.text.trim();
    if (skill.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('기술을 입력해주세요.')));
      return;
    }
    if (_skills.contains(skill)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('이미 추가된 기술입니다.')));
      return;
    }
    setState(() {
      _skills.add(skill);
      _skillCtrl.clear();
    });
  }

  // ══════════════════════════════════════════════════════════════
  // 공통 위젯
  // ══════════════════════════════════════════════════════════════
  Widget _sectionCard(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text,
            style: TextStyle(
                fontSize: 12,
                color: subColor,
                fontWeight: FontWeight.w500)),
      );

  Widget _field({
    Key? key,
    required TextEditingController ctrl,
    String hint = '',
    int? maxLength,
    bool enabled = true,
  }) {
    return TextField(
      key: key,
      controller: ctrl,
      maxLength: maxLength,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: subColor, fontSize: 13),
        border: inputBorder(Colors.grey.shade300),
        enabledBorder: inputBorder(Colors.grey.shade300),
        focusedBorder: inputBorder(mainColor),
        disabledBorder: inputBorder(Colors.grey.shade200),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        counterStyle: TextStyle(color: subColor, fontSize: 11),
      ),
    );
  }

  Widget _dropdown() {
    return DropdownButtonFormField<String>(
      key: const Key('job_role_dropdown'),
      value: _selectedJobRole,
      hint: Text('직무 선택', style: TextStyle(color: subColor, fontSize: 13)),
      decoration: InputDecoration(
        border: inputBorder(Colors.grey.shade300),
        enabledBorder: inputBorder(Colors.grey.shade300),
        focusedBorder: inputBorder(mainColor),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      items: _jobRoles
          .map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 13))))
          .toList(),
      onChanged: (v) => setState(() => _selectedJobRole = v),
    );
  }
}
