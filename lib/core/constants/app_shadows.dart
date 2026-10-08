// TODO: Define shared shadows.
import 'package:flutter/material.dart';

/// Ombres douces et élégantes
class AppShadows {
  AppShadows._();
  
  /// Ombre légère (cards secondaires)
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  
  /// Ombre moyenne (cards principales)
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
  
  /// Ombre forte (modals, FAB)
  static const List<BoxShadow> strong = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
  
  /// Ombre dorée (CTA accentués)
  static const List<BoxShadow> gold = [
    BoxShadow(
      color: Color(0x33D4AF37),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}