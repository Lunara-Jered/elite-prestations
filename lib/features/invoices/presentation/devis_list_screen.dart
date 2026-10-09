import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency.dart';
import '../../../providers/invoices_provider.dart';
import '../../../shared/models/invoice_model.dart';
import 'invoice_preview_screen.dart';

class DevisListScreen extends ConsumerWidget {
  const DevisListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devis = ref.watch(devisProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes devis')),
      body: SafeArea(
        child: devis.isEmpty
            ? const Center(child: Text('Aucun devis'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: devis.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _DevisCard(devis: devis[index]);
                },
              ),
      ),
    );
  }
}

class _DevisCard extends StatelessWidget {
  final InvoiceModel devis;
  const _DevisCard({required this.devis});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final dateFmt = DateFormat('dd/MM/yyyy');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InvoicePreviewScreen(document: devis),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLight ? AppColors.surface : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLight ? AppColors.border : AppColors.borderDark,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    devis.number,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (devis.isDevisExpired)
                  const Text(
                    'EXPIRÉ',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Text(
                    'Valide ${devis.daysUntilExpiry}j',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(devis.clientName, style: const TextStyle(fontSize: 13)),
            if (devis.subject != null) ...[
              const SizedBox(height: 4),
              Text(
                devis.subject!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              'Valide jusqu\'au ${dateFmt.format(devis.dueDate)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatFCFA(devis.totalTTC),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
