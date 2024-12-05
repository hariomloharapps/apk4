import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF000000), // Pure black
      surfaceTint: Color(0xFF000000),
      onPrimary: Color(0xFFFFFFFF), // Pure white
      primaryContainer: Color(0xFFE0E0E0), // Light gray
      onPrimaryContainer: Color(0xFF000000),
      secondary: Color(0xFF404040), // Dark gray
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFF5F5F5), // Very light gray
      onSecondaryContainer: Color(0xFF000000),
      tertiary: Color(0xFF808080), // Medium gray
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFEEEEEE), // Light gray
      onTertiaryContainer: Color(0xFF000000),
      error: Color(0xFF000000),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFE0E0E0),
      onErrorContainer: Color(0xFF000000),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF000000),
      onSurfaceVariant: Color(0xFF404040),
      outline: Color(0xFFD0D0D0),
      outlineVariant: Color(0xFFE0E0E0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF000000),
      inversePrimary: Color(0xFFFFFFFF),
      primaryFixed: Color(0xFFE0E0E0),
      onPrimaryFixed: Color(0xFF000000),
      primaryFixedDim: Color(0xFFC0C0C0),
      onPrimaryFixedVariant: Color(0xFF000000),
      secondaryFixed: Color(0xFFF5F5F5),
      onSecondaryFixed: Color(0xFF000000),
      secondaryFixedDim: Color(0xFFE0E0E0),
      onSecondaryFixedVariant: Color(0xFF000000),
      tertiaryFixed: Color(0xFFEEEEEE),
      onTertiaryFixed: Color(0xFF000000),
      tertiaryFixedDim: Color(0xFFD0D0D0),
      onTertiaryFixedVariant: Color(0xFF000000),
      surfaceDim: Color(0xFFF5F5F5),
      surfaceBright: Color(0xFFFFFFFF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFAFAFA),
      surfaceContainer: Color(0xFFF5F5F5),
      surfaceContainerHigh: Color(0xFFEEEEEE),
      surfaceContainerHighest: Color(0xFFE0E0E0),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFFFFF), // Pure white
      surfaceTint: Color(0xFFFFFFFF),
      onPrimary: Color(0xFF000000), // Pure black
      primaryContainer: Color(0xFF404040), // Dark gray
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondary: Color(0xFFE0E0E0), // Light gray
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFF2A2A2A), // Very dark gray
      onSecondaryContainer: Color(0xFFFFFFFF),
      tertiary: Color(0xFFC0C0C0), // Medium light gray
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFF333333), // Dark gray
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFFFFFFFF),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFF404040),
      onErrorContainer: Color(0xFFFFFFFF),
      surface: Color(0xFF000000),
      onSurface: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFFE0E0E0),
      outline: Color(0xFF404040),
      outlineVariant: Color(0xFF2A2A2A),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFFFFFFF),
      inversePrimary: Color(0xFF000000),
      primaryFixed: Color(0xFF404040),
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: Color(0xFF2A2A2A),
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: Color(0xFF2A2A2A),
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: Color(0xFF1A1A1A),
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFF333333),
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: Color(0xFF1F1F1F),
      onTertiaryFixedVariant: Color(0xFFFFFFFF),
      surfaceDim: Color(0xFF000000),
      surfaceBright: Color(0xFF1A1A1A),
      surfaceContainerLowest: Color(0xFF000000),
      surfaceContainerLow: Color(0xFF0A0A0A),
      surfaceContainer: Color(0xFF1A1A1A),
      surfaceContainerHigh: Color(0xFF2A2A2A),
      surfaceContainerHighest: Color(0xFF333333),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    // Add modern styling
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline,
          width: 1,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: colorScheme.surfaceContainer,
    ),
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily dark;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.dark,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}