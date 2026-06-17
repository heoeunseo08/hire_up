import 'dart:convert';
import 'package:hire_up/model/job_model.dart';
import 'package:hire_up/utils/info.dart';
import 'package:http/http.dart' as http;

class JobController {
  List<JobModel> model = [];
  bool isLoading = false;
  String? error;

  String sort = 'latest';
  String? category;
  String? keyword;

  Future<void> jobs() async {
    isLoading = true;
    error = null;

    try {
      final parameters = {
        'sort': sort,
        if (category != null) 'category': category,
        if (keyword != null && keyword!.isNotEmpty) 'keyword': keyword!,
      };

      final uri = Uri.parse('$baseUrl/jobs').replace(
          queryParameters: parameters);
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
}
