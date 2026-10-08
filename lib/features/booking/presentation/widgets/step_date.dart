// TODO: Implement the booking date step.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../providers/booking_provider.dart';

class StepDate extends ConsumerWidget {
  const StepDate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Quand souhaitez-vous réserver ?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),

        // ─────────────────────────────────
        // SÉLECTION DATE DE DÉBUT
        // ─────────────────────────────────
        _DatePickerTile(
          label: 'Date de début',
          date: booking.startDate,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: booking.startDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: isLight
                        ? const ColorScheme.light(
                            primary: AppColors.primary,
                            onPrimary: AppColors.white,
                          )
                        : const ColorScheme.dark(
                            primary: AppColors.white,
                            onPrimary: AppColors.primary,
                          ),
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null) {
              final end = booking.endDate ??
                  picked.add(Duration(days: booking.duration - 1));
              ref.read(bookingProvider.notifier).setDates(picked, end);
            }
          },
        ),
        const SizedBox(height: 12),

        // ─────────────────────────────────
        // DURÉE
        // ─────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isLight ? AppColors.surface : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLight ? AppColors.border : AppColors.borderDark,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Durée',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              _QuantityButton(
                icon: Icons.remove,
                onTap: () {
                  if (booking.duration > 1) {
                    ref
                        .read(bookingProvider.notifier)
                        .setDuration(booking.duration - 1);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${booking.duration} j',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              _QuantityButton(
                icon: Icons.add,
                onTap: () {
                  ref
                      .read(bookingProvider.notifier)
                      .setDuration(booking.duration + 1);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ─────────────────────────────────
        // RÉCAP DATES
        // ─────────────────────────────────
        if (booking.startDate != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isLight ? AppColors.gray100 : AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_available, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dates sélectionnées',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatRange(booking.startDate!, booking.duration),
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
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

class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DatePickerTile({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLight ? AppColors.surface : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLight ? AppColors.border : AppColors.borderDark,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.event, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date != null
                    ? DateFormat('dd MMMM yyyy', 'fr_FR').format(date!)
                    : label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isLight ? AppColors.gray100 : AppColors.gray800,
          shape: BoxShape.circle,
          border: Border.all(
            color: isLight ? AppColors.border : AppColors.borderDark,
          ),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
