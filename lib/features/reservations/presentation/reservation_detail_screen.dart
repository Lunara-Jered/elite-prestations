import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency.dart';
import '../../../providers/reservations_provider.dart';
import '../../../shared/models/reservation_model.dart';
import '../../../shared/widgets/status_badge.dart';

class ReservationDetailScreen extends ConsumerWidget {
  final String reservationId;
  const ReservationDetailScreen({super.key, required this.reservationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservations = ref.watch(reservationsProvider);
    final reservation = reservations.firstWhere(
      (r) => r.id == reservationId,
      orElse: () => reservations.first,
    );
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/reservations'),
        ),
        title: const Text('Détail réservation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ─────────────────────────────────
            // HEADER : référence + statut
            // ─────────────────────────────────
            Row(
              children: [
                Text(
                  reservation.reference,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                StatusBadge(status: reservation.status),
              ],
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────
            // SERVICE
            // ─────────────────────────────────
            _DetailCard(
              icon: Icons.room_service_outlined,
              title: 'Prestation',
              child: Text(
                reservation.serviceName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const SizedBox(height: 12),

            // ─────────────────────────────────
            // DATES
            // ─────────────────────────────────
            _DetailCard(
              icon: Icons.event,
              title: 'Dates',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatRange(reservation.startDate, reservation.duration),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${reservation.duration} jour${reservation.duration > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ─────────────────────────────────
            // PRIX
            // ─────────────────────────────────
            _DetailCard(
              icon: Icons.payments_outlined,
              title: 'Montant',
              child: Column(
                children: [
                  _PriceRow(
                    label: 'Total TTC',
                    amount: reservation.totalTTC,
                  ),
                  const SizedBox(height: 8),
                  _PriceRow(
                    label: 'Acompte payé',
                    amount: reservation.deposit,
                  ),
                  const Divider(height: 24),
                  _PriceRow(
                    label: 'Reste à payer',
                    amount: reservation.totalTTC - reservation.deposit,
                    bold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────
            // ACTIONS
            // ─────────────────────────────────
            if (reservation.status != ReservationStatus.cancelled &&
                reservation.status != ReservationStatus.completed) ...[
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: télécharger facture
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Téléchargement bientôt')),
                  );
                },
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('Télécharger la facture'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(AppStrings.whatsappLink);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri,
                        mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: const Text('Contacter par WhatsApp'),
              ),
              const SizedBox(height: 12),
              if (reservation.status == ReservationStatus.pending)
                TextButton(
                  onPressed: () => _confirmCancel(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                  child: const Text('Annuler la réservation'),
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatRange(DateTime start, int days) {
    final end = start.add(Duration(days: days - 1));
    final fmt = DateFormat('dd MMMM yyyy', 'fr_FR');
    if (days == 1) return fmt.format(start);
    return 'Du ${fmt.format(start)} au ${fmt.format(end)}';
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la réservation ?'),
        content: const Text(
          'Cette action est irréversible. Vous serez contacté pour le remboursement éventuel.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non, garder'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: appel Supabase pour annuler
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Réservation annulée')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────
class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? AppColors.surface : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLight ? AppColors.border : AppColors.borderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final int amount;
  final bool bold;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 15 : 14,
          ),
        ),
        Text(
          formatFCFA(amount),
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 15 : 14,
          ),
        ),
      ],
    );
  }
}
