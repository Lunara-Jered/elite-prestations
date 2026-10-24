import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/supabase_service.dart';
import '../shared/models/reservation_model.dart';
import 'auth_provider.dart';

final reservationsProvider =
    AsyncNotifierProvider<ReservationsNotifier, List<ReservationModel>>(
  ReservationsNotifier.new,
);

class ReservationsNotifier extends AsyncNotifier<List<ReservationModel>> {
  @override
  Future<List<ReservationModel>> build() async {
    try {
      final client = SupabaseService.client;
      final isLocalAdmin =
          ref.watch(authProvider.select((auth) => auth.user?.role == 'ADMIN'));
      final userId = client.auth.currentUser?.id;
      
      final data = isLocalAdmin
          ? await client.from('reservations').select().order(
                'created_at',
                ascending: false,
              )
          : await client
              .from('reservations')
              .select()
              .eq('user_id', userId ?? '')
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

  Future<List<ReservationModel>> getUserReservations() async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) {
        throw StateError(
          'Connectez-vous avec Supabase pour consulter vos réservations.',
        );
      }
      final data = await SupabaseService.client
          .from('reservations')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      final reservations = data
          .map((json) =>
              ReservationModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      state = AsyncData(reservations);
      return reservations;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<ReservationModel> createReservation(
    ReservationModel reservation,
  ) async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      final row = await SupabaseService.client
          .from('reservations')
          .insert(reservation.toSupabaseJson(userId: userId))
          .select()
          .single();
      final created = ReservationModel.fromJson(
        Map<String, dynamic>.from(row),
      );
      state = AsyncData([...state.value ?? const [], created]);
      return created;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> addReservation(ReservationModel reservation) async {
    await createReservation(reservation);
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

  Future<void> updateReservation(ReservationModel reservation) async {
    try {
      await SupabaseService.client
          .from('reservations')
          .update(reservation.toSupabaseJson(
            userId: SupabaseService.client.auth.currentUser?.id,
          ))
          .eq('id', reservation.id);
      final reservations = state.value ?? const [];
      state = AsyncData([
        for (final item in reservations)
          if (item.id == reservation.id) reservation else item,
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

final activeReservationsProvider = Provider<AsyncValue<List<ReservationModel>>>((ref) {
  final all = ref.watch(reservationsProvider);
  return all.whenData((list) => list.where((r) =>
      r.status == ReservationStatus.pending ||
      r.status == ReservationStatus.confirmed ||
      r.status == ReservationStatus.inProgress).toList());
});

final pastReservationsProvider = Provider<AsyncValue<List<ReservationModel>>>((ref) {
  final all = ref.watch(reservationsProvider);
  return all.whenData((list) => list.where((r) => r.status == ReservationStatus.completed).toList());
});

final cancelledReservationsProvider = Provider<AsyncValue<List<ReservationModel>>>((ref) {
  final all = ref.watch(reservationsProvider);
  return all.whenData((list) => list.where((r) => r.status == ReservationStatus.cancelled).toList());
});

// Réservations de l'utilisateur connecté
final myReservationsProvider = Provider<AsyncValue<List<ReservationModel>>>((ref) {
  if (!SupabaseConfig.isConfigured) return const AsyncData([]);
  final userId = SupabaseService.client.auth.currentUser?.id;
  if (userId == null) return const AsyncData([]);
  
  final all = ref.watch(reservationsProvider);
  return all.whenData((list) => 
      list.where((r) => r.clientId == userId).toList());
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
