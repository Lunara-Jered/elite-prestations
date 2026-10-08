import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency.dart';
import '../../providers/booking_provider.dart';

class StepRecap extends ConsumerWidget {
  const StepRecap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Récapitulatif',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),

        // ─────────────────────────────────
        // DATES
        // ─────────────────────────────────
        if (booking.startDate != null)
          _RecapCard(
            icon: Icons.event,
            title: 'Dates',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatRange(booking.startDate!, booking.duration),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${booking.duration} jour${booking.duration > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 12),

        // ─────────────────────────────────
        // PRESTATIONS
        // ─────────────────────────────────
        if (booking.selectedService != null)
          _RecapCard(
            icon: Icons.room_service_outlined,
            title: 'Prestations',
            child: Column(
              children: [
                _Line(
                  label: booking.selectedService!.name,
                  amount: booking.selectedService!.basePrice *
                      (booking.selectedService!.unit == 'jour' ||
                              booking.selectedService!.unit == 'nuit'
                          ? booking.duration
                          : 1),
                ),
                ...booking.options
                    .where((o) => o.quantity > 0)
                    .map((o) => _Line(
                          label: '${o.emoji} ${o.name} × ${o.quantity}',
                          amount: o.total,
                        )),
              ],
            ),
          ),

        const SizedBox(height: 12),

        // ─────────────────────────────────
        // DÉTAIL PRIX
        // ─────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isLight ? AppColors.gray100 : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _PriceLine(
                label: 'Sous-total HT',
                amount: booking.subtotalHT,
              ),
              _PriceLine(
                label: 'TVA (18%)',
                amount: booking.tva,
              ),
              const Divider(height: 24),
              _PriceLine(
                label: 'TOTAL TTC',
                amount: booking.totalTTC,
                bold: true,
                big: true,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLight ? AppColors.white : AppColors.gray800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Acompte (50%)',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      formatFCFA(booking.deposit),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatRange(DateTime start, int days) {
    final end = start.add(Duration(days: days - 1));
    final fmt = DateFormat('dd/MM/yyyy');
    if (days == 1) return fmt.format(start);
    return 'Du ${fmt.format(start)} au ${fmt.format(end)}';
  }
}

// ─────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────
class _RecapCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _RecapCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
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
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final String label;
  final int amount;

  const _Line({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          Text(
            formatFCFA(amount),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  final String label;
  final int amount;
  final bool bold;
  final bool big;

  const _PriceLine({
    required this.label,
    required this.amount,
    this.bold = false,
    this.big = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: big ? 16 : 14,
            ),
          ),
          Text(
            formatFCFA(amount),
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: big ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
