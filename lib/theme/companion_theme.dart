import 'package:flutter/material.dart';

class CompanionTheme {
  static const Color primaryPurple = Colors.purple;
  static const Color primaryPink = Colors.pink;
  static const Color backgroundColor = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1C1C1E);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryPink],
  );

  static BoxDecoration gradientBoxDecoration({
    double opacity = 1.0,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          primaryPurple.withOpacity(opacity),
          primaryPink.withOpacity(opacity),
        ],
      ),
      borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
      shape: shape,
      boxShadow: [
        BoxShadow(
          color: primaryPurple.withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    );
  }

  static ThemeData getThemeData() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      dialogTheme: const DialogTheme(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPurple,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}