import 'dart:convert';

import 'package:hire_up/utils/info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchKeywordController {
  List<String> popularKeywords = [];
  List<String> recentKeywords = [];
  String? error;

  Future<void> getKeywords() async {
    error = null;

    try {
      final uri = Uri.parse('$baseUrl/search/popular');
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        popularKeywords = List<String>.from(data['data']['keywords']);
      } else {
        error = "공고를 불러오지 못했습니다.";
      }
    } catch (e) {
      error = "네트워크 오류가 발생했습니다.";
      print("에러 상세: $e");
    }
  }

  Future<void> loadRecentKeywords() async {
    final pref = await SharedPreferences.getInstance();
    recentKeywords = pref.getStringList('recent') ?? [];
  }

  Future<void> addRentKeywords(String keyword) async {
    final pref = await SharedPreferences.getInstance();
    recentKeywords.remove(keyword);
    recentKeywords.insert(0, keyword);
    await pref.setStringList('recent', recentKeywords);
  }

  Future<void> removeRecentKeyword(String keyword) async {
    final pref = await SharedPreferences.getInstance();
    recentKeywords.remove(keyword);
    await pref.setStringList('recent', recentKeywords);
  }

  Future<void> clearRecentKeyword() async {
    final pref = await SharedPreferences.getInstance();
    recentKeywords.clear();
    await pref.remove('recent');
  }
}
