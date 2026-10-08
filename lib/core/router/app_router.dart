// TODO: Define application routes.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Provider global du router
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Route temporaire (accueil)
      // On remplacera par les vraies routes au fur et à mesure
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const _PlaceholderScreen(),
      ),
    ],
  );
});

/// Écran temporaire pour tester le thème
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ÉLITE PRESTATIONS',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontFamily: 'PlayfairDisplay',
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Le Meilleur Pour Vous',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Commencer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}