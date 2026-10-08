// TODO: Provide the application's theme entry point.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

/// Thème principal de l'application
class AppTheme {
  AppTheme._();
  
  /// Configuration de la barre de statut (iOS + Android)
  static const SystemUiOverlayStyle systemOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Android
    statusBarBrightness: Brightness.light,     // iOS
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  
  /// Thème clair
  static ThemeData get light => lightTheme;
  
  /// Thème sombre
  static ThemeData get dark => darkTheme;
  
  /// Thème Material commun (base partagée entre light et dark)
  static ThemeData _baseTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      
      // Couleurs
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: brightness,
        primary: AppColors.accent,
        surface: isLight ? AppColors.surface : AppColors.surfaceDark,
      ),
      
      scaffoldBackgroundColor:
          isLight ? AppColors.background : AppColors.backgroundDark,
      
      // Typographie
      textTheme: GoogleFonts.interTextTheme(),
      
      // AppBar
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
      
      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        color: isLight ? AppColors.surface : AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Boutons élevés
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.primary,
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
      
      // Boutons outline
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              isLight ? AppColors.textPrimary : AppColors.textOnDark,
          minimumSize: const Size(double.infinity, 56),
          side: BorderSide(
            color: isLight ? AppColors.border : AppColors.borderDark,
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
      
      // Boutons texte
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Champs de saisie
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
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: isLight ? AppColors.border : AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),
      
      // TabBar
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.accent,
        unselectedLabelColor: AppColors.textMuted,
        indicatorColor: AppColors.accent,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),
      
      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isLight ? AppColors.surface : AppColors.surfaceDark,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Snackbar
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
  
  /// Thème clair
  static ThemeData get lightTheme => _baseTheme(Brightness.light);
  
  /// Thème sombre
  static ThemeData get darkTheme => _baseTheme(Brightness.dark);
}