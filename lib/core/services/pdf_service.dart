// TODO: Add PDF generation and export.
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../constants/company_info.dart';
import '../utils/currency.dart';
import '../../shared/models/invoice_model.dart';

class PdfService {
  PdfService._();

  /// Génère une facture ou un devis PDF
  static Future<Uint8List> generateDocument(InvoiceModel document) async {
    final pdf = pw.Document();

    final isDevis = document.type == DocumentType.devis;
    final primaryColor = isDevis
        ? const PdfColor.fromInt(0xFF8B5CF6)
        : const PdfColor.fromInt(0xFF1E3A8A);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          _buildHeader(document, primaryColor, isDevis),
          pw.SizedBox(height: 24),
          _buildClientSection(document, primaryColor, isDevis),
          pw.SizedBox(height: 24),
          if (isDevis && document.subject != null)
            _buildSubjectSection(document, primaryColor),
          if (isDevis && document.subject != null) pw.SizedBox(height: 24),
          _buildLinesTable(document, primaryColor, isDevis),
          pw.SizedBox(height: 24),
          _buildTotals(document, primaryColor, isDevis),
          if (document.conditions != null && isDevis) ...[
            pw.SizedBox(height: 24),
            _buildConditionsSection(document, primaryColor),
          ],
          if (document.notes != null) ...[
            pw.SizedBox(height: 24),
            _buildNotesSection(document, primaryColor),
          ],
          pw.SizedBox(height: 40),
          _buildFooter(primaryColor, isDevis),
        ],
      ),
    );

    return pdf.save();
  }

  // ─────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────
  static pw.Widget _buildHeader(
    InvoiceModel doc,
    PdfColor primaryColor,
    bool isDevis,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        // Colonne gauche : Infos entreprise
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                CompanyInfo.name,
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                CompanyInfo.tagline,
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                CompanyInfo.address,
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'NIF: ${CompanyInfo.nif}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'RCCM: ${CompanyInfo.rccm}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'Tél: ${CompanyInfo.phone1}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'Tél: ${CompanyInfo.phone2}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'Email: ${CompanyInfo.email}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),

        pw.SizedBox(width: 20),

        // Colonne droite : Titre + numéro + dates
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              isDevis ? 'DEVIS' : 'FACTURE',
              style: pw.TextStyle(
                fontSize: 26,
                fontWeight: pw.FontWeight.bold,
                color: primaryColor,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'N° ${doc.number}',
              style: const pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Date: ${_formatDate(doc.issueDate)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.Text(
              isDevis
                  ? 'Validité: ${_formatDate(doc.dueDate)}'
                  : 'Échéance: ${_formatDate(doc.dueDate)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // CLIENT
  // ─────────────────────────────────────────
  static pw.Widget _buildClientSection(
    InvoiceModel doc,
    PdfColor primaryColor,
    bool isDevis,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: primaryColor, width: 2),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'CLIENT',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: primaryColor,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            doc.clientName,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if (doc.clientAddress != null)
            pw.Text(
              'Adresse: ${doc.clientAddress}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          if (doc.clientNif != null)
            pw.Text(
              'NIF: ${doc.clientNif}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          if (doc.clientEmail != null)
            pw.Text(
              'Email: ${doc.clientEmail}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          if (doc.clientPhone != null)
            pw.Text(
              'Téléphone: ${doc.clientPhone}',
              style: const pw.TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // OBJET (DEVIS UNIQUEMENT)
  // ─────────────────────────────────────────
  static pw.Widget _buildSubjectSection(
    InvoiceModel doc,
    PdfColor primaryColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'OBJET',
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: primaryColor,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            border: pw.Border(
              left: pw.BorderSide(color: primaryColor, width: 3),
            ),
          ),
          child: pw.Text(
            doc.subject!,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // TABLEAU DES LIGNES
  // ─────────────────────────────────────────
  static pw.Widget _buildLinesTable(
    InvoiceModel doc,
    PdfColor primaryColor,
    bool isDevis,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          isDevis ? 'DÉTAILS DU DEVIS' : 'DÉTAILS DE LA FACTURE',
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: primaryColor,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(4),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FlexColumnWidth(2),
          },
          children: [
            // En-tête
            pw.TableRow(
              decoration: pw.BoxDecoration(color: primaryColor),
              children: [
                _cellHeader('Description'),
                _cellHeader('Qté', center: true),
                _cellHeader('Prix HT', right: true),
                _cellHeader('Total HT', right: true),
              ],
            ),
            // Lignes
            ...doc.lines.map((line) => pw.TableRow(
                  children: [
                    _cellText(line.description),
                    _cellText(line.quantity.toString(), center: true),
                    _cellText(formatNumber(line.unitPrice), right: true),
                    _cellText(formatNumber(line.totalHT), right: true),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // TOTAUX
  // ─────────────────────────────────────────
  static pw.Widget _buildTotals(
    InvoiceModel doc,
    PdfColor primaryColor,
    bool isDevis,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 250,
          padding: const pw.EdgeInsets.all(14),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            border: pw.Border.all(color: primaryColor, width: 2),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            children: [
              _totalRow('Total HT:', formatFCFA(doc.subtotalHT)),
              pw.SizedBox(height: 6),
              _totalRow(
                'TPS 9,5%:',
                formatFCFA(doc.tps),
                valueColor: PdfColors.blue700,
              ),
              pw.SizedBox(height: 10),
              pw.Divider(color: primaryColor, thickness: 2),
              pw.SizedBox(height: 6),
              _totalRow(
                'TOTAL TTC:',
                formatFCFA(doc.totalTTC),
                bold: true,
                big: true,
                valueColor: primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // CONDITIONS (DEVIS UNIQUEMENT)
  // ─────────────────────────────────────────
  static pw.Widget _buildConditionsSection(
    InvoiceModel doc,
    PdfColor primaryColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'CONDITIONS GÉNÉRALES',
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: primaryColor,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            border: pw.Border(
              left: pw.BorderSide(color: primaryColor, width: 3),
            ),
          ),
          child: pw.Text(
            doc.conditions!,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // NOTES
  // ─────────────────────────────────────────
  static pw.Widget _buildNotesSection(
    InvoiceModel doc,
    PdfColor primaryColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'NOTES',
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: primaryColor,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            doc.notes!,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // FOOTER
  // ─────────────────────────────────────────
  static pw.Widget _buildFooter(PdfColor primaryColor, bool isDevis) {
    return pw.Column(
      children: [
        pw.Divider(color: primaryColor, thickness: 2),
        pw.SizedBox(height: 8),
        pw.Text(
          CompanyInfo.name,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: primaryColor,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          CompanyInfo.tagline,
          style: const pw.TextStyle(
            fontSize: 9,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '${CompanyInfo.address} | NIF: ${CompanyInfo.nif} | RCCM: ${CompanyInfo.rccm}',
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.grey600,
          ),
        ),
        pw.Text(
          'Tél: ${CompanyInfo.phone1} / ${CompanyInfo.phone2}',
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.grey600,
          ),
        ),
        pw.Text(
          'Email: ${CompanyInfo.email}',
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.grey600,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          '${isDevis ? 'Devis' : 'Facture'} généré(e) le ${_formatDate(DateTime.now())}',
          style: const pw.TextStyle(
            fontSize: 7,
            color: PdfColors.grey500,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────

  static pw.Widget _cellHeader(
    String text, {
    bool center = false,
    bool right = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: center
            ? pw.TextAlign.center
            : right
                ? pw.TextAlign.right
                : pw.TextAlign.left,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  static pw.Widget _cellText(
    String text, {
    bool center = false,
    bool right = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: center
            ? pw.TextAlign.center
            : right
                ? pw.TextAlign.right
                : pw.TextAlign.left,
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  static pw.Widget _totalRow(
    String label,
    String value, {
    bool bold = false,
    bool big = false,
    PdfColor? valueColor,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: big ? 13 : 11,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: big ? 13 : 11,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  /// Impression du document
  static Future<void> printDocument(InvoiceModel document) async {
    await Printing.layoutPdf(
      onLayout: (format) => generateDocument(document),
      name: document.number,
    );
  }

  /// Partage du document
  static Future<void> shareDocument(InvoiceModel document) async {
    await Printing.sharePdf(
      bytes: await generateDocument(document),
      filename: '${document.number}.pdf',
    );
  }
}
