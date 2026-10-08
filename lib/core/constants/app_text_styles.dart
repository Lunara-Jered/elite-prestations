// TODO: Define the app text styles.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Styles typographiques officiels Élite Prestations
class AppTextStyles {
  AppTextStyles._();
  
  // ─────────────────────────────────────────
  // TITRES (Playfair Display - serif élégante)
  // ─────────────────────────────────────────
  
  /// H1 - Titre principal (hero accueil)
  static TextStyle h1 = GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.25,
  );
  
  /// H2 - Titres de sections
  static TextStyle h2 = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  /// H3 - Sous-titres, titres de cards
  static TextStyle h3 = GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // ─────────────────────────────────────────
  // CORPS (Inter - sans-serif moderne)
  // ─────────────────────────────────────────
  
  /// Body large - texte principal
  static TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  /// Body medium - texte secondaire
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  /// Caption - petits textes (labels, hints)
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );
  
  /// Bouton
  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );
  
  
 /// Prix (noir élégant)
static TextStyle price = GoogleFonts.inter(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: AppColors.textPrimary,
);
  
  /// Label sur fond sombre
  static TextStyle labelOnDark = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
  );
  
  // ─────────────────────────────────────────
  // VARIANTES (couleurs alternatives)
  // ─────────────────────────────────────────
  
  static TextStyle h1OnDark = h1.copyWith(color: AppColors.textOnDark);
  static TextStyle h2OnDark = h2.copyWith(color: AppColors.textOnDark);
  static TextStyle h3OnDark = h3.copyWith(color: AppColors.textOnDark);
  static TextStyle bodyOnDark = body.copyWith(color: AppColors.textOnDark);
  static TextStyle captionOnDark = caption.copyWith(color: AppColors.textOnDark);
}
