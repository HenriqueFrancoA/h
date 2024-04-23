import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'color_schemes.dart';

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.poppins(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 16,
    ),
    bodyMedium: GoogleFonts.poppins(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 14,
    ),
    bodySmall: GoogleFonts.poppins(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 12,
    ),
    titleLarge: GoogleFonts.poppins(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.poppins(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 16,
    ),
    labelMedium: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 14,
    ),
    labelSmall: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 12,
    ),
    displayLarge: GoogleFonts.poppins(
      color: Colors.red,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.poppins(
      color: Colors.red,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.poppins(
      color: Colors.red,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
);
