import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';

/// Thème principal de l'application
class AppTheme {
  AppTheme._();

  static const SystemUiOverlayStyle systemOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static ThemeData get light => _baseTheme(Brightness.light);
  static ThemeData get dark => _baseTheme(Brightness.dark);

  static ThemeData _baseTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      // ─────────────────────────────────────────
      // COULEURS
      // ─────────────────────────────────────────
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: isLight ? AppColors.primary : AppColors.white,
        onPrimary: isLight ? AppColors.white : AppColors.primary,
        surface: isLight ? AppColors.surface : AppColors.surfaceDark,
        onSurface: isLight ? AppColors.textPrimary : AppColors.textOnDark,
      ),

      scaffoldBackgroundColor:
          isLight ? AppColors.background : AppColors.backgroundDark,

      // ─────────────────────────────────────────
      // TYPOGRAPHIE
      // ─────────────────────────────────────────
      textTheme: GoogleFonts.interTextTheme(
        isLight ? ThemeData.light().textTheme : ThemeData.dark().textTheme,
      ),

      // ─────────────────────────────────────────
      // APPBAR
      // ─────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor:
            isLight ? AppColors.textPrimary : AppColors.textOnDark,
        systemOverlayStyle: systemOverlayStyle,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isLight ? AppColors.textPrimary : AppColors.textOnDark,
        ),
      ),

      // ─────────────────────────────────────────
      // CARDS
      // ─────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: isLight ? AppColors.surface : AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
          side: BorderSide(
            color: isLight ? AppColors.border : AppColors.borderDark,
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // ─────────────────────────────────────────
      // BOUTONS ÉLEVÉS
      // ─────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLight ? AppColors.primary : AppColors.white,
          foregroundColor: isLight ? AppColors.white : AppColors.primary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // BOUTONS OUTLINE
      // ─────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              isLight ? AppColors.textPrimary : AppColors.textOnDark,
          minimumSize: const Size(double.infinity, 56),
          side: BorderSide(
            color: isLight ? AppColors.primary : AppColors.white,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // BOUTONS TEXTE
      // ─────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isLight ? AppColors.primary : AppColors.white,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // CHAMPS DE SAISIE
      // ─────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AppColors.surface : AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(
            color: isLight ? AppColors.border : AppColors.borderDark,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(
            color: isLight ? AppColors.border : AppColors.borderDark,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(
            color: isLight ? AppColors.primary : AppColors.white,
            width: 2,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: AppColors.error),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
      ),

      // ─────────────────────────────────────────
      // DIVIDER
      // ─────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: isLight ? AppColors.border : AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      // ─────────────────────────────────────────
      // TABBAR
      // ─────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: isLight ? AppColors.primary : AppColors.white,
        unselectedLabelColor: AppColors.textMuted,
        indicatorColor: isLight ? AppColors.primary : AppColors.white,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),

      // ─────────────────────────────────────────
      // BOTTOM NAV
      // ─────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isLight ? AppColors.surface : AppColors.surfaceDark,
        selectedItemColor: isLight ? AppColors.primary : AppColors.white,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ─────────────────────────────────────────
      // SNACKBAR
      // ─────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        contentTextStyle: GoogleFonts.inter(color: AppColors.textOnDark),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.buttonRadius,
        ),
      ),
    );
  }
}
