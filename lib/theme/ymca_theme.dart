import 'package:flutter/material.dart';

class AppColors {
  // Inverted Orange & Green Theme (to distinguish from Official Purple)
  static const Color ymcaOrange      = Color(0xFFF37021); // Primary Orange (buttons, accents)
  static const Color ymcaGreen       = Color(0xFF8BB63A); // Secondary Green (highlights)
  static const Color ymcaNavy        = Color(0xFF005596); // Contrast Navy
  static const Color darkBackground  = Color(0xFF0A0A0A); // Main scaffold background
  static const Color cardDark        = Color(0xFF1A1A1A); // Card surfaces
  static const Color cardDarkAlt     = Color(0xFF252525); // Slightly lighter card
  static const Color textPrimary     = Color(0xFFFFFFFF); // Primary text
  static const Color textSecondary   = Color(0xFFB0B0B0); // Secondary / subtext
  static const Color divider         = Color(0xFF2E2E2E); // Dividers

  // Legacy aliases adjusted for the new scheme
  static const Color ymcaBlue        = ymcaNavy; // Now pointing to Navy
  static const Color ymcaPurple      = ymcaOrange; // Map old Purple to Orange
  static const Color ymcaPurpleLight = ymcaGreen;  // Map old Lite Purple to Green
  static const Color ymcaPurpleDark  = Color(0xFFC35A1A); // Dark Orange for gradients
  
  static const Color gradientTop     = ymcaOrange;
  static const Color gradientBottom  = ymcaPurpleDark;
  
  static const Color ymcaBlack       = Color(0xFF231F20);
  static const Color ymcaGrey        = Color(0xFF6D6E71);
  static const Color background      = darkBackground;
  static const Color cardSurface     = cardDark;
}

final ThemeData ymcaTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.ymcaPurple,
  scaffoldBackgroundColor: AppColors.darkBackground,

  colorScheme: const ColorScheme.dark(
    primary:   AppColors.ymcaPurple,
    secondary: AppColors.ymcaPurpleLight,
    surface:   AppColors.cardDark,
    onPrimary: Colors.white,
    onSurface: AppColors.textPrimary,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF121212),
    selectedItemColor: AppColors.ymcaPurple,
    unselectedItemColor: AppColors.textSecondary,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
    unselectedLabelStyle: TextStyle(fontSize: 11),
    type: BottomNavigationBarType.fixed,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.ymcaPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
    titleLarge:   TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
    titleMedium:  TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
    bodyLarge:    TextStyle(color: AppColors.textPrimary, fontSize: 15),
    bodyMedium:   TextStyle(color: AppColors.textSecondary, fontSize: 13),
    labelSmall:   TextStyle(color: AppColors.textSecondary, fontSize: 11),
  ),

  dividerTheme: const DividerThemeData(
    color: AppColors.divider,
    thickness: 1,
  ),

  fontFamily: 'Roboto',
);
