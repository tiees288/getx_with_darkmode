import 'package:flutter/material.dart';

class ExtraColor extends ThemeExtension<ExtraColor> {
  static ExtraColor? _instance;
  static ExtraColor get instance {
    _instance ??= ExtraColor._init();
    return _instance!;
  }

  ExtraColor._init();

  Color get primary => const Color(0xFF6200EE);
  Color get primaryVariant => const Color(0xFF3700B3);
  Color get secondary => const Color(0xFF03DAC6);
  Color get secondaryVariant => const Color(0xFF018786);
  Color get background => const Color(0xFF121212);
  Color get surface => const Color(0xFF121212);
  Color get error => const Color(0xFFCF6679);
  Color get onPrimary => const Color(0xFFFFFFFF);
  Color get onSecondary => const Color(0xFF000000);
  Color get onBackground => const Color(0xFFFFFFFF);
  Color get onSurface => const Color(0xFFFFFFFF);
  Color get onError => const Color(0xFF000000);
  Color get shadow => const Color(0x1F000000);
  Color get black => const Color(0xFF000000);
  Color get white => const Color(0xFFFFFFFF);

  @override
  ThemeData get lightTheme => ThemeData.light().copyWith(
        primaryColor: primary,
        primaryColorDark: primaryVariant,
        secondaryHeaderColor: secondary,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.light(
          primary: primary,
          primaryContainer: primaryVariant,
          secondary: secondary,
          secondaryContainer: secondaryVariant,
          surface: surface,
          error: error,
          onPrimary: onPrimary,
          onSecondary: onSecondary,
          onSurface: onSurface,
          onError: onError,
        ),
        shadowColor: shadow,
        canvasColor: surface,
        cardColor: surface,
        dividerColor: onSurface.withOpacity(0.12),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primary,
          selectionColor: primary.withOpacity(0.4),
          selectionHandleColor: primary,
        ),
        appBarTheme: AppBarTheme(
          color: background,
          elevation: 0,
          iconTheme: IconThemeData(color: onBackground),
        ),
      );

  @override
  ExtraColor copyWith({
    Color? primary,
    Color? primaryVariant,
    Color? secondary,
    Color? secondaryVariant,
    Color? background,
    Color? surface,
    Color? error,
    Color? onPrimary,
    Color? onSecondary,
    Color? onBackground,
    Color? onSurface,
    Color? onError,
    Color? shadow,
    Color? black,
    Color? white,
  }) {
    return ExtraColor._init();
  }

  @override
  ExtraColor lerp(ThemeExtension<ExtraColor>? other, double t) {
    if (other is! ExtraColor) return this;
    return ExtraColor._init();
  }
}
