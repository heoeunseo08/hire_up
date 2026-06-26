import 'dart:convert';
import 'dart:io';

import 'package:hire_up/model/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/info.dart';

class ProfileController {
  ProfileUser? user;
  ProfileStats? stats;

  String? profilePath;
  String? error;

  Future<bool> getProfile() async {
    error = null;
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/profile?userId=$userId'),
        headers: {'Authorization': 'Bearer $tkn'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        user = ProfileUser.fromJson(data['user']);
        stats = ProfileStats.fromJson(data['stats']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> loadProfile() async {
    final pref = await SharedPreferences.getInstance();
    profilePath = pref.getString('profileImage');
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked == null) return;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('profileImage', picked.path);
    profilePath = picked.path;
  }

  Future<void> removeImage() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('profileImage');
  }

  File? get imageFile => profilePath != null ? File(profilePath!) : null;
}
