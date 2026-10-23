import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static const url = String.fromEnvironment('https://yhxdvbguztnirevcwnlz.supabase.co');
  static const anonKey = String.fromEnvironment('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InloeGR2Ymd1enRuaXJldmN3bmx6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI3NTcwOTAsImV4cCI6MjEwODMzMzA5MH0.sYhIWKv-sA9emehx7ADh72auKV5nGsFrgEJBxkFbAfQ');

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
