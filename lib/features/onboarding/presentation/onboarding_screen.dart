import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import 'widgets/onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      icon: Icons.celebration_outlined,
      title: 'Élégance & Professionnalisme',
      description:
          'L\'excellence événementielle au Gabon, à portée de main.',
    ),
    OnboardingSlideData(
      icon: Icons.event_available_outlined,
      title: 'Réservez en quelques clics',
      description:
          'Salle, mariage, appartement, transport… tout au même endroit.',
    ),
    OnboardingSlideData(
      icon: Icons.receipt_long_outlined,
      title: 'Vos factures à portée',
      description:
          'Devis, factures et historique toujours accessibles.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/home');
    }
  }

  void _skip() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // ─────────────────────────────────
            // BOUTON PASSER
            // ─────────────────────────────────
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    'Passer',
                    style: TextStyle(color: AppColors.textMutedOnDark),
                  ),
                ),
              ),
            ),

            // ─────────────────────────────────
            // SLIDES
            // ─────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return OnboardingSlide(data: _slides[index]);
                },
              ),
            ),

            // ─────────────────────────────────
            // INDICATEURS
            // ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.white
                        : AppColors.gray600,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ─────────────────────────────────
            // BOUTON CONTINUER
            // ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1
                        ? 'Commencer'
                        : 'Continuer',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
