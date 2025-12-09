import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserStorageService {
  static const _usersKey = 'users';

  Future<List<User>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_usersKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .map((e) => User.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final list = users.map((u) => u.toJson()).toList();
    final jsonString = jsonEncode(list);
    await prefs.setString(_usersKey, jsonString);
  }
}
