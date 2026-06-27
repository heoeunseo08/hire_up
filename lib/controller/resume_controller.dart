import 'dart:convert';

import 'package:hire_up/model/resume_model.dart';
import 'package:hire_up/utils/info.dart';
import 'package:http/http.dart' as http;

class ResumeController {
  bool isLoading = false;
  String? error;

  List<ResumeModel> resumes = [];

  Future<void> load() async {
    isLoading = true;
    error = null;
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/resumes').replace(queryParameters: {
          if (!isLogin) 'userId': userId.toString(),
        }),
        headers: {if (isLogin) 'Authorization': 'Bearer $tkn'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        resumes = (data['data']['items'] as List)
            .map((e) => ResumeModel.fromJson(e))
            .toList();
      } else {
        error = '이력서를 불러오지 못했습니다.';
      }
    } catch (e) {
      error = '네트워크 오류';
    }
    isLoading = false;
  }

  Future<int?> save({
    int? id,
    required Map<String, dynamic> body,
  }) async {
    error = null;
    try {
      final uri = Uri.parse('$baseUrl/resumes').replace(queryParameters: {
        if (id != null) 'id': id.toString(),
        if (!isLogin) 'userId': userId.toString(),
      });
      final res = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (isLogin) 'Authorization': 'Bearer $tkn',
        },
        body: jsonEncode(body),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return data['data']['id'];
      } else {
        error = '이력서 저장에 실패했습니다.';
      }
    } catch (e) {
      error = '네트워크 오류';
    }
    return null;
  }

  Future<void> delete(int id) async {
    resumes.removeWhere((r) => r.id == id);
  }
}
