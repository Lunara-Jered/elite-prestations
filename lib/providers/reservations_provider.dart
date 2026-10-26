import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../core/services/supabase_service.dart';
import '../shared/models/reservation_model.dart';
import 'auth_provider.dart';

final deviceIdProvider = FutureProvider<String>((ref) async {
  const preferenceKey = 'reservation_device_id';
  final preferences = await SharedPreferences.getInstance();
  final savedDeviceId = preferences.getString(preferenceKey);
  if (savedDeviceId != null && savedDeviceId.isNotEmpty) return savedDeviceId;

  final deviceId = Uuid().v4();
  await preferences.setString(preferenceKey, deviceId);
  return deviceId;
});

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
        final deviceId = await ref.watch(deviceIdProvider.future);
      
      final data = isLocalAdmin
          ? await client.from('reservations').select().order(
                'created_at',
                ascending: false,
              )
          : await client
              .from('reservations')
              .select()
              .eq('client_id', deviceId)
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

  Future<ReservationModel> createReservation(
    ReservationModel reservation,
  ) async {
    try {
      final deviceId = await ref.read(deviceIdProvider.future);
      final row = await SupabaseService.client
          .from('reservations')
          .insert(reservation.toSupabaseJson(clientId: deviceId))
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
  if (!SupabaseConfig.isConfigured) return const AsyncData([]);
  final deviceId = ref.watch(deviceIdProvider);
  final all = ref.watch(reservationsProvider);
  return deviceId.when(
    data: (id) => all.whenData((list) =>
        list.where((reservation) => reservation.clientId == id).toList()),
    loading: () => const AsyncLoading(),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
  );
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
