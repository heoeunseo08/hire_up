import 'dart:convert';
import 'package:hire_up/utils/info.dart';
import 'package:http/http.dart' as http;

class ResumeItem {
  final int id;
  final String title;
  final String updatedAt;
  final List<String> skills;

  ResumeItem({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.skills,
  });

  factory ResumeItem.fromJson(Map<String, dynamic> json) => ResumeItem(
        id: json['id'],
        title: json['title'],
        updatedAt: json['updatedAt'],
        skills: List<String>.from(json['skills']),
      );

  String get formattedDate {
    try {
      final dt = DateTime.parse(updatedAt);
      final y = dt.year;
      final mo = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      final h = dt.hour.toString().padLeft(2, '0');
      final mi = dt.minute.toString().padLeft(2, '0');
      return '$y.$mo.$d $h:$mi';
    } catch (_) {
      return updatedAt;
    }
  }
}

class Education {
  String schoolName;
  String major;
  String degree;
  String startDate;
  String endDate;

  Education({
    this.schoolName = '',
    this.major = '',
    this.degree = '',
    this.startDate = '',
    this.endDate = '',
  });

  Map<String, dynamic> toJson() => {
        'schoolName': schoolName,
        'major': major,
      };
}

class Career {
  String companyName;
  String position;
  String startDate;
  String endDate;
  bool isCurrent;
  String description;

  Career({
    this.companyName = '',
    this.position = '',
    this.startDate = '',
    this.endDate = '',
    this.isCurrent = false,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'position': position,
        'startDate': startDate,
        'endDate': isCurrent ? '' : endDate,
        'isCurrent': isCurrent,
        'description': description,
      };
}

class Project {
  String name;
  String period;
  String description;
  List<String> techStack;

  Project({
    this.name = '',
    this.period = '',
    this.description = '',
    List<String>? techStack,
  }) : techStack = techStack ?? [];

  Map<String, dynamic> toJson() => {
        'name': name,
        'period': period,
        'description': description,
        'techStack': techStack,
      };
}

class ResumeController {
  List<ResumeItem> items = [];
  String? error;

  int? editId;
  String title = '';
  String jobRole = '';
  String oneLineIntro = '';
  String intro = '';
  List<Education> educations = [];
  List<Career> careers = [];
  List<Project> projects = [];
  List<String> skills = [];

  Future<bool> getResumes() async {
    error = null;
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/resumes?userId=$userId'),
        headers: {'Authorization': 'Bearer $tkn'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        items = (data['items'] as List)
            .map((e) => ResumeItem.fromJson(e))
            .toList();
        return true;
      }
      return false;
    } catch (e) {
      error = '네트워크 오류';
      return false;
    }
  }

  Future<bool> saveResume() async {
    error = null;
    try {
      final uri = editId != null
          ? Uri.parse('$baseUrl/resumes?id=$editId&userId=$userId')
          : Uri.parse('$baseUrl/resumes?userId=$userId');

      final res = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tkn',
        },
        body: jsonEncode({
          'title': title,
          'jobRole': jobRole,
          'oneLineIntro': oneLineIntro,
          'intro': intro,
          'educations': educations.map((e) => e.toJson()).toList(),
          'careers': careers.map((e) => e.toJson()).toList(),
          'projects': projects.map((e) => e.toJson()).toList(),
          'skills': skills,
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 201) return true;
      final data = jsonDecode(res.body);
      error = data['message'];
      return false;
    } catch (e) {
      error = '네트워크 오류';
      return false;
    }
  }

  Future<bool> deleteResume(int id) async {
    error = null;
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/resumes/$id?userId=$userId'),
        headers: {'Authorization': 'Bearer $tkn'},
      );
      return res.statusCode == 200 || res.statusCode == 204;
    } catch (e) {
      error = '네트워크 오류';
      return false;
    }
  }

  Future<bool> duplicateResume(int id) async {
    error = null;
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/resumes/$id/copy?userId=$userId'),
        headers: {'Authorization': 'Bearer $tkn'},
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      error = '네트워크 오류';
      return false;
    }
  }

  void loadFromItem(ResumeItem item) {
    editId = item.id;
    title = item.title;
    skills = List<String>.from(item.skills);
  }
}
