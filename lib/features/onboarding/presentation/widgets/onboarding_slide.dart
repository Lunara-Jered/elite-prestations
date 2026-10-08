// TODO: Implement an onboarding slide.
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Données d'une slide d'onboarding
class OnboardingSlideData {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingSlideData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// Widget d'une slide d'onboarding
class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideData data;

  const OnboardingSlide({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.gray900,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gray700, width: 1),
            ),
            child: Icon(
              data.icon,
              size: 56,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 48),

          // Titre
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textMutedOnDark,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
