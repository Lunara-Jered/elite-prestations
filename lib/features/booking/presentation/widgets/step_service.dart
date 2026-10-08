// TODO: Implement the booking service step.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../providers/services_provider.dart';
import '../../providers/booking_provider.dart';
import '../../../../core/utils/currency.dart';

class StepService extends ConsumerWidget {
  const StepService({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(servicesProvider);
    final booking = ref.watch(bookingProvider);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Quelle prestation souhaitez-vous ?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        ...services.map((service) {
          final isSelected = booking.selectedService?.id == service.id;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                ref.read(bookingProvider.notifier).selectService(service);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isLight ? AppColors.primary : AppColors.white)
                      : (isLight ? AppColors.surface : AppColors.surfaceDark),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? (isLight ? AppColors.primary : AppColors.white)
                        : (isLight ? AppColors.border : AppColors.borderDark),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: isSelected
                                  ? (isLight
                                      ? AppColors.white
                                      : AppColors.primary)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service.basePrice > 0
                                ? 'Dès ${formatFCFA(service.basePrice)} / ${service.unit}'
                                : 'Sur devis',
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected
                                  ? (isLight
                                      ? AppColors.gray300
                                      : AppColors.textMuted)
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? (isLight ? AppColors.white : AppColors.primary)
                          : AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
