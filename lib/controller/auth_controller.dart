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
        userName = data['data']['user']['name'];

        if (keepLogin) {
          final pref = await SharedPreferences.getInstance();
          await pref.setString('token', tkn);
          await pref.setString('userName', userName);
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

  String? checkEmail(String email) {
    if (email.isEmpty) return '이메일을 입력해수제요.';
    final before = email.split('@')[0];
    if (!email.contains('@') && !email.contains('.') && before.contains('.')) {
      return '이메일을 확인해수제요.';
    }
    return null;
  }

  String? checkPassword(String password) {
    if (password.isEmpty) return '비밀번호를 입력해수제요.';
    if (password.length < 6) return '비밀번호는 6자 이상이어야 해요.';
    return null;
  }

  Future<void> loadTkn() async {
    final pref = await SharedPreferences.getInstance();
    tkn = pref.getString('token') ?? '';
    userName = pref.getString('userName') ?? '게스트';
  }
}
