import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency.dart';
import '../../../../shared/models/reservation_model.dart';
import '../../../../shared/widgets/status_badge.dart';

class ReservationCard extends StatelessWidget {
  final ReservationModel reservation;
  final VoidCallback onTap;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final dateFmt = DateFormat('dd MMM yyyy', 'fr_FR');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isLight ? AppColors.surface : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLight ? AppColors.border : AppColors.borderDark,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────
            // HEADER : référence + statut
            // ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    reservation.reference,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const Spacer(),
                  StatusBadge(status: reservation.status),
                ],
              ),
            ),

            // ─────────────────────────────────
            // BODY : service + date + prix
            // ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du service
                  Text(
                    reservation.serviceName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),

                  // Date
                  Row(
                    children: [
                      const Icon(Icons.event,
                          size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Text(
                        _formatRange(
                          reservation.startDate,
                          reservation.duration,
                        ),
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Prix
                  Row(
                    children: [
                      const Icon(Icons.payments_outlined,
                          size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Text(
                        formatFCFA(reservation.totalTTC),
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Boutons d'action
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: télécharger facture PDF
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 40),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Facture'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 40),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Détails'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatRange(DateTime start, int days) {
    final end = start.add(Duration(days: days - 1));
    final fmt = DateFormat('dd/MM/yyyy');
    if (days == 1) return fmt.format(start);
    return 'Du ${fmt.format(start)} au ${fmt.format(end)}';
  }
}
