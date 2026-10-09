import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/booking/providers/booking_provider.dart';
import '../shared/models/reservation_model.dart';

/// Provider des réservations (mockées pour l'instant)
final reservationsProvider = Provider<List<ReservationModel>>((ref) {
  final now = DateTime.now();

  return [
    ReservationModel(
      id: 'res-001',
      reference: 'RES-2026-0042',
      serviceName: 'Location de Salle Événementielle',
      startDate: now.add(const Duration(days: 7)),
      endDate: now.add(const Duration(days: 9)),
      duration: 3,
      totalTTC: 885000, // 750 000 HT + 135 000 TVA
      deposit: 442500,
      status: ReservationStatus.confirmed,
      options: const [
        BookingOption(
          id: 'traiteur',
          name: 'Service Traiteur',
          iconName: 'restaurant',
          unitPrice: 15000,
          perPerson: true,
          quantity: 0,
        ),
      ],
      createdAt: now.subtract(const Duration(days: 3)),
    ),
    ReservationModel(
      id: 'res-002',
      reference: 'RES-2026-0039',
      serviceName: 'Organisation de Mariages',
      startDate: now.add(const Duration(days: 60)),
      endDate: now.add(const Duration(days: 60)),
      duration: 1,
      totalTTC: 1770000, // 1 500 000 HT + 270 000 TVA
      deposit: 885000,
      status: ReservationStatus.pending,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    ReservationModel(
      id: 'res-003',
      reference: 'RES-2026-0031',
      serviceName: 'Appartement Meublé',
      startDate: now.subtract(const Duration(days: 30)),
      endDate: now.subtract(const Duration(days: 28)),
      duration: 3,
      totalTTC: 123900, // 105 000 HT + 18 900 TVA
      deposit: 61950,
      status: ReservationStatus.completed,
      createdAt: now.subtract(const Duration(days: 45)),
    ),
    ReservationModel(
      id: 'res-004',
      reference: 'RES-2026-0025',
      serviceName: 'Service de Nettoyage',
      startDate: now.subtract(const Duration(days: 15)),
      endDate: now.subtract(const Duration(days: 15)),
      duration: 1,
      totalTTC: 59000, // 50 000 HT + 9 000 TVA
      deposit: 29500,
      status: ReservationStatus.cancelled,
      createdAt: now.subtract(const Duration(days: 20)),
    ),
  ];
});

/// Réservations en cours (pending + confirmed + inProgress)
final activeReservationsProvider = Provider<List<ReservationModel>>((ref) {
  final all = ref.watch(reservationsProvider);
  return all.where((r) =>
      r.status == ReservationStatus.pending ||
      r.status == ReservationStatus.confirmed ||
      r.status == ReservationStatus.inProgress).toList();
});

/// Réservations passées (completed)
final pastReservationsProvider = Provider<List<ReservationModel>>((ref) {
  final all = ref.watch(reservationsProvider);
  return all.where((r) => r.status == ReservationStatus.completed).toList();
});

/// Réservations annulées (cancelled)
final cancelledReservationsProvider = Provider<List<ReservationModel>>((ref) {
  final all = ref.watch(reservationsProvider);
  return all.where((r) => r.status == ReservationStatus.cancelled).toList();
});
