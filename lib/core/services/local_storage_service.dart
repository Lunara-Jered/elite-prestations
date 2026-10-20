import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) => throw StateError(
    'LocalStorageService doit être initialisé avant le démarrage.',
  ),
);

class LocalStorageService {
  final SharedPreferences _preferences;

  const LocalStorageService(this._preferences);

  List<T> readList<T>(
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final encoded = _preferences.getString(key);
    if (encoded == null) return [];
    final decoded = jsonDecode(encoded);
    if (decoded is! List<dynamic>) {
      throw FormatException('Les données "$key" ne sont pas une liste JSON.');
    }
    return decoded
        .map((item) => fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> saveList<T>(
    String key,
    List<T> items,
    Map<String, dynamic> Function(T item) toJson,
  ) async {
    final saved = await _preferences.setString(
      key,
      jsonEncode(items.map(toJson).toList()),
    );
    if (!saved) throw StateError('Impossible d’enregistrer "$key".');
  }

  Map<String, dynamic>? readObject(String key) {
    final encoded = _preferences.getString(key);
    if (encoded == null) return null;
    final decoded = jsonDecode(encoded);
    if (decoded is! Map) {
      throw FormatException('Les données "$key" ne sont pas un objet JSON.');
    }
    return Map<String, dynamic>.from(decoded);
  }

  Future<void> saveObject(String key, Map<String, dynamic> value) async {
    final saved = await _preferences.setString(key, jsonEncode(value));
    if (!saved) throw StateError('Impossible d’enregistrer "$key".');
  }

  Future<void> remove(String key) async {
    final removed = await _preferences.remove(key);
    if (!removed) throw StateError('Impossible de supprimer "$key".');
  }
}
