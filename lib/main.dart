import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 

import 'app.dart';
import 'core/services/local_storage_service.dart'; // <-- IMPORT AJOUTÉ

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Supabase
  await Supabase.initialize(
    url: 'https://yhxdvbguztnirevcwnlz.supabase.co',
    anonKey: 'sb_publishable_ecwxOOA89_SJUcHBX0oKEQ_X0fNFsHe',
  );

  // Initialisation du stockage local
  final prefs = await SharedPreferences.getInstance();
  LocalStorageService.initialize(prefs); // <-- LIGNE AJOUTÉE

  // Initialisation des dates
  await initializeDateFormatting('fr_FR', null);

  runApp(
    const ProviderScope(
      child: ElitePrestationsApp(),
    ),
  );
}