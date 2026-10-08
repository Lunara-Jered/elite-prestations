// TODO: Define the reservation model.
import '../../features/booking/providers/booking_provider.dart';

/// Statuts possibles d'une réservation
enum ReservationStatus {
  pending,     // 🟡 En attente
  confirmed,   // 🟢 Confirmée
  inProgress,  // 🔵 En cours
  completed,   // ⚪ Terminée
  cancelled,   // 🔴 Annulée
}

/// Modèle d'une réservation
class ReservationModel {
  final String id;
  final String reference;    // "RES-2026-0001"
  final String serviceName;
  final DateTime startDate;
  final DateTime endDate;
  final int duration;
  final int totalTTC;
  final int deposit;
  final ReservationStatus status;
  final List<BookingOption> options;
  final DateTime createdAt;

  const ReservationModel({
    required this.id,
    required this.reference,
    required this.serviceName,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.totalTTC,
    required this.deposit,
    required this.status,
    this.options = const [],
    required this.createdAt,
  });
}
