// TODO: Implement the invoice screen.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/pdf_service.dart';
import '../../../core/utils/currency.dart';
import '../../../shared/models/invoice_model.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final InvoiceModel document;
  const InvoicePreviewScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final isDevis = document.type == DocumentType.devis;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(document.number),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () async {
              await PdfService.printDocument(document);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              await PdfService.shareDocument(document);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Bandeau info
            Container(
              padding: const EdgeInsets.all(12),
              color: isLight ? AppColors.gray100 : AppColors.surfaceDark,
              child: Row(
                children: [
                  Icon(
                    isDevis
                        ? Icons.description_outlined
                        : Icons.receipt_long_outlined,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDevis ? 'Devis' : 'Facture',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${document.clientName} • ${formatFCFA(document.totalTTC)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Aperçu PDF
            Expanded(
              child: PdfPreview(
                build: (format) => PdfService.generateDocument(document),
                canChangeOrientation: false,
                canChangePageFormat: false,
                canDebug: false,
                allowSharing: true,
                allowPrinting: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
