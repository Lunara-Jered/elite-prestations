import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Application principale Élite Prestations
class ElitePrestationsApp extends ConsumerWidget {
  const ElitePrestationsApp({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'Élite Prestations',
      debugShowCheckedModeBanner: false,
      
      // Thème
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light, // à rendre dynamique plus tard
      
      // Navigation
      routerConfig: router,
    );
  }
}