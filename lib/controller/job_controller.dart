import 'dart:convert';
import 'dart:developer';
import 'package:hire_up/model/job_model.dart';
import 'package:hire_up/utils/info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JobController {
  List<JobModel> model = [];
  bool isLoading = false;
  String? error;

  String sort = 'latest';
  String? category;
  String? keyword;

  List<int> bookmarks = [];

  bool isBookmark(int id) => bookmarks.contains(id);

  Future<void> loadBookmark() async {
    final pref = await SharedPreferences.getInstance();
    final ids = pref.getStringList('bookmark') ?? [];
    bookmarks = ids.map((e) => int.parse(e)).toList();
  }

  Future<void> addBookmark(int id) async {
    final pref = await SharedPreferences.getInstance();
    if (bookmarks.contains(id)) {
      bookmarks.remove(id);
    } else {
      bookmarks.add(id);
    }
    await pref.setStringList(
      'bookmark',
      bookmarks.map((e) => e.toString()).toList(),
    );
  }

  Future<void> removeBookmark(int id) async {
    final pref = await SharedPreferences.getInstance();
    bookmarks.remove(id);
    await pref.setStringList(
      'bookmark',
      bookmarks.map((e) => e.toString()).toList(),
    );
  }

  Future<void> jobs() async {
    isLoading = true;
    error = null;

    try {
      final parameters = {
        'sort': sort,
        if (category != null) 'category': category,
        if (keyword != null && keyword!.isNotEmpty) 'keyword': keyword!,
      };

      final uri = Uri.parse(
        '$baseUrl/jobs',
      ).replace(queryParameters: parameters);
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        log("결과 : $data");
        model = (data['data']['items'] as List)
            .map((e) => JobModel.fromJson(e))
            .toList();
      } else {
        error = "공고를 불러오지 못했습니다.";
      }
    } catch (e) {
      error = "네트워크 오류가 발생했습니다.";
      print("에러 상세: $e");
    }
    isLoading = false;
  }
}
