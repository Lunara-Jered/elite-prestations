import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

/// Shell principal avec la barre de navigation en bas
class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  static const List<String> _routes = [
    '/home',
    '/services',
    '/gallery', // <-- Nouvelle route
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final location = GoRouterState.of(context).uri.path;
    
    // On calcule l'index actuel en fonction de l'URL
    int currentIndex = _routes.indexWhere((route) => location.startsWith(route));
    if (currentIndex == -1) currentIndex = 0;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isLight ? AppColors.surface : AppColors.surfaceDark,
          border: Border(
            top: BorderSide(
              color: isLight ? AppColors.border : AppColors.borderDark,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.go(_routes[index]);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: isLight ? AppColors.primary : AppColors.white,
            unselectedItemColor: AppColors.textMuted,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: AppStrings.navHome,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.room_service_outlined),
                activeIcon: Icon(Icons.room_service),
                label: AppStrings.navServices,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_library_outlined), // Icône Galerie
                activeIcon: Icon(Icons.photo_library),
                label: 'Galerie', // Nouveau label
              ),
            ],
          ),
        ),
      ),
    );
  }
}