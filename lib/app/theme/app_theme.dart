/// Light and dark theme definitions for the app.
///
/// MiniMax fills in: ThemeData for light and dark modes,
/// using [ADHDColors] for the color scheme.
library;

import 'package:flutter/material.dart';

/// Provides light and dark [ThemeData] instances.
class AppTheme {
  AppTheme._();

  /// Light theme.
  static ThemeData get light {
    // TODO: MiniMax — define light theme using ADHDColors
    return ThemeData.light();
  }

  /// Dark theme.
  static ThemeData get dark {
    // TODO: MiniMax — define dark theme using ADHDColors
    return ThemeData.dark();
  }
}
