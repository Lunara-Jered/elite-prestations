import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../providers/invoices_provider.dart';
import '../../../providers/reservations_provider.dart';
import '../../../shared/models/reservation_model.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(invoicesStatsProvider);
    // On utilise le provider global des réservations
    final reservationsAsync = ref.watch(reservationsProvider);
    final invoices = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de bord')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ─────────────────────────────────
            // KPIs PRINCIPAUX
            // ─────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    value: formatFCFA(stats['totalCA'] ?? 0),
                    label: 'Chiffre d\'affaires',
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KpiCard(
                    value: formatFCFA(stats['pendingAmount'] ?? 0),
                    label: 'En attente',
                    icon: Icons.schedule,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // ─────────────────────────────────
            // COMPTEURS
            // ─────────────────────────────────
            reservationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erreur: $err')),
              data: (reservations) {
                // On filtre les réservations actives
                final activeCount = reservations.where((r) => 
                  r.status == ReservationStatus.pending || 
                  r.status == ReservationStatus.confirmed || 
                  r.status == ReservationStatus.inProgress
                ).length;

                return Row(
                  children: [
                    Expanded(
                      child: _KpiCard(
                        value: '$activeCount',
                        label: 'Réservations actives',
                        icon: Icons.event_available,
                        small: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _KpiCard(
                        value: '${stats['invoiceCount'] ?? 0}',
                        label: 'Factures',
                        icon: Icons.receipt_long,
                        small: true,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // ─────────────────────────────────
            // DERNIÈRES RÉSERVATIONS
            // ─────────────────────────────────
            Text(
              'Réservations en cours',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),

            reservationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erreur: $err')),
              data: (reservations) {
                // On garde uniquement les réservations actives
                final activeReservations = reservations.where((r) => 
                  r.status == ReservationStatus.pending || 
                  r.status == ReservationStatus.confirmed || 
                  r.status == ReservationStatus.inProgress
                ).toList();

                if (activeReservations.isEmpty) {
                  return _EmptyCard(text: 'Aucune réservation active');
                }

                return Column(
                  children: activeReservations.take(3).map(
                    (r) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event, size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.serviceName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${r.reference} • ${formatFCFA(r.totalTTC)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).toList(),
                );
              },
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────
            // DERNIÈRES FACTURES
            // ─────────────────────────────────
            Text(
              'Dernières factures',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),

            if (invoices.isEmpty)
              _EmptyCard(text: 'Aucune facture')
            else
              ...invoices.take(3).map(
                    (inv) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.receipt_long, size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  inv.number,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${inv.clientName} • ${formatFCFA(inv.totalTTC)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

            const SizedBox(height: 24),

            // ─────────────────────────────────
            // ACTIONS RAPIDES
            // ─────────────────────────────────
            Text(
              'Actions rapides',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.receipt_long,
                    label: 'Factures',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.description_outlined,
                    label: 'Devis',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// HELPERS (inchangés)
// ─────────────────────────────────────────
class _KpiCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool small;

  const _KpiCard({
    required this.value,
    required this.label,
    required this.icon,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.blackGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.white.withValues(alpha: 0.7),
            size: 20,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: AppColors.white,
              fontSize: small ? 20 : 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.gray300,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String text;
  const _EmptyCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
