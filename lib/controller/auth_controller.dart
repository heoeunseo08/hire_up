import 'dart:convert';

import 'package:hire_up/utils/info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  String? error;

  Future<bool> login({
    required String email,
    required String password,
    required bool keepLogin,
  }) async {
    error = null;

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        tkn = data['data']['token'];
        userName.value = data['data']['user']['name'];

        if (keepLogin) {
          final pref = await SharedPreferences.getInstance();
          await pref.setString('token', tkn);
          await pref.setString('userName', userName.value);
        } else {
          final pref = await SharedPreferences.getInstance();
          await pref.remove('token');
          await pref.remove('userName');
        }
        return true;
      } else {
        final data = jsonDecode(res.body);
        error = data['errors'][0]['message'];
        return false;
      }
    } catch (e) {
      error = '네트워크 오류';
      return false;
    }
  }

  Future<bool> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    error = null;

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
        }),
      );
      print('상태코드: ${res.statusCode}');
      print('응답: ${res.body}'); // 추가
      if (res.statusCode == 200 || res.statusCode == 201) return true;
      final data = jsonDecode(res.body);
      error = data['errors']?[0]['message'] ?? '실패했습니다.';
      return false;
    } catch (e) {
      error = '네트워크 오류';
      print('에러: $error'); // 이미 있음
      return false;
    }
  }

  Future<bool> sendCode({required String phone}) async {
    error = null;
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/phone/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      if (res.statusCode == 200) {
        return true;
      }
      final data = jsonDecode(res.body);
      error = data['errors'][0]['message'];
      return false;
    } catch (e) {
      error = '네트워크 오류';
      return false;
    }
  }

  Future<bool> checkCode({required String phone, required String code}) async {
    error = null;
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/phone/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'code': code}),
      );

      if (res.statusCode == 200) {
        return true;
      }
      final data = jsonDecode(res.body);
      error = data['errors'][0]['message'];
      return false;
    } catch (e) {
      error = '네트워크 오류';
      return false;
    }
  }

  String? checkLoginEmail(String email) {
    if (email.isEmpty) return '이메일을 입력해수제요.';
    final before = email.split('@')[0];
    if (!email.contains('@') || !email.contains('.') || before.contains('.')) {
      return '이메일을 확인해수제요.';
    }
    return null;
  }

  String? checkLoginPassword(String password) {
    if (password.isEmpty) return '비밀번호를 입력해주세요.';
    if (password.length < 6) return '비밀번호는 6자 이상이어야 해요.';
    return null;
  }

  String? checkSignupEmail(String email) {
    if (email.isEmpty) return '이메일을 입력해주세요.';
    if (!email.contains('@')) {
      return '@을 추가해주세요';
    }
    return null;
  }

  String? checkSignupName(String name) {
    if (name.isEmpty) return '이름을 입력해주세요.';
    if (!RegExp(r'^[ㄱ-ㅎ가-힣a-zA-Z]+$').hasMatch(name)) {
      return '이름은 한글 또는 영문만 입력 가능해요.';
    }
    return null;
  }

  String? checkSignupNumber(String number1, String number2, String number3) {
    if (number1.length < 3 && number2.length < 4 && number3.length < 4) {
      return '휴대폰 번호를 입력해주세요.';
    }
    return null;
  }

  String? checkSignupPassword(String password, String checkPassword) {
    if (password.isEmpty) return '비밀번호를 입력해주세요.';
    if (password.length < 8) return '비밀번호는 8자 이상이어야 해요.';
    if (!password.contains(RegExp(r'[a-z]'))) return '소문자를 포함해주세요.';
    if (!password.contains(RegExp(r'[A-Z]'))) return '대문자를 포함해주세요.';
    if (!password.contains(RegExp(r'[0-9]'))) return '숫자를 포함해주세요.';
    if (!password.contains(RegExp(r'[!@#$%^&*]'))) return '특수문자를 포함해주세요.';
    if (password != checkPassword) return '비밀번호 확인이 비밀번호와 일치하지 않아요.';
    return null;
  }

  Future<void> loadTkn() async {
    final pref = await SharedPreferences.getInstance();
    tkn = pref.getString('token') ?? '';
    userName.value = pref.getString('userName') ?? '게스트';
  }
}
