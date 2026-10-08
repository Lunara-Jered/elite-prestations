import 'package:flutter/material.dart';

/// Palette officielle Élite Prestations
/// Identité : monochrome élégant (noir, blanc, gris)
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────
  // COULEURS PRINCIPALES
  // ─────────────────────────────────────────

  /// Noir profond - couleur principale
  static const Color black = Color(0xFF000000);

  /// Noir légèrement adouci (évite le côté brut)
  static const Color primary = Color(0xFF0A0A0A);

  /// Blanc pur
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

  /// Fond clair (mode jour)
  static const Color background = Color(0xFFFAFAFA);

  /// Fond sombre (mode nuit)
  static const Color backgroundDark = Color(0xFF0A0A0A);

  /// Surface (cards en mode clair)
  static const Color surface = Color(0xFFFFFFFF);

  /// Surface sombre (cards en mode nuit)
  static const Color surfaceDark = Color(0xFF1A1A1A);

  // ─────────────────────────────────────────
  // TEXTES
  // ─────────────────────────────────────────

  /// Texte principal (mode clair)
  static const Color textPrimary = Color(0xFF0A0A0A);

  /// Texte secondaire / muted (mode clair)
  static const Color textMuted = Color(0xFF737373);

  /// Texte sur fond sombre
  static const Color textOnDark = Color(0xFFFFFFFF);

  /// Texte muted sur fond sombre
  static const Color textMutedOnDark = Color(0xFFA3A3A3);

  // ─────────────────────────────────────────
  // ÉTATS (gardent une touche de couleur pour l'UX)
  // ─────────────────────────────────────────

  /// Succès (statut "confirmée")
  static const Color success = Color(0xFF16A34A);

  /// Alerte (statut "en attente")
  static const Color warning = Color(0xFFEA580C);

  /// Erreur (statut "annulée")
  static const Color error = Color(0xFFDC2626);

  /// Info (statut "en cours")
  static const Color info = Color(0xFF2563EB);

  // ─────────────────────────────────────────
  // BORDURES & SÉPARATEURS
  // ─────────────────────────────────────────

  static const Color border = Color(0xFFE5E5E5);
  static const Color borderDark = Color(0xFF2A2A2A);

  // ─────────────────────────────────────────
  // STATUTS RÉSERVATION (conservent des couleurs pour la lisibilité)
  // ─────────────────────────────────────────

  static const Color statusPending = warning;      // Orange
  static const Color statusConfirmed = success;    // Vert
  static const Color statusInProgress = info;      // Bleu
  static const Color statusCompleted = gray400;    // Gris
  static const Color statusCancelled = error;      // Rouge

  // ─────────────────────────────────────────
  // GRADIENTS (noir & blanc uniquement)
  // ─────────────────────────────────────────

  /// Gradient sombre (hero, headers) - subtil
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0xCC000000)],
  );

  /// Gradient noir (CTA sombres, si besoin)
  static const LinearGradient blackGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0A0A), Color(0xFF262626)],
  );

  /// Gradient gris clair (fonds de sections)
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
  );
}
