import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_pack.dart';

ThemeData buildTheme(ThemePack pack) {
  final baseTextTheme = ThemeData.light().textTheme;

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: pack.background,

    colorScheme: ColorScheme.light(
      primary: pack.primary,
      secondary: pack.secondary,
      surface: pack.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: pack.text,
    ),

    textTheme: GoogleFonts.quicksandTextTheme(
      baseTextTheme,
    ).apply(bodyColor: pack.text, displayColor: pack.text),

    appBarTheme: AppBarTheme(
      backgroundColor: pack.background,
      foregroundColor: pack.text,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: pack.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(pack.cardRadius),
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      backgroundColor: pack.surface,
      indicatorColor: pack.primary.withValues(alpha: 0.18),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );
}
