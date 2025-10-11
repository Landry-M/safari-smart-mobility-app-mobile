import 'package:flutter/material.dart';

/// Palette de couleurs basée sur l'interface Safari
/// Couleurs principales: Violet Safari et accents
class AppColors {
  // Couleurs principales de l'interface Safari
  static const Color primaryPurple =
      Color(0xFF6A4C9C); // Violet Safari principal - Renforcé
  static const Color primaryOrange = Color(0xFFFF6B35); // Orange accent Safari

  // Variations du violet
  static const Color lightPurple = Color(0xFF8B6BB8);
  static const Color darkPurple = Color(0xFF4A2F6F);
  static const Color accentPurple = Color(0xFF7B5DB8);

  // Variations de l'orange
  static const Color lightOrange = Color(0xFFFF8A65);
  static const Color darkOrange = Color(0xFFE65100);
  static const Color accentOrange = Color(0xFFFF7043);

  // Couleurs neutres
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF424242);

  // Couleurs de statut
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Couleurs de fond
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Couleurs de texte
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF000000);
  static const Color textHint = Color(0xFF000000);

  // Couleurs pour les modes sombres (pour usage futur)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
}
