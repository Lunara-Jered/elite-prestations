import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static Object? initializationError;

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}

class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client {
    final initializationError = SupabaseConfig.initializationError;
    if (initializationError != null) {
      throw StateError(
        'L’initialisation de Supabase a échoué : $initializationError',
      );
    }
    if (!SupabaseConfig.isConfigured) {
      throw StateError(
        'Supabase n’est pas configuré. Fournissez SUPABASE_URL et '
        'SUPABASE_ANON_KEY avec --dart-define.',
      );
    }
    return Supabase.instance.client;
  }
}
