import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/local_storage_service.dart';
import '../shared/models/invoice_model.dart';

const _devisStorageKey = 'devis';

final devisProvider = NotifierProvider<DevisNotifier, List<InvoiceModel>>(
  DevisNotifier.new,
);

class DevisNotifier extends Notifier<List<InvoiceModel>> {
  late LocalStorageService _storage;

  @override
  List<InvoiceModel> build() {
    _storage = ref.read(localStorageServiceProvider);
    return List.unmodifiable(
      _storage.readList(_devisStorageKey, InvoiceModel.fromJson),
    );
  }

  Future<void> addDevis(InvoiceModel devis) async {
    if (devis.type != DocumentType.devis) {
      throw ArgumentError('Le document ajouté doit être un devis.');
    }
    if (state.any((item) => item.id == devis.id)) {
      throw StateError('Un devis avec cet identifiant existe déjà.');
    }
    await _save([...state, devis]);
  }

  Future<void> updateStatus(String id, DevisStatus status) async {
    final index = state.indexWhere((devis) => devis.id == id);
    if (index < 0) throw StateError('Devis introuvable.');
    final updated = [...state];
    updated[index] = updated[index].copyWith(devisStatus: status);
    await _save(updated);
  }

  Future<void> _save(List<InvoiceModel> devis) async {
    await _storage.saveList(
      _devisStorageKey,
      devis,
      (document) => document.toJson(),
    );
    state = List.unmodifiable(devis);
  }
}

final pendingDevisProvider = Provider<List<InvoiceModel>>((ref) {
  final all = ref.watch(devisProvider);
  return all
      .where((devis) => devis.devisStatus == DevisStatus.pending)
      .toList();
});
