import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hire_up/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Module C 통합 테스트 - 21단계', (tester) async {

      // STEP 1 — 애플리케이션 실행
      print('[STEP No.1] 애플리케이션 실행');
      app.main();
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 2 — 하단 네비게이션의 "이력서" 탭 클릭
      print('[STEP No.2] 하단 네비게이션의 "이력서" 탭 클릭');
      await tester.tap(find.byKey(const Key('resume_tab')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 3 — "로그인" 버튼 클릭
      print('[STEP No.3] "로그인" 버튼 클릭');
      await tester.tap(find.byKey(const Key('no_login_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 4 — 정상 값으로 로그인 시도
      print('[STEP No.4] 정상 값으로 로그인 시도');
      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('login_password_field')), 'Test1234!');
      await tester.tap(find.byKey(const Key('login_submit_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 5 — 앱바 추가(+) 버튼 클릭
      print('[STEP No.5] 앱바 추가(+) 버튼 클릭');
      await tester.tap(find.byKey(const Key('resume_add_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 6 — 이름 입력 필드에 이름 입력
      print('[STEP No.6] 이름 입력 필드에 이름 입력');
      await tester.enterText(find.byKey(const Key('name_field')), '홍길동');
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 7 — 직무 드롭다운에서 직무 선택
      print('[STEP No.7] 직무 드롭다운에서 직무 선택');
      await tester.tap(find.byKey(const Key('job_role_dropdown')));
      await tester.pump(const Duration(seconds: 3));
      await tester.tap(find.text('모바일 앱 개발자').last);
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 8 — 한 줄 소개 입력
      print('[STEP No.8] 한 줄 소개 입력');
      await tester.enterText(
          find.byKey(const Key('one_line_field')), '성장하는 개발자입니다');
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 9 — 학력 영역 "추가" 버튼 클릭
      print('[STEP No.9] 학력 영역 "추가" 버튼 클릭');
      await tester.tap(find.byKey(const Key('education_add_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 10 — 학교명, 전공 입력 후 저장
      print('[STEP No.10] 학교명 입력 후 "저장" 버튼 클릭');
      await tester.enterText(
          find.byKey(const Key('school_name_field')), '한국대학교');
      await tester.enterText(
          find.byKey(const Key('major_field')), '컴퓨터공학과');
      await tester.tap(find.byKey(const Key('education_save_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 11 — "경력" 탭 클릭
      print('[STEP No.11] "경력" 탭 클릭');
      await tester.tap(find.byKey(const Key('tab_career')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 12 — "경력 추가" 버튼 클릭
      print('[STEP No.12] "경력 추가" 버튼 클릭');
      await tester.tap(find.byKey(const Key('career_add_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 13 — 회사명, 직책 입력 후 저장
      print('[STEP No.13] 회사명, 직책 입력 후 "저장" 버튼 클릭');
      await tester.enterText(
          find.byKey(const Key('company_name_field')), '테크스타트업');
      await tester.enterText(
          find.byKey(const Key('position_field')), '모바일 앱 개발자');
      await tester.tap(find.byKey(const Key('career_save_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 14 — "프로젝트" 탭 클릭
      print('[STEP No.14] 프로젝트 탭 클릭');
      await tester.tap(find.byKey(const Key('tab_project')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 15 — "프로젝트 추가" 버튼 클릭
      print('[STEP No.15] 프로젝트 추가 버튼 클릭');
      await tester.tap(find.byKey(const Key('project_add_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 16 — 프로젝트명, 사용 기술 입력 후 저장
      print('[STEP No.16] 프로젝트명, 사용 기술 입력 후 저장');
      await tester.enterText(
          find.byKey(const Key('project_name_field')), 'HireUp 채용 플랫폼');
      await tester.enterText(
          find.byKey(const Key('project_tech_field')), 'Flutter, Dart');
      await tester.tap(find.byKey(const Key('project_save_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 17 — "기술 스택" 탭 클릭
      print('[STEP No.17] 기술 스택 탭 클릭');
      await tester.tap(find.byKey(const Key('tab_skill')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 18 — 기술 입력 후 추가 버튼 클릭
      print('[STEP No.18] 기술 입력 후 추가 버튼 클릭');
      await tester.enterText(find.byKey(const Key('skill_field')), 'Flutter');
      await tester.tap(find.byKey(const Key('skill_add_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 19 — 동일한 기술 재입력 후 추가 버튼 클릭 (중복 방지 검증)
      print('[STEP No.19] 동일한 기술 재입력 후 추가 버튼 클릭');
      await tester.enterText(find.byKey(const Key('skill_field')), 'Flutter');
      await tester.tap(find.byKey(const Key('skill_add_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 20 — "저장하기" 버튼 클릭
      print('[STEP No.20] 저장하기 버튼 클릭');
      await tester.tap(find.byKey(const Key('save_bottom_btn')));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

      // STEP 21 — 생성된 이력서 카드 위치까지 스크롤
      print('[STEP No.21] 생성된 이력서 카드 위치까지 스크롤');
      await tester.drag(
          find.byKey(const Key('resume_list_scroll')), const Offset(0, -300));
      await tester.pump(const Duration(seconds: 3));
      await Future.delayed(const Duration(seconds: 5));

    });
  });
}
