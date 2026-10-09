import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../models/reservation_model.dart';

class StatusBadge extends StatelessWidget {
  final ReservationStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ReservationStatus.pending => ('En attente', AppColors.warning),
      ReservationStatus.confirmed => ('Confirmée', AppColors.success),
      ReservationStatus.inProgress => ('En cours', AppColors.info),
      ReservationStatus.completed => ('Terminée', AppColors.gray400),
      ReservationStatus.cancelled => ('Annulée', AppColors.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
