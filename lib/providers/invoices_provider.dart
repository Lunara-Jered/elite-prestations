// TODO: Implement invoice state and data access.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/company_info.dart';
import '../shared/models/invoice_model.dart';

/// Liste des factures (mockées pour l'instant)
final invoicesProvider = Provider<List<InvoiceModel>>((ref) {
  final now = DateTime.now();

  return [
    InvoiceModel(
      id: 'inv-001',
      number: 'FACT-${now.year}${now.month.toString().padLeft(2, '0')}-001',
      type: DocumentType.facture,
      clientName: 'M. Jean MBADINGA',
      clientNif: '123456B',
      clientAddress: 'Quartier Louis, Libreville',
      clientPhone: '+241 66 12 34 56',
      issueDate: now.subtract(const Duration(days: 5)),
      dueDate: now.add(const Duration(days: 25)),
      lines: [
        InvoiceLine.create(
          description: 'Location Salle Événementielle (3 jours)',
          quantity: 3,
          unitPrice: 250000,
          tpsRate: CompanyInfo.tpsRate,
        ),
        InvoiceLine.create(
          description: 'Service Traiteur (100 personnes)',
          quantity: 100,
          unitPrice: 15000,
          tpsRate: CompanyInfo.tpsRate,
        ),
      ],
      subtotalHT: 2250000,
      tps: 213750,
      totalTTC: 2463750,
      invoiceStatus: InvoiceStatus.partial,
      notes: 'Acompte de 1 231 875 FCFA reçu',
      createdAt: now.subtract(const Duration(days: 5)),
    ),
    InvoiceModel(
      id: 'inv-002',
      number: 'FACT-${now.year}${now.month.toString().padLeft(2, '0')}-002',
      type: DocumentType.facture,
      clientName: 'SARL GABON EVENTS',
      clientNif: '789456C',
      clientAddress: 'Zone Industrielle, Libreville',
      issueDate: now.subtract(const Duration(days: 15)),
      dueDate: now.add(const Duration(days: 15)),
      lines: [
        InvoiceLine.create(
          description: 'Service de Nettoyage professionnel',
          quantity: 1,
          unitPrice: 50000,
          tpsRate: CompanyInfo.tpsRate,
        ),
        InvoiceLine.create(
          description: 'Transport invités',
          quantity: 2,
          unitPrice: 250000,
          tpsRate: CompanyInfo.tpsRate,
        ),
      ],
      subtotalHT: 550000,
      tps: 52250,
      totalTTC: 602250,
      invoiceStatus: InvoiceStatus.paid,
      createdAt: now.subtract(const Duration(days: 15)),
    ),
  ];
});

/// Liste des devis (mockés)
final devisProvider = Provider<List<InvoiceModel>>((ref) {
  final now = DateTime.now();

  return [
    InvoiceModel(
      id: 'dev-001',
      number: 'DEV-${now.year}${now.month.toString().padLeft(2, '0')}-001',
      type: DocumentType.devis,
      clientName: 'Mme Aurore NDONG',
      clientAddress: 'Quartier Glass, Libreville',
      clientEmail: 'aurore.ndong@email.ga',
      clientPhone: '+241 74 55 66 77',
      subject: 'Organisation de mariage - Cérémonie et réception',
      issueDate: now.subtract(const Duration(days: 10)),
      dueDate: now.add(const Duration(days: 20)), // Valide 30 jours
      lines: [
        InvoiceLine.create(
          description: 'Location Salle + décoration',
          quantity: 1,
          unitPrice: 800000,
          tpsRate: CompanyInfo.tpsRate,
        ),
        InvoiceLine.create(
          description: 'Service Traiteur (150 personnes)',
          quantity: 150,
          unitPrice: 18000,
          tpsRate: CompanyInfo.tpsRate,
        ),
        InvoiceLine.create(
          description: 'Photographie & Vidéo',
          quantity: 1,
          unitPrice: 350000,
          tpsRate: CompanyInfo.tpsRate,
        ),
      ],
      subtotalHT: 3850000,
      tps: 365750,
      totalTTC: 4215750,
      conditions: '• Paiement: 50% à la commande, 50% avant l\'événement\n'
          '• Validité: 30 jours\n'
          '• Annulation: préavis 15 jours minimum',
      devisStatus: DevisStatus.pending,
      createdAt: now.subtract(const Duration(days: 10)),
    ),
    InvoiceModel(
      id: 'dev-002',
      number: 'DEV-${now.year}${now.month.toString().padLeft(2, '0')}-002',
      type: DocumentType.devis,
      clientName: 'M. Patrick OSSOUMBA',
      clientAddress: 'Batterie IV, Libreville',
      clientPhone: '+241 62 11 22 33',
      subject: 'Séminaire entreprise - Accueil et protocole',
      issueDate: now.subtract(const Duration(days: 2)),
      dueDate: now.add(const Duration(days: 28)),
      lines: [
        InvoiceLine.create(
          description: 'Service protocole et accueil',
          quantity: 1,
          unitPrice: 450000,
          tpsRate: CompanyInfo.tpsRate,
        ),
        InvoiceLine.create(
          description: 'Pause-café (60 personnes)',
          quantity: 60,
          unitPrice: 5000,
          tpsRate: CompanyInfo.tpsRate,
        ),
      ],
      subtotalHT: 750000,
      tps: 71250,
      totalTTC: 821250,
      devisStatus: DevisStatus.pending,
      createdAt: now.subtract(const Duration(days: 2)),
    ),
  ];
});

/// Factures non payées
final unpaidInvoicesProvider = Provider<List<InvoiceModel>>((ref) {
  final all = ref.watch(invoicesProvider);
  return all
      .where((i) =>
          i.invoiceStatus == InvoiceStatus.unpaid ||
          i.invoiceStatus == InvoiceStatus.partial)
      .toList();
});

/// Devis en attente
final pendingDevisProvider = Provider<List<InvoiceModel>>((ref) {
  final all = ref.watch(devisProvider);
  return all.where((d) => d.devisStatus == DevisStatus.pending).toList();
});

/// Statistiques
final invoicesStatsProvider = Provider<Map<String, int>>((ref) {
  final invoices = ref.watch(invoicesProvider);
  final devis = ref.watch(devisProvider);

  final totalCA = invoices
      .where((i) => i.invoiceStatus == InvoiceStatus.paid)
      .fold(0, (sum, i) => sum + i.totalTTC);

  final pendingAmount = invoices
      .where((i) =>
          i.invoiceStatus == InvoiceStatus.unpaid ||
          i.invoiceStatus == InvoiceStatus.partial)
      .fold(0, (sum, i) => sum + i.totalTTC);

  return {
    'totalCA': totalCA,
    'pendingAmount': pendingAmount,
    'invoiceCount': invoices.length,
    'devisCount': devis.length,
  };
});
