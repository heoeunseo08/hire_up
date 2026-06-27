import 'dart:convert';

import 'package:hire_up/model/profile_model.dart';
import 'package:hire_up/utils/info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController {
  bool isLoading = false;
  String? error;

  ProfileUser? user;
  ProfileStats? stats;
  String? profileImagePath;

  Future<void> load() async {
    isLoading = true;
    error = null;

    try {
      final pref = await SharedPreferences.getInstance();
      profileImagePath = pref.getString('profile_image');

      final res = await http.get(
        Uri.parse('$baseUrl/profile').replace(queryParameters: {
          if (!isLogin) 'userId': userId.toString(),
        }),
        headers: {if (isLogin) 'Authorization': 'Bearer $tkn'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        user = ProfileUser.fromJson(data['data']['user']);
        stats = ProfileStats.fromJson(data['data']['stats']);
      } else {
        final data = jsonDecode(res.body);
        error = data['errors'][0]['message'];
      }
    } catch (e) {
      error = '네트워크 오류';
    }
    isLoading = false;
  }

  Future<void> saveProfileImage(String path) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('profile_image', path);
    profileImagePath = path;
  }

  Future<void> deleteProfileImage() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('profile_image');
    profileImagePath = null;
  }
}
