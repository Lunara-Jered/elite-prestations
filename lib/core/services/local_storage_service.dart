import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // On rend SharedPreferences accessible de manière asynchrone
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> saveObject(String key, Map<String, dynamic> data) async {
    final prefs = await _prefs;
    await prefs.setString(key, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> readObject(String key) async {
    final prefs = await _prefs;
    final str = prefs.getString(key);
    if (str == null) return null;
    return jsonDecode(str) as Map<String, dynamic>;
  }

  Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});