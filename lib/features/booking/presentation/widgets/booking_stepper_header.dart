import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BookingStepperHeader extends StatelessWidget {
  final int currentStep;
  const BookingStepperHeader({super.key, required this.currentStep});

  static const List<String> _labels = [
    'Service',
    'Date',
    'Options',
    'Récap',
    'Paiement',
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(_labels.length * 2 - 1, (index) {
          // Ligne de connexion
          if (index.isOdd) {
            final stepIndex = index ~/ 2;
            final isDone = stepIndex < currentStep - 1;
            return Expanded(
              child: Container(
                height: 2,
                color: isDone
                    ? (isLight ? AppColors.primary : AppColors.white)
                    : (isLight ? AppColors.border : AppColors.borderDark),
              ),
            );
          }

          // Point d'étape
          final stepIndex = index ~/ 2;
          final step = stepIndex + 1;
          final isDone = step < currentStep;
          final isCurrent = step == currentStep;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDone || isCurrent
                      ? (isLight ? AppColors.primary : AppColors.white)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone || isCurrent
                        ? (isLight ? AppColors.primary : AppColors.white)
                        : (isLight ? AppColors.border : AppColors.borderDark),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? Icon(
                          Icons.check,
                          size: 14,
                          color: isLight ? AppColors.white : AppColors.primary,
                        )
                      : Text(
                          '$step',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? (isLight
                                    ? AppColors.white
                                    : AppColors.primary)
                                : AppColors.textMuted,
                          ),
                        ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
