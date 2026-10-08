import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _HeroCard(),
            const SizedBox(height: 24),
            Text('Nos Services',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            const _PlaceholderSection(height: 180),
            const SizedBox(height: 24),
            Text('Nos Réalisations',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            const _PlaceholderSection(height: 240),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: AppColors.blackGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ÉLITE PRESTATIONS',
              style: TextStyle(
                color: AppColors.textOnDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
                Text(
                  'Le Meilleur Pour Vous',   // ← AJOUTE CETTE LIGNE
                  style: TextStyle(
                    color: AppColors.textMutedOnDark,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.heroTitle,
                  style:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textOnDark,
                          ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                    minimumSize: const Size(0, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text('Planifier mon événement'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderSection extends StatelessWidget {
  final double height;
  const _PlaceholderSection({required this.height});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isLight ? AppColors.gray100 : AppColors.gray800,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLight ? AppColors.border : AppColors.borderDark,
        ),
      ),
      child: Center(
        child: Text(
          'Contenu à venir',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
