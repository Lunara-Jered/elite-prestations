import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/supabase_service.dart';
import '../shared/models/invoice_model.dart';
import 'devis_provider.dart';

final invoicesProvider =
    AsyncNotifierProvider<InvoicesNotifier, List<InvoiceModel>>(
  InvoicesNotifier.new,
);

class InvoicesNotifier extends AsyncNotifier<List<InvoiceModel>> {
  @override
  Future<List<InvoiceModel>> build() async {
    final data = await SupabaseService.client
        .from('invoices')
        .select()
        .order('created_at', ascending: false);
    return data
        .map((json) => InvoiceModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<void> addInvoice(InvoiceModel invoice) async {
    if (invoice.type != DocumentType.facture) {
      throw ArgumentError('Le document ajouté doit être une facture.');
    }
    if ((state.value ?? const []).any((item) => item.id == invoice.id)) {
      throw StateError('Une facture avec cet identifiant existe déjà.');
    }
    try {
      final row = await SupabaseService.client
          .from('invoices')
          .insert(invoice.toSupabaseJson(
            userId: SupabaseService.client.auth.currentUser?.id,
          ))
          .select()
          .single();
      final created =
          InvoiceModel.fromJson(Map<String, dynamic>.from(row));
      state = AsyncData([...state.value ?? const [], created]);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateStatus(String id, InvoiceStatus status) async {
    final invoices = state.value ?? const [];
    final index = invoices.indexWhere((invoice) => invoice.id == id);
    if (index < 0) throw StateError('Facture introuvable.');
    try {
      await SupabaseService.client
          .from('invoices')
          .update({'invoice_status': status.name})
          .eq('id', id);
      final updated = [...invoices];
      updated[index] = updated[index].copyWith(invoiceStatus: status);
      state = AsyncData(updated);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> removeInvoice(String id) async {
    if (!(state.value ?? const []).any((invoice) => invoice.id == id)) return;
    try {
      await SupabaseService.client.from('invoices').delete().eq('id', id);
      state = AsyncData(
        (state.value ?? const [])
            .where((invoice) => invoice.id != id)
            .toList(),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final unpaidInvoicesProvider = Provider<List<InvoiceModel>>((ref) {
  final all = ref.watch(invoicesProvider).value ?? const [];
  return all
      .where((invoice) =>
          invoice.invoiceStatus == InvoiceStatus.unpaid ||
          invoice.invoiceStatus == InvoiceStatus.partial)
      .toList();
});

final invoicesStatsProvider = Provider<Map<String, int>>((ref) {
  final invoices = ref.watch(invoicesProvider).value ?? const [];
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
