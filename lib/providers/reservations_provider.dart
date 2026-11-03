import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../core/services/supabase_service.dart';
import '../shared/models/reservation_model.dart';

final reservationsProvider =
    AsyncNotifierProvider<ReservationsNotifier, List<ReservationModel>>(
  ReservationsNotifier.new,
);

class ReservationsNotifier extends AsyncNotifier<List<ReservationModel>> {
  // Méthode utilitaire pour récupérer l'ID unique du téléphone
  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await prefs.setString('device_id', deviceId);
    }
    return deviceId;
  }

  @override
  Future<List<ReservationModel>> build() async {
    try {
      final client = SupabaseService.client;
      final deviceId = await _getDeviceId();

      // On récupère les réservations de CE téléphone
      final data = await client
          .from('reservations')
          .select()
          .eq('client_id', deviceId) // <-- Filtrage par device_id
          .order('created_at', ascending: false);

      return data
          .map((json) =>
              ReservationModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<ReservationModel> createReservation(ReservationModel reservation) async {
    try {
      final client = SupabaseService.client;
      final deviceId = await _getDeviceId();

      // On insère avec le client_id (et non user_id)
      final row = await client
          .from('reservations')
          .insert({
            'client_id': deviceId,
            'service_name': reservation.serviceName,
            'start_date': reservation.startDate.toIso8601String().split('T')[0],
            'duration': reservation.duration,
            'total_ttc': reservation.totalTTC,
            'status': reservation.status.name,
          })
          .select()
          .single();

      final created = ReservationModel.fromJson(Map<String, dynamic>.from(row));
      state = AsyncData([...state.value ?? const [], created]);
      return created;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateStatus(String id, ReservationStatus status) async {
    try {
      await SupabaseService.client
          .from('reservations')
          .update({'status': status.name})
          .eq('id', id);
      final reservations = state.value ?? const [];
      state = AsyncData([
        for (final reservation in reservations)
          if (reservation.id == id)
            reservation.copyWith(status: status)
          else
            reservation,
      ]);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> removeReservation(String id) async {
    try {
      await SupabaseService.client.from('reservations').delete().eq('id', id);
      state = AsyncData(
        (state.value ?? const [])
            .where((reservation) => reservation.id != id)
            .toList(),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

// ─────────────────────────────────────────
// PROVIDERS DÉRIVÉS (Pour l'interface)
// ─────────────────────────────────────────

final myReservationsProvider = Provider<AsyncValue<List<ReservationModel>>>((ref) {
  final all = ref.watch(reservationsProvider);
  return all.whenData((list) {
    // Puisqu'on filtre déjà par client_id dans Supabase, on retourne tout
    return list;
  });
});

final myActiveReservationsProvider = Provider<AsyncValue<List<ReservationModel>>>((ref) {
  final all = ref.watch(myReservationsProvider);
  return all.whenData((list) => list.where((r) =>
      r.status == ReservationStatus.pending ||
      r.status == ReservationStatus.confirmed ||
      r.status == ReservationStatus.inProgress).toList());
});

final myPastReservationsProvider = Provider<AsyncValue<List<ReservationModel>>>((ref) {
  final all = ref.watch(myReservationsProvider);
  return all.whenData((list) => list.where((r) => r.status == ReservationStatus.completed).toList());
});

final myCancelledReservationsProvider = Provider<AsyncValue<List<ReservationModel>>>((ref) {
  final all = ref.watch(myReservationsProvider);
  return all.whenData((list) => list.where((r) => r.status == ReservationStatus.cancelled).toList());
});
