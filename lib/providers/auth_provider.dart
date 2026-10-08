// TODO: Implement authentication state and actions.
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modèle utilisateur minimal (sera remplacé par le vrai en Étape 2)
class UserModel {
  final String id;
  final String email;
  final String? name;
  final String role; // 'USER' ou 'ADMIN'

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.role = 'USER',
  });

  bool get isAdmin => role == 'ADMIN';
}

/// État d'authentification
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Provider principal d'auth (mocké pour l'instant)
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  /// Connexion mockée (remplacée par Supabase Auth plus tard)
  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));
    
    state = state.copyWith(
      isLoading: false,
      user: UserModel(
        id: 'mock-user-1',
        email: email,
        name: 'Utilisateur Test',
        role: 'USER', // Passer à 'ADMIN' pour tester le dashboard admin
      ),
    );
  }

  Future<void> signOut() async {
    state = const AuthState();
  }
}
