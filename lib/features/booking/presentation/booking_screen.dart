import 'dart:async';

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
        const SnackBar(content: Text('Les informations de réservation sont incomplètes.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final now = DateTime.now();
    final id = now.microsecondsSinceEpoch.toString();
    final currentUser = ref.read(authProvider).user;
    final clientName = currentUser?.name ?? 'Client invité';
    final endDate = widget.booking.endDate ??
        startDate.add(Duration(days: widget.booking.duration - 1));
    final serviceQuantity =
        service.unit == 'jour' || service.unit == 'nuit'
            ? widget.booking.duration
            : 1;
    final lines = <InvoiceLine>[
      InvoiceLine.create(
        description: service.name,
        quantity: serviceQuantity.toDouble(),
        unitPrice: service.basePrice,
        tpsRate: CompanyInfo.tpsRate,
      ),
      ...widget.booking.options.where((option) => option.quantity > 0).map(
            (option) => InvoiceLine.create(
              description: option.name,
              quantity: option.quantity.toDouble(),
              unitPrice: option.unitPrice,
              tpsRate: CompanyInfo.tpsRate,
            ),
          ),
    ];
    final reservation = ReservationModel(
      id: id,
      reference:
          'RES-${now.year}-${id.substring(id.length - 6).padLeft(6, '0')}',
      serviceName: service.name,
      startDate: startDate,
      endDate: endDate,
      duration: widget.booking.duration,
      totalTTC: widget.booking.totalTTC,
      deposit: widget.booking.deposit,
      status: ReservationStatus.pending,
      options: widget.booking.options,
      createdAt: now,
      clientId: currentUser?.id,
      clientName: clientName,
      clientEmail: currentUser?.email,
    );
    final invoice = InvoiceModel(
      id: 'INV-$id',
      number:
          'FACT-${now.year}${now.month.toString().padLeft(2, '0')}-${id.substring(id.length - 6)}',
      type: DocumentType.facture,
      clientName: clientName,
      clientEmail: currentUser?.email,
      clientPhone: currentUser?.phone,
      issueDate: now,
      dueDate: now.add(const Duration(days: 30)),
      lines: lines,
      subtotalHT: widget.booking.subtotalHT,
      tps: widget.booking.tps,
      totalTTC: widget.booking.totalTTC,
      invoiceStatus: widget.booking.deposit >= widget.booking.totalTTC
          ? InvoiceStatus.paid
          : InvoiceStatus.partial,
      notes: 'Acompte : ${widget.booking.deposit} FCFA',
      createdAt: now,
    );

    ReservationModel? savedReservation;
    var invoiceSaved = false;
    try {
      final createdReservation = await ref
          .read(reservationsProvider.notifier)
          .createReservation(reservation)
          .timeout(const Duration(seconds: 5));
      savedReservation = createdReservation;
      await ref.read(invoicesProvider.notifier).addInvoice(invoice);
      invoiceSaved = true;
      ref.read(bookingProvider.notifier).reset();
      if (!context.mounted) return;

      final whatsappError =
          await _sendReservationWhatsApp(createdReservation);

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(Icons.check_circle_outline),
          title: const Text('Réservation enregistrée'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Votre réservation ${createdReservation.reference} est enregistrée. '
                'La facture ${invoice.number} est disponible dans votre espace.',
              ),
              const SizedBox(height: 8),
              Text(
                whatsappError == null
                    ? 'WhatsApp est ouvert avec le récapitulatif. Appuyez sur Envoyer pour transmettre le message.'
                    : 'La réservation est enregistrée, mais WhatsApp n’a pas pu être ouvert : $whatsappError',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Voir mes réservations'),
            ),
          ],
        ),
      );
      if (context.mounted) context.go('/reservations');
    } on TimeoutException {
      final whatsappError = await _sendReservationWhatsApp(reservation);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              whatsappError == null
                  ? 'La demande a été envoyée sur WhatsApp. Elle sera synchronisée lorsque la connexion sera rétablie.'
                  : 'Le délai Supabase est dépassé et WhatsApp n’a pas pu être ouvert : $whatsappError',
            ),
            duration: const Duration(seconds: 6),
          ),
        );
      }
    } catch (error) {
      Object reportedError = error;
      if (savedReservation != null && !invoiceSaved) {
        try {
          await ref
              .read(reservationsProvider.notifier)
              .removeReservation(savedReservation.id);
        } catch (cleanupError) {
          reportedError = StateError(
            '$error. Le nettoyage de la réservation a également échoué : $cleanupError',
          );
        }
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Impossible de confirmer la réservation : $reportedError',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<String?> _sendReservationWhatsApp(
    ReservationModel reservation,
  ) async {
    try {
      await WhatsAppService.sendReservationNotification(
        AppStrings.whatsapp,
        '${reservation.reference} - ${reservation.serviceName}, '
        'du ${reservation.startDate.toLocal().toString().split(' ').first} '
        'au ${reservation.endDate.toLocal().toString().split(' ').first}, '
        'total ${reservation.totalTTC} FCFA, acompte '
        '${reservation.deposit} FCFA.',
      );
      return null;
    } catch (error) {
      return error.toString();
    }
  }
}
