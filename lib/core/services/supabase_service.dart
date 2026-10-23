import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  SupabaseConfig._();

  // On met les valeurs directement entre guillemets
  static const String url = 'https://yhxdvbguztnirevcwnlz.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InloeGR2Ymd1enRuaXJ2Y3dubHoiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTc5Mjc1NzA5MCwiZXhwIjoyMTA4MzMzMDkwfQ.sYhIWKv-sA9emehx7ADh72auKV5nGsFrgEJBxkFbAfQ';

  static Object? initializationError;

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}

class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client {
    final error = SupabaseConfig.initializationError;
    if (error != null) {
      throw StateError(
        'L’initialisation de Supabase a échoué : $error',
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
