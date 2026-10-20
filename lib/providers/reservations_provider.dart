import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/local_storage_service.dart';
import '../shared/models/reservation_model.dart';
import 'auth_provider.dart';

const _reservationsStorageKey = 'reservations';

final reservationsProvider =
    NotifierProvider<ReservationsNotifier, List<ReservationModel>>(
  ReservationsNotifier.new,
);

class ReservationsNotifier extends Notifier<List<ReservationModel>> {
  late LocalStorageService _storage;

  @override
  List<ReservationModel> build() {
    _storage = ref.read(localStorageServiceProvider);
    return List.unmodifiable(
      _storage.readList(_reservationsStorageKey, ReservationModel.fromJson),
    );
  }

  Future<void> addReservation(ReservationModel reservation) async {
    if (state.any((item) => item.id == reservation.id)) {
      throw StateError('Une réservation avec cet identifiant existe déjà.');
    }
    await _save([...state, reservation]);
  }

  Future<void> updateStatus(String id, ReservationStatus status) async {
    final index = state.indexWhere((reservation) => reservation.id == id);
    if (index < 0) throw StateError('Réservation introuvable.');
    final updated = [...state];
    updated[index] = updated[index].copyWith(status: status);
    await _save(updated);
  }

  Future<void> updateReservation(ReservationModel reservation) async {
    final index = state.indexWhere((item) => item.id == reservation.id);
    if (index < 0) throw StateError('Réservation introuvable.');
    final updated = [...state];
    updated[index] = reservation;
    await _save(updated);
  }

  Future<void> removeReservation(String id) async {
    if (!state.any((reservation) => reservation.id == id)) return;
    await _save(
      state.where((reservation) => reservation.id != id).toList(),
    );
  }

  Future<void> _save(List<ReservationModel> reservations) async {
    await _storage.saveList(
      _reservationsStorageKey,
      reservations,
      (reservation) => reservation.toJson(),
    );
    state = List.unmodifiable(reservations);
  }
}

final activeReservationsProvider = Provider<List<ReservationModel>>((ref) {
  final all = ref.watch(reservationsProvider);
  return all
      .where((reservation) =>
          reservation.status == ReservationStatus.pending ||
          reservation.status == ReservationStatus.confirmed ||
          reservation.status == ReservationStatus.inProgress)
      .toList();
});

final myReservationsProvider = Provider<List<ReservationModel>>((ref) {
  final email = ref.watch(authProvider.select((state) => state.user?.email));
  return ref
      .watch(reservationsProvider)
      .where((reservation) => reservation.clientEmail == email)
      .toList();
});

final myActiveReservationsProvider = Provider<List<ReservationModel>>((ref) {
  return ref.watch(myReservationsProvider).where((reservation) =>
      reservation.status == ReservationStatus.pending ||
      reservation.status == ReservationStatus.confirmed ||
      reservation.status == ReservationStatus.inProgress).toList();
});

final myPastReservationsProvider = Provider<List<ReservationModel>>((ref) {
  return ref
      .watch(myReservationsProvider)
      .where((reservation) => reservation.status == ReservationStatus.completed)
      .toList();
});

final myCancelledReservationsProvider = Provider<List<ReservationModel>>((ref) {
  return ref
      .watch(myReservationsProvider)
      .where((reservation) => reservation.status == ReservationStatus.cancelled)
      .toList();
});

final pastReservationsProvider = Provider<List<ReservationModel>>((ref) {
  final all = ref.watch(reservationsProvider);
  return all
      .where((reservation) => reservation.status == ReservationStatus.completed)
      .toList();
});

final cancelledReservationsProvider = Provider<List<ReservationModel>>((ref) {
  final all = ref.watch(reservationsProvider);
  return all
      .where((reservation) => reservation.status == ReservationStatus.cancelled)
      .toList();
});
