import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // On utilise une instance statique qui sera initialisée au démarrage
  static late SharedPreferences _prefs;

  static void initialize(SharedPreferences prefs) {
    _prefs = prefs;
  }

  void saveObject(String key, Map<String, dynamic> data) {
    _prefs.setString(key, jsonEncode(data));
  }

  Map<String, dynamic>? readObject(String key) {
    final str = _prefs.getString(key);
    if (str == null) return null;
    return jsonDecode(str) as Map<String, dynamic>;
  }

  void saveList(String key, List<dynamic> data, dynamic Function(dynamic) toJson) {
    final jsonList = data.map((item) => toJson(item)).toList();
    _prefs.setString(key, jsonEncode(jsonList));
  }

  List<T> readList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final str = _prefs.getString(key);
    if (str == null) return [];
    final List<dynamic> jsonList = jsonDecode(str) as List<dynamic>;
    return jsonList.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  }

  void remove(String key) {
    _prefs.remove(key);
  }
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});