// TODO: Define the app color palette.
import 'package:flutter/material.dart';

/// Palette officielle Élite Prestations
/// Identité : élégance, luxe, professionnalisme
class AppColors {
  AppColors._(); // constructeur privé
  
  // ─────────────────────────────────────────
  // COULEURS PRINCIPALES
  // ─────────────────────────────────────────
  
  /// Noir profond - couleur principale
  static const Color primary = Color(0xFF0A0A0A);
  
  /// Or / Doré - couleur accent (luxe)
  static const Color accent = Color(0xFFD4AF37);
  
  /// Champagne - couleur secondaire
  static const Color secondary = Color(0xFFE8D5B7);
  
  // ─────────────────────────────────────────
  // FONDS
  // ─────────────────────────────────────────
  
  /// Fond clair (mode jour)
  static const Color background = Color(0xFFFAFAF8);
  
  /// Fond sombre (mode nuit)
  static const Color backgroundDark = Color(0xFF121212);
  
  /// Surface (cards)
  static const Color surface = Color(0xFFFFFFFF);
  
  /// Surface sombre
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // ─────────────────────────────────────────
  // TEXTES
  // ─────────────────────────────────────────
  
  /// Texte principal
  static const Color textPrimary = Color(0xFF1A1A1A);
  
  /// Texte secondaire / muted
  static const Color textMuted = Color(0xFF6B7280);
  
  /// Texte sur fond sombre
  static const Color textOnDark = Color(0xFFF5F5F5);
  
  // ─────────────────────────────────────────
  // ÉTATS
  // ─────────────────────────────────────────
  
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // ─────────────────────────────────────────
  // BORDURES & SÉPARATEURS
  // ─────────────────────────────────────────
  
  static const Color border = Color(0xFFE5E5E5);
  static const Color borderDark = Color(0xFF2A2A2A);
  
  // ─────────────────────────────────────────
  // STATUTS RÉSERVATION
  // ─────────────────────────────────────────
  
  static const Color statusPending = Color(0xFFF59E0B);   // 🟡 En attente
  static const Color statusConfirmed = Color(0xFF22C55E); // 🟢 Confirmée
  static const Color statusInProgress = Color(0xFF3B82F6);// 🔵 En cours
  static const Color statusCompleted = Color(0xFF9CA3AF); // ⚪ Terminée
  static const Color statusCancelled = Color(0xFFEF4444); // 🔴 Annulée
  
  // ─────────────────────────────────────────
  // GRADIENTS
  // ─────────────────────────────────────────
  
  /// Gradient or (boutons CTA)
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4AF37), Color(0xFFE8D5B7)],
  );
  
  /// Gradient sombre (hero, header)
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x000A0A0A), Color(0xCC0A0A0A)],
  );
}