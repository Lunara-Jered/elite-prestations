import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/local_storage_service.dart';
import '../shared/models/invoice_model.dart';

const _invoicesStorageKey = 'invoices';
const _devisStorageKey = 'devis';

final invoicesProvider =
    NotifierProvider<InvoicesNotifier, List<InvoiceModel>>(
  InvoicesNotifier.new,
);

class InvoicesNotifier extends Notifier<List<InvoiceModel>> {
  late LocalStorageService _storage;

  @override
  List<InvoiceModel> build() {
    _storage = ref.read(localStorageServiceProvider);
    return List.unmodifiable(
      _storage.readList(_invoicesStorageKey, InvoiceModel.fromJson),
    );
  }

  Future<void> addInvoice(InvoiceModel invoice) async {
    if (invoice.type != DocumentType.facture) {
      throw ArgumentError('Le document ajouté doit être une facture.');
    }
    if (state.any((item) => item.id == invoice.id)) {
      throw StateError('Une facture avec cet identifiant existe déjà.');
    }
    await _save([...state, invoice]);
  }

  Future<void> updateStatus(String id, InvoiceStatus status) async {
    final index = state.indexWhere((invoice) => invoice.id == id);
    if (index < 0) throw StateError('Facture introuvable.');
    final updated = [...state];
    updated[index] = updated[index].copyWith(invoiceStatus: status);
    await _save(updated);
  }

  Future<void> removeInvoice(String id) async {
    if (!state.any((invoice) => invoice.id == id)) return;
    await _save(state.where((invoice) => invoice.id != id).toList());
  }

  Future<void> _save(List<InvoiceModel> invoices) async {
    await _storage.saveList(
      _invoicesStorageKey,
      invoices,
      (invoice) => invoice.toJson(),
    );
    state = List.unmodifiable(invoices);
  }
}

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

final unpaidInvoicesProvider = Provider<List<InvoiceModel>>((ref) {
  final all = ref.watch(invoicesProvider);
  return all
      .where((invoice) =>
          invoice.invoiceStatus == InvoiceStatus.unpaid ||
          invoice.invoiceStatus == InvoiceStatus.partial)
      .toList();
});

final pendingDevisProvider = Provider<List<InvoiceModel>>((ref) {
  final all = ref.watch(devisProvider);
  return all
      .where((devis) => devis.devisStatus == DevisStatus.pending)
      .toList();
});

final invoicesStatsProvider = Provider<Map<String, int>>((ref) {
  final invoices = ref.watch(invoicesProvider);
  final devis = ref.watch(devisProvider);
  final totalCA = invoices
      .where((invoice) => invoice.invoiceStatus == InvoiceStatus.paid)
      .fold(0, (sum, invoice) => sum + invoice.totalTTC);
  final pendingAmount = invoices
      .where((invoice) =>
          invoice.invoiceStatus == InvoiceStatus.unpaid ||
          invoice.invoiceStatus == InvoiceStatus.partial)
      .fold(0, (sum, invoice) => sum + invoice.totalTTC);

  return {
    'totalCA': totalCA,
    'pendingAmount': pendingAmount,
    'invoiceCount': invoices.length,
    'devisCount': devis.length,
  };
});
