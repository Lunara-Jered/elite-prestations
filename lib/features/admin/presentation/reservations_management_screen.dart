import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency.dart';
import '../../../providers/reservations_provider.dart';
import '../../../shared/models/reservation_model.dart';

class ReservationsManagementScreen extends ConsumerWidget {
  const ReservationsManagementScreen({super.key});

  static const _statusLabels = {
    ReservationStatus.pending: 'En attente',
    ReservationStatus.confirmed: 'Confirmée',
    ReservationStatus.inProgress: 'En cours',
    ReservationStatus.completed: 'Terminée',
    ReservationStatus.cancelled: 'Annulée',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservations = ref.watch(reservationsProvider);
    if (reservations.isEmpty) {
      return const Center(child: Text('Aucune réservation enregistrée.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation.serviceName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text('${reservation.reference} • ${formatFCFA(reservation.totalTTC)}'),
                if (reservation.clientName != null) ...[
                  const SizedBox(height: 4),
                  Text('Client : ${reservation.clientName}'),
                ],
                const SizedBox(height: 12),
                DropdownButtonFormField<ReservationStatus>(
                  initialValue: reservation.status,
                  decoration: const InputDecoration(
                    labelText: 'Statut',
                    border: OutlineInputBorder(),
                  ),
                  items: ReservationStatus.values
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(_statusLabels[status]!),
                        ),
                      )
                      .toList(),
                  onChanged: (status) async {
                    if (status == null || status == reservation.status) return;
                    try {
                      await ref
                          .read(reservationsProvider.notifier)
                          .updateStatus(reservation.id, status);
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Impossible de modifier le statut : $error'),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
