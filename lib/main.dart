import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialisation de Supabase
  await Supabase.initialize(
    url: 'https://yhxdvbguztnirevcwnlz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InloeGR2Ymd1enRuaXJldmN3bmx6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI3NTcwOTAsImV4cCI6MjEwODMzMzA5MH0.sYhIWKv-sA9emehx7ADh72auKV5nGsFrgEJBxkFbAfQ', // <-- À REMPLACER
  );

  // 2. Initialisation des dates en français
  await initializeDateFormatting('fr_FR', null);

  runApp(
    const ProviderScope(
      child: ElitePrestationsApp(),
    ),
  );
}
