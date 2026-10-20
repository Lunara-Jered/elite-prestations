import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/local_storage_service.dart';
import '../shared/models/user_model.dart';

export '../shared/models/user_model.dart';

const _accountsStorageKey = 'auth_accounts';
const _currentUserStorageKey = 'auth_current_user';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthState {
  final UserModel? user;
  final List<UserModel> users;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    List<UserModel>? users,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : user ?? this.user,
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late LocalStorageService _storage;
  late List<_AuthCredential> _credentials;

  @override
  AuthState build() {
    _storage = ref.read(localStorageServiceProvider);
    _credentials = _storage.readList(
      _accountsStorageKey,
      _AuthCredential.fromJson,
    );
    final currentUserJson = _storage.readObject(_currentUserStorageKey);
    return AuthState(
      user: currentUserJson == null
          ? null
          : UserModel.fromJson(currentUserJson),
      users: List.unmodifiable(_credentials.map((account) => account.user)),
    );
  }

  Future<UserModel> signUp(
    String name,
    String email,
    String password, {
    String role = 'USER',
    String? phone,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedName = name.trim();
    final normalizedRole = role.trim().toUpperCase();
    if (normalizedName.isEmpty || !_isValidEmail(normalizedEmail)) {
      throw ArgumentError(
        'Veuillez renseigner un nom et une adresse e-mail valide.',
      );
    }
    if (password.length < 8) {
      throw ArgumentError(
        'Le mot de passe doit contenir au moins 8 caractères.',
      );
    }
    if (normalizedRole != 'USER' && normalizedRole != 'ADMIN') {
      throw ArgumentError.value(role, 'role', 'Rôle inconnu.');
    }
    if (_credentials.any((account) => account.user.email == normalizedEmail)) {
      throw StateError('Cette adresse e-mail possède déjà un compte.');
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = UserModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        email: normalizedEmail,
        name: normalizedName,
        role: normalizedRole,
        phone: phone == null || phone.trim().isEmpty ? null : phone.trim(),
      );
      final credential = _AuthCredential(
        user: user,
        passwordHash: _hashPassword(user.id, password),
      );
      final updated = [..._credentials, credential];
      await _storage.saveList(
        _accountsStorageKey,
        updated,
        (account) => account.toJson(),
      );
      await _storage.saveObject(_currentUserStorageKey, user.toJson());
      _credentials = updated;
      state = AuthState(
        user: user,
        users: List.unmodifiable(updated.map((account) => account.user)),
      );
      return user;
    } catch (error) {
      state = state.copyWith(error: error.toString(), clearUser: true);
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<UserModel> register(
    String name,
    String email,
    String password, {
    String role = 'USER',
    String? phone,
  }) =>
      signUp(name, email, password, role: role, phone: phone);

  Future<UserModel> signIn(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!_isValidEmail(normalizedEmail) || password.isEmpty) {
      throw ArgumentError('Adresse e-mail ou mot de passe invalide.');
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final matches = _credentials
          .where((account) => account.user.email == normalizedEmail);
      if (matches.isEmpty) {
        throw StateError('Adresse e-mail ou mot de passe incorrect.');
      }
      final credential = matches.first;
      if (credential.passwordHash != _hashPassword(credential.user.id, password)) {
        throw StateError('Adresse e-mail ou mot de passe incorrect.');
      }
      await _storage.saveObject(
        _currentUserStorageKey,
        credential.user.toJson(),
      );
      state = state.copyWith(user: credential.user, clearError: true);
      return credential.user;
    } catch (error) {
      state = state.copyWith(error: error.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _storage.remove(_currentUserStorageKey);
      state = AuthState(users: state.users);
    } catch (error) {
      state = state.copyWith(error: error.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() => signOut();

  static bool _isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

  static String _hashPassword(String userId, String password) =>
      sha256.convert(utf8.encode('$userId:$password')).toString();
}

class _AuthCredential {
  final UserModel user;
  final String passwordHash;

  const _AuthCredential({required this.user, required this.passwordHash});

  Map<String, dynamic> toJson() => {
        ...user.toJson(),
        'passwordHash': passwordHash,
      };

  factory _AuthCredential.fromJson(Map<String, dynamic> json) =>
      _AuthCredential(
        user: UserModel.fromJson(json),
        passwordHash: json['passwordHash'] as String,
      );
}
