import 'package:flutter/material.dart';

/// Palette officielle Élite Prestations
/// Identité : monochrome élégant (noir, blanc, gris)
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────
  // COULEURS PRINCIPALES
  // ─────────────────────────────────────────
  static const Color black = Color(0xFF000000);
  static const Color primary = Color(0xFF0A0A0A);
  static const Color white = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────
  // ÉCHELLE DE GRIS
  // ─────────────────────────────────────────
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFE5E5E5);
  static const Color gray300 = Color(0xFFD4D4D4);
  static const Color gray400 = Color(0xFFA3A3A3);
  static const Color gray500 = Color(0xFF737373);
  static const Color gray600 = Color(0xFF525252);
  static const Color gray700 = Color(0xFF404040);
  static const Color gray800 = Color(0xFF262626);
  static const Color gray900 = Color(0xFF171717);

  // ─────────────────────────────────────────
  // FONDS
  // ─────────────────────────────────────────
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A1A);

  // ─────────────────────────────────────────
  // TEXTES
  // ─────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textMuted = Color(0xFF737373);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textMutedOnDark = Color(0xFFA3A3A3);

  // ─────────────────────────────────────────
  // ÉTATS
  // ─────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFEA580C);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // ─────────────────────────────────────────
  // BORDURES
  // ─────────────────────────────────────────
  static const Color border = Color(0xFFE5E5E5);
  static const Color borderDark = Color(0xFF2A2A2A);

  // ─────────────────────────────────────────
  // STATUTS RÉSERVATION
  // ─────────────────────────────────────────
  static const Color statusPending = warning;
  static const Color statusConfirmed = success;
  static const Color statusInProgress = info;
  static const Color statusCompleted = gray400;
  static const Color statusCancelled = error;

  // ─────────────────────────────────────────
  // GRADIENTS
  // ─────────────────────────────────────────
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0xCC000000)],
  );

  static const LinearGradient blackGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0A0A), Color(0xFF262626)],
  );

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
  );
}
