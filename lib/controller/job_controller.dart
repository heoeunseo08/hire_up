import 'dart:convert';
import 'package:hire_up/model/detail_job_model.dart';
import 'package:hire_up/model/job_model.dart';
import 'package:hire_up/model/recommended_model.dart';
import 'package:hire_up/utils/info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JobController {
  List<JobModel> model = [];
  List<RecommendedModel> recommendedModel = [];
  bool isLoading = false;
  bool isRecommendedLoading = false;
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
        model = (data['data']['items'] as List)
            .map((e) => JobModel.fromJson(e))
            .toList();
      } else {
        error = "공고를 불러오지 못했습니다.";
      }
    } catch (e) {
      error = "네트워크 오류가 발생했습니다.";
    }
    isLoading = false;
  }

  Future<void> recommendedJobs() async {
    isRecommendedLoading = true;
    error = null;

    try {
      final uri = Uri.parse(
        '$baseUrl/jobs/recommended',
      );
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        recommendedModel = (data['data']['items'] as List)
            .map((e) => RecommendedModel.fromJson(e))
            .toList();
      } else {
        error = "공고를 불러오지 못했습니다.";
      }
    } catch (e) {
      error = "네트워크 오류가 발생했습니다.";
    }
    isRecommendedLoading = false;
  }

  Future<DetailJobModel?> detailsJob(int id) async {
    error = null;
    try {
      final uri = Uri.parse('$baseUrl/jobs/$id');
      final res = await http.get(uri);
      print('결과:${res.body}');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return DetailJobModel.from(data['data']);
      } else {
        error = "상세 공고를 불러오지 못했습니다.";
      }
    } catch (e) {
      error = "네트워크 오류가 발생했습니다.";
      print('$error:$e');
    }
    return null;
  }
}
