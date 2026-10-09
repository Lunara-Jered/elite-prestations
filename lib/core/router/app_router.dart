import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/main_shell.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../features/services/presentation/service_detail_screen.dart';
import '../../features/reservations/presentation/reservation_screen.dart';
import '../../features/messages/presentation/messages_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/admin/presentation/admin_shell.dart';
import '../../features/admin/presentation/dashboard_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/sign_up_screen.dart';
import '../../features/booking/presentation/booking_screen.dart';
import '../../features/reservations/presentation/reservation_detail_screen.dart';

/// Clés de navigation globales (pour naviguer depuis n'importe où)
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Provider global du router
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    debugLogDiagnostics: true,
    
    routes: [
      // ─────────────────────────────────────────
      // ONBOARDING
      // ─────────────────────────────────────────
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // ─────────────────────────────────────────
      // AUTHENTIFICATION
      // ─────────────────────────────────────────
      GoRoute(
        path: '/sign-in',
        name: 'signIn',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        name: 'signUp',
        builder: (context, state) => const SignUpScreen(),
      ),
      
      // ─────────────────────────────────────────
      // DÉTAIL SERVICE (hors ShellRoute → plein écran)
      // ─────────────────────────────────────────
      GoRoute(
        path: '/services/:slug',
        name: 'serviceDetail',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return ServiceDetailScreen(slug: slug);
        },
      ),
      
      // ─────────────────────────────────────────
      // APPLICATION (avec bottom tabs)
      // ─────────────────────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/services',
            name: 'services',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ServicesScreen(),
            ),
          ),
          GoRoute(
            path: '/reservations',
            name: 'reservations',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ReservationScreen(),
            ),
          ),
          GoRoute(
            path: '/messages',
            name: 'messages',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MessagesScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      // ─────────────────────────────────────────
      // RÉSERVATION (hors shell)
      // ─────────────────────────────────────────
      GoRoute(
        path: '/booking',
        name: 'booking',
        builder: (context, state) => const BookingScreen(),
      ),
      // ─────────────────────────────────────────
      // ADMIN (hors bottom tabs)
      // ─────────────────────────────────────────
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminShell(),
        routes: [
          GoRoute(
            path: 'dashboard',
            name: 'adminDashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
        ],
      ),
    ],
    // ─────────────────────────────────────────
    // DÉTAIL RÉSERVATION (hors shell)
    // ─────────────────────────────────────────
    GoRoute(
      path: '/reservations/:id',
      name: 'reservationDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ReservationDetailScreen(reservationId: id);
      },
    ),
    
    // Gestion des erreurs (route inconnue)
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page introuvable',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(state.error?.toString() ?? ''),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.goNamed('home'),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
});
