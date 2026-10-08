// TODO: Implement the booking payment step.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency.dart';
import '../../providers/booking_provider.dart';

class StepPayment extends ConsumerWidget {
  const StepPayment({super.key});

  static const List<_PaymentMethod> _methods = [
    _PaymentMethod(
      id: 'airtel',
      emoji: '📱',
      name: 'Airtel Money',
      description: 'Paiement mobile sécurisé',
    ),
    _PaymentMethod(
      id: 'moov',
      emoji: '📱',
      name: 'Moov Money',
      description: 'Paiement mobile sécurisé',
    ),
    _PaymentMethod(
      id: 'virement',
      emoji: '🏦',
      name: 'Virement bancaire',
      description: 'BICIG, BGFI, UGB…',
    ),
    _PaymentMethod(
      id: 'especes',
      emoji: '💵',
      name: 'Espèces sur place',
      description: 'Validation par notre équipe',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ─────────────────────────────────
        // MONTANT À PAYER
        // ─────────────────────────────────
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.blackGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Montant à payer maintenant',
                style: TextStyle(color: AppColors.gray300, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text(
                formatFCFA(booking.deposit),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Acompte 50% • Reste ${formatFCFA(booking.totalTTC - booking.deposit)}',
                style: const TextStyle(
                  color: AppColors.gray400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ─────────────────────────────────
        // CHOIX DU MOYEN
        // ─────────────────────────────────
        Text(
          'Choisissez votre moyen de paiement',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),

        ..._methods.map((method) {
          final isSelected = booking.paymentMethod == method.id;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                ref.read(bookingProvider.notifier).setPaymentMethod(method.id);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isLight ? AppColors.primary : AppColors.white)
                      : (isLight ? AppColors.surface : AppColors.surfaceDark),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? (isLight ? AppColors.primary : AppColors.white)
                        : (isLight ? AppColors.border : AppColors.borderDark),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(method.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? (isLight
                                      ? AppColors.white
                                      : AppColors.primary)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            method.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? (isLight
                                      ? AppColors.gray300
                                      : AppColors.textMuted)
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? (isLight ? AppColors.white : AppColors.primary)
                          : AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 24),
        Text(
          'En confirmant, vous acceptez nos conditions générales.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
      ],
    );
  }
}

class _PaymentMethod {
  final String id;
  final String emoji;
  final String name;
  final String description;

  const _PaymentMethod({
    required this.id,
    required this.emoji,
    required this.name,
    required this.description,
  });
}
