// TODO: Implement the booking flow.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../providers/booking_provider.dart';
import 'widgets/booking_stepper_header.dart';
import 'widgets/step_service.dart';
import 'widgets/step_date.dart';
import 'widgets/step_options.dart';
import 'widgets/step_recap.dart';
import 'widgets/step_payment.dart';

class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (booking.currentStep > 1) {
              ref.read(bookingProvider.notifier).previousStep();
            } else {
              context.pop();
            }
          },
        ),
        title: const Text('Nouvelle réservation'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(bookingProvider.notifier).reset();
              context.go('/home');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─────────────────────────────────
            // STEPPER HEADER (progression)
            // ─────────────────────────────────
            BookingStepperHeader(currentStep: booking.currentStep),

            // ─────────────────────────────────
            // CONTENU DE L'ÉTAPE
            // ─────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildStepContent(booking.currentStep),
              ),
            ),

            // ─────────────────────────────────
            // BOUTON CONTINUER
            // ─────────────────────────────────
            _BottomBar(booking: booking),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 1:
        return const StepService(key: ValueKey(1));
      case 2:
        return const StepDate(key: ValueKey(2));
      case 3:
        return const StepOptions(key: ValueKey(3));
      case 4:
        return const StepRecap(key: ValueKey(4));
      case 5:
        return const StepPayment(key: ValueKey(5));
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─────────────────────────────────────────
// BARRE INFÉRIEURE (bouton Continuer)
// ─────────────────────────────────────────
class _BottomBar extends ConsumerWidget {
  final BookingState booking;
  const _BottomBar({required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(16),
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
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: booking.isCurrentStepValid
                ? () {
                    if (booking.currentStep < 5) {
                      ref.read(bookingProvider.notifier).nextStep();
                    } else {
                      // Confirmation finale
                      _confirmBooking(context, ref);
                    }
                  }
                : null,
            child: Text(
              booking.currentStep < 5
                  ? 'Continuer'
                  : 'Confirmer le paiement',
            ),
          ),
        ),
      ),
    );
  }

  void _confirmBooking(BuildContext context, WidgetRef ref) {
    // TODO: appel Supabase + génération facture
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réservation confirmée !'),
        content: const Text(
          'Vous recevrez une confirmation par email et WhatsApp.\n'
          'Votre facture sera disponible dans "Mes réservations".',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(bookingProvider.notifier).reset();
              context.go('/reservations');
            },
            child: const Text('Voir ma réservation'),
          ),
        ],
      ),
    );
  }
}
