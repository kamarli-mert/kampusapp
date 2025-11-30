import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primary = Color(0xFFFF8C00); // Darker Vibrant Orange
  static const Color primaryDark = Color(0xFFE65100); // Darker Orange
  static const Color primaryLight = Color(0xFFFFB74D); // Lighter Orange
  
  // Secondary Colors
  static const Color secondary = Color(0xFF2E8AFF); // Azure Blue
  static const Color secondaryLight = Color(0xFFE3F2FD); // Light Blue
  
  // Accent Colors
  static const Color accent = Color(0xFF009688); // Teal

  // Background Colors
  static const Color background = Color(0xFFFFF9F2); // Warm Orange Tint
  static const Color surface = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B); // Slate 800
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  
  static ThemeData get theme {
    return ThemeData(
      primaryColor: primary,
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: background,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.orange,
      ).copyWith(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        filled: true,
        fillColor: surface,
      ),
    );
  }
}

