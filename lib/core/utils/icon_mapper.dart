import 'package:flutter/material.dart';

/// Convertit un nom d'icône (stocké en String) en IconData Material.
/// Permet de stocker des icônes en base sans dépendre de Flutter.
IconData iconFromName(String name) {
  switch (name) {
    case 'restaurant':
      return Icons.restaurant;
    case 'camera_alt':
      return Icons.camera_alt;
    case 'music_note':
      return Icons.music_note;
    case 'directions_bus':
      return Icons.directions_bus;
    case 'smartphone':
      return Icons.smartphone;
    case 'account_balance':
      return Icons.account_balance;
    case 'payments':
      return Icons.payments_outlined;
    case 'event':
      return Icons.event;
    case 'room_service':
      return Icons.room_service_outlined;
    case 'cleaning':
      return Icons.cleaning_services_outlined;
    case 'business_center':
      return Icons.business_center_outlined;
    default:
      return Icons.circle_outlined;
  }
}
