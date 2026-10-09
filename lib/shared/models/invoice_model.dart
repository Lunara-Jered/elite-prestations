// TODO: Define the invoice model.
/// Modèle d'une ligne de facture/devis
class InvoiceLine {
  final String description;
  final double quantity;
  final int unitPrice; // FCFA HT
  final int totalHT;
  final int tps;
  final int totalTTC;

  const InvoiceLine({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalHT,
    required this.tps,
    required this.totalTTC,
  });

  factory InvoiceLine.create({
    required String description,
    required double quantity,
    required int unitPrice,
    required double tpsRate,
  }) {
    final totalHT = (quantity * unitPrice).round();
    final tps = (totalHT * tpsRate).round();
    final totalTTC = totalHT + tps;

    return InvoiceLine(
      description: description,
      quantity: quantity,
      unitPrice: unitPrice,
      totalHT: totalHT,
      tps: tps,
      totalTTC: totalTTC,
    );
  }
}

/// Types de document fiscal
enum DocumentType { facture, devis }

/// Statut d'une facture
enum InvoiceStatus { unpaid, partial, paid, cancelled }

/// Statut d'un devis
enum DevisStatus { pending, accepted, refused, invoiced }

/// Modèle complet d'une facture ou d'un devis
class InvoiceModel {
  final String id;
  final String number; // "FACT-202610-001" ou "DEV-202610-001"
  final DocumentType type;

  // Client
  final String clientName;
  final String? clientAddress;
  final String? clientNif;
  final String? clientEmail;
  final String? clientPhone;

  // Dates
  final DateTime issueDate;
  final DateTime dueDate; // Facture ou validité devis

  // Contenu
  final List<InvoiceLine> lines;
  final int subtotalHT;
  final int tps;
  final int totalTTC;

  // Méta
  final String? notes;
  final String? conditions;
  final String? subject; // Pour devis uniquement

  // Statuts
  final InvoiceStatus invoiceStatus;
  final DevisStatus devisStatus;

  final DateTime createdAt;

  const InvoiceModel({
    required this.id,
    required this.number,
    required this.type,
    required this.clientName,
    this.clientAddress,
    this.clientNif,
    this.clientEmail,
    this.clientPhone,
    required this.issueDate,
    required this.dueDate,
    required this.lines,
    required this.subtotalHT,
    required this.tps,
    required this.totalTTC,
    this.notes,
    this.conditions,
    this.subject,
    this.invoiceStatus = InvoiceStatus.unpaid,
    this.devisStatus = DevisStatus.pending,
    required this.createdAt,
  });

  /// Vérifie si le devis est expiré
  bool get isDevisExpired =>
      type == DocumentType.devis && DateTime.now().isAfter(dueDate);

  /// Jours restants avant expiration (négatif si expiré)
  int get daysUntilExpiry =>
      dueDate.difference(DateTime.now()).inDays;
}
