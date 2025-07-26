import 'package:flutter/material.dart';
import 'package:jokita/app/theme/colors_theme.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  // 💡 Warna utama (ungu → primary scale)
  primaryColor: AppColors.primary40,
  primaryColorLight: AppColors.primary10,
  primaryColorDark: AppColors.primary50,

  // 💡 Warna sekunder (biru → secondary scale)
  secondaryHeaderColor: AppColors.secondary40,

  // 💡 Warna latar belakang scaffold dan canvas
  scaffoldBackgroundColor: AppColors.white,
  canvasColor: AppColors.white,
  cardColor: AppColors.primary10.withAlpha(10),

  // 💡 Warna sorotan dan lainnya
  splashColor: AppColors.secondary20,
  highlightColor: AppColors.secondary10,
  focusColor: AppColors.primary30,
  shadowColor: AppColors.primary50.withAlpha(20),

  // 💡 Text dan ikon
  iconTheme: IconThemeData(color: AppColors.primary50),
  primaryIconTheme: IconThemeData(color: AppColors.primary10),
  
  // 💡 Color scheme M3
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary40,
    onPrimary: AppColors.white,
    secondary: AppColors.secondary40,
    onSecondary: AppColors.white,
    error: AppColors.tertiary50,
    onError: AppColors.white,
    surface: AppColors.primary10,
    onSurface: Colors.black,
  ),

  // 💡 ElevatedButton example
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary40,
      foregroundColor: AppColors.white,
    ),
  ),

  // 💡 Text button (for contrast)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.secondary40,
    ),
  ),

  // 💡 FloatingActionButton
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.tertiary40,
    foregroundColor: AppColors.white,
  ),
);