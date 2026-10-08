// TODO: Implement the booking options step.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/utils/icon_mapper.dart';
import '../../providers/booking_provider.dart';

class StepOptions extends ConsumerWidget {
  const StepOptions({super.key});

  /// Options disponibles (à terme, viendront de Supabase)
  static const List<BookingOption> _availableOptions = [
    BookingOption(
      id: 'traiteur',
      name: 'Service Traiteur',
      iconName: 'restaurant',
      unitPrice: 15000,
      perPerson: true,
      quantity: 0,
    ),
    BookingOption(
      id: 'photo',
      name: 'Photographie & Vidéo',
      iconName: 'camera_alt',
      unitPrice: 350000,
      quantity: 0,
    ),
    BookingOption(
      id: 'sono',
      name: 'Sonorisation',
      iconName: 'music_note',
      unitPrice: 150000,
      quantity: 0,
    ),
    BookingOption(
      id: 'transport',
      name: 'Transport invités',
      iconName: 'directions_bus',
      unitPrice: 0,
      quantity: 0,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingProvider);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Personnalisez votre événement',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ces options sont facultatives',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
        const SizedBox(height: 16),

        ..._availableOptions.map((option) {
          final current = booking.options.firstWhere(
            (o) => o.id == option.id,
            orElse: () => option,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
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
                  Icon(
                    iconFromName(option.iconName),
                    size: 24,
                    color: isLight ? AppColors.primary : AppColors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          option.unitPrice > 0
                              ? '${formatFCFA(option.unitPrice)}${option.perPerson ? ' / personne' : ''}'
                              : 'Sur devis',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (option.unitPrice > 0)
                    Row(
                      children: [
                        _QtyBtn(
                          icon: Icons.remove,
                          onTap: () {
                            if (current.quantity > 0) {
                              ref.read(bookingProvider.notifier).addOption(
                                    current.copyWith(
                                      quantity: current.quantity - 1,
                                    ),
                                  );
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${current.quantity}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _QtyBtn(
                          icon: Icons.add,
                          onTap: () {
                            ref.read(bookingProvider.notifier).addOption(
                                  current.copyWith(
                                    quantity: current.quantity + 1,
                                  ),
                                );
                          },
                        ),
                      ],
                    )
                  else
                    const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textMuted),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isLight ? AppColors.gray100 : AppColors.gray800,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }
}
