/// ADHD-optimized high-contrast color palette.
///
/// Status colors are colorblind-safe. The [reward] color is
/// reserved exclusively for the confirmation confetti animation.
library;

import 'package:flutter/material.dart';

/// High-contrast, ADHD-friendly color constants.
class ADHDColors {
  ADHDColors._();

  // Status colors (high contrast, colorblind-safe)
  static const taken = Color(0xFF2E7D32);
  static const missed = Color(0xFFC62828);
  static const snoozed = Color(0xFFEF6C00);
  static const upcoming = Color(0xFF1565C0);
  static const neutral = Color(0xFF424242);

  // Background (low-stimulus)
  static const background = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const darkBackground = Color(0xFF121212);

  // Dark mode surfaces
  static const darkSurface = Color(0xFF1E1E1E);

  // Accent (dopamine trigger — used sparingly, confetti only)
  static const reward = Color(0xFFFFD600);

  // Gamification accents (§10.2)
  static const xpBar = Color(0xFF7C4DFF);
  static const streakActive = Color(0xFFFF6D00);
  static const achievementGold = Color(0xFFFFAB00);
}
