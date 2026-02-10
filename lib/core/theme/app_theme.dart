import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors from Design
  static const Color primary = Color(0xFF11D452);
  static const Color backgroundDark = Color(0xFF102216);
  static const Color surfaceDark = Color(0xFF1A2F23);
  static const Color surfaceDarker = Color(0xFF0D1B12);
  static const Color textWhite = Color(0xFFF1F5F9);
  static const Color textGrey = Color(0xFF94A3B8);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primary,
        background: backgroundDark,
        surface: surfaceDark,
        onSurface: textWhite,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: textWhite),
        titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: textWhite),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: textWhite),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: textGrey),
      ),
      cardTheme: CardTheme(
        color: surfaceDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      iconTheme: const IconThemeData(color: textWhite),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textWhite),
        iconTheme: IconThemeData(color: textWhite),
      ),
    );
  }
}
