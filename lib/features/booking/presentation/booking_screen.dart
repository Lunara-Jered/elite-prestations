import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/company_info.dart';
import '../../../core/services/whatsapp_service.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/invoices_provider.dart';
import '../../../providers/reservations_provider.dart';
import '../../../shared/models/invoice_model.dart';
import '../../../shared/models/reservation_model.dart';
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
class _BottomBar extends ConsumerStatefulWidget {
  final BookingState booking;
  const _BottomBar({required this.booking});

  @override
  ConsumerState<_BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<_BottomBar> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
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
            onPressed: booking.isCurrentStepValid && !_isSubmitting
                ? () {
                    if (booking.currentStep < 5) {
                      ref.read(bookingProvider.notifier).nextStep();
                    } else {
                      // Confirmation finale
                      _confirmBooking(context);
                    }
                  }
                : null,
            child: Text(
              booking.currentStep < 5
                  ? 'Continuer'
                  : _isSubmitting
                      ? 'Enregistrement...'
                      : 'Confirmer le paiement',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmBooking(BuildContext context) async {
    if (_isSubmitting) return;
    final service = widget.booking.selectedService;
    final startDate = widget.booking.startDate;
    
    if (service == null || startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informations de réservation incomplètes.')),
      );
      return;
    }

    // 1. On active le chargement sur le bouton
    setState(() => _isSubmitting = true);

    final now = DateTime.now();
    final id = now.microsecondsSinceEpoch.toString();
    
    // 2. On prépare le message WhatsApp
    final message = 'Bonjour Élite Prestations, je viens de faire une réservation.\n'
        'Service : ${service.name}\n'
        'Date : ${startDate.day}/${startDate.month}/${startDate.year}\n'
        'Durée : ${widget.booking.duration} jour(s)\n'
        'Total TTC : ${widget.booking.totalTTC} FCFA\n'
        'Acompte : ${widget.booking.deposit} FCFA';
        
    final whatsappUrl = Uri.parse('https://wa.me/24162391121?text=${Uri.encodeComponent(message)}');

    // 3. On ouvre WhatsApp immédiatement (avant Supabase)
    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Erreur WhatsApp : $e');
    }

    // 4. On sauvegarde dans Supabase en arrière-plan
    try {
      final currentUser = ref.read(authProvider).user;
      
      final reservation = ReservationModel(
        id: id,
        reference: 'RES-${now.year}-${id.substring(id.length - 4)}',
        serviceName: service.name,
        startDate: startDate,
        endDate: widget.booking.endDate ?? startDate.add(Duration(days: widget.booking.duration - 1)),
        duration: widget.booking.duration,
        totalTTC: widget.booking.totalTTC,
        deposit: widget.booking.deposit,
        status: ReservationStatus.pending,
        options: widget.booking.options,
        createdAt: now,
        clientId: currentUser?.id,
        clientName: currentUser?.name ?? 'Client invité',
        clientEmail: currentUser?.email,
      );

      // On envoie à Supabase
      await ref.read(reservationsProvider.notifier).createReservation(reservation);

      // On nettoie le panier
      ref.read(bookingProvider.notifier).reset();

      // 5. On affiche le message de succès
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réservation enregistrée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/reservations');
      }
    } catch (error) {
      // Si Supabase échoue, on prévient l'utilisateur mais WhatsApp est déjà ouvert
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de sauvegarde : $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
