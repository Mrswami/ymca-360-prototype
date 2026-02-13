import 'package:flutter/material.dart';

class AppColors {
  // Complementary Opposite Scheme (Inverted Positions)
  // Original: Purple (Top) -> Blue (Bottom)
  // Complement: Green -> Orange
  // Inverted: Orange (Top) -> Green (Bottom)
  
  static const Color gradientTop = Color(0xFFFFAB00); // Amber/Orange (Comp of Blue)
  static const Color gradientBottom = Color(0xFF7CB342); // Light Green (Comp of Purple)
  
  static const Color ymcaBlue = gradientTop; // Main Primary Color
  static const Color ymcaBlack = Color(0xFF231F20);
  static const Color ymcaGrey = Color(0xFF6D6E71);
  static const Color background = Color(0xFFF4F4F4);
  static const Color cardSurface = Colors.white;
}

final ThemeData ymcaTheme = ThemeData(
  primaryColor: AppColors.ymcaBlue,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: AppColors.ymcaBlue,
    secondary: AppColors.ymcaBlack,
    surface: AppColors.cardSurface,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.ymcaBlue,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.ymcaBlue,
    unselectedItemColor: AppColors.ymcaGrey,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.ymcaBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
  fontFamily: 'Roboto', 
);
