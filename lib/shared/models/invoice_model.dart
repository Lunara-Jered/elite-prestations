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

  Map<String, dynamic> toJson() => {
        'description': description,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'totalHT': totalHT,
        'tps': tps,
        'totalTTC': totalTTC,
      };

  factory InvoiceLine.fromJson(Map<String, dynamic> json) => InvoiceLine(
        description: json['description'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        unitPrice: (json['unitPrice'] as num).toInt(),
        totalHT: (json['totalHT'] as num).toInt(),
        tps: (json['tps'] as num).toInt(),
        totalTTC: (json['totalTTC'] as num).toInt(),
      );

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

  InvoiceModel copyWith({
    InvoiceStatus? invoiceStatus,
    DevisStatus? devisStatus,
  }) =>
      InvoiceModel(
        id: id,
        number: number,
        type: type,
        clientName: clientName,
        clientAddress: clientAddress,
        clientNif: clientNif,
        clientEmail: clientEmail,
        clientPhone: clientPhone,
        issueDate: issueDate,
        dueDate: dueDate,
        lines: lines,
        subtotalHT: subtotalHT,
        tps: tps,
        totalTTC: totalTTC,
        notes: notes,
        conditions: conditions,
        subject: subject,
        invoiceStatus: invoiceStatus ?? this.invoiceStatus,
        devisStatus: devisStatus ?? this.devisStatus,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'type': type.name,
        'clientName': clientName,
        'clientAddress': clientAddress,
        'clientNif': clientNif,
        'clientEmail': clientEmail,
        'clientPhone': clientPhone,
        'issueDate': issueDate.toIso8601String(),
        'dueDate': dueDate.toIso8601String(),
        'lines': lines.map((line) => line.toJson()).toList(),
        'subtotalHT': subtotalHT,
        'tps': tps,
        'totalTTC': totalTTC,
        'notes': notes,
        'conditions': conditions,
        'subject': subject,
        'invoiceStatus': invoiceStatus.name,
        'devisStatus': devisStatus.name,
        'createdAt': createdAt.toIso8601String(),
      };

  Map<String, dynamic> toSupabaseJson({required String? userId}) => {
        'id': id,
        'number': number,
        'type': type.name,
        'client_name': clientName,
        'client_address': clientAddress,
        'client_nif': clientNif,
        'client_email': clientEmail,
        'client_phone': clientPhone,
        'issue_date': issueDate.toIso8601String(),
        'due_date': dueDate.toIso8601String(),
        'lines': lines.map((line) => line.toJson()).toList(),
        'subtotal_ht': subtotalHT,
        'tps': tps,
        'total_ttc': totalTTC,
        'notes': notes,
        'conditions': conditions,
        'subject': subject,
        'invoice_status': invoiceStatus.name,
        'devis_status': devisStatus.name,
        'created_at': createdAt.toIso8601String(),
        'user_id': userId,
      };

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json['id'] as String,
        number: json['number'] as String,
        type: DocumentType.values.byName(json['type'] as String),
        clientName: (json['client_name'] ?? json['clientName']) as String,
        clientAddress:
            (json['client_address'] ?? json['clientAddress']) as String?,
        clientNif: (json['client_nif'] ?? json['clientNif']) as String?,
        clientEmail: (json['client_email'] ?? json['clientEmail']) as String?,
        clientPhone: (json['client_phone'] ?? json['clientPhone']) as String?,
        issueDate: DateTime.parse(
            (json['issue_date'] ?? json['issueDate']) as String),
        dueDate:
            DateTime.parse((json['due_date'] ?? json['dueDate']) as String),
        lines: (json['lines'] as List<dynamic>)
            .map((line) =>
                InvoiceLine.fromJson(Map<String, dynamic>.from(line as Map)))
            .toList(),
        subtotalHT:
            ((json['subtotal_ht'] ?? json['subtotalHT']) as num).toInt(),
        tps: (json['tps'] as num).toInt(),
        totalTTC: ((json['total_ttc'] ?? json['totalTTC']) as num).toInt(),
        notes: json['notes'] as String?,
        conditions: json['conditions'] as String?,
        subject: json['subject'] as String?,
        invoiceStatus: InvoiceStatus.values
            .byName(
          (json['invoice_status'] ?? json['invoiceStatus']) as String? ??
              'unpaid',
        ),
        devisStatus: DevisStatus.values
            .byName(
          (json['devis_status'] ?? json['devisStatus']) as String? ??
              'pending',
        ),
        createdAt: DateTime.parse(
            (json['created_at'] ?? json['createdAt']) as String),
      );

  /// Vérifie si le devis est expiré
  bool get isDevisExpired =>
      type == DocumentType.devis && DateTime.now().isAfter(dueDate);

  /// Jours restants avant expiration (négatif si expiré)
  int get daysUntilExpiry =>
      dueDate.difference(DateTime.now()).inDays;
}
