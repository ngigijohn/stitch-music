import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Palette ────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const Color background            = Color(0xFF120B1A);
  static const Color surface               = Color(0xFF120B1A);
  static const Color surfaceContainerLowest = Color(0xFF000000);
  static const Color surfaceContainerLow   = Color(0xFF171021);
  static const Color surfaceContainer      = Color(0xFF1E152A);
  static const Color surfaceContainerHigh  = Color(0xFF251B33);
  static const Color surfaceContainerHighest = Color(0xFF2C203C);

  static const Color primary               = Color(0xFFDACDFF);
  static const Color onPrimary             = Color(0xFF4D4078);
  static const Color primaryContainer      = Color(0xFFCDBDFF);
  static const Color onPrimaryContainer    = Color(0xFF44376F);
  static const Color primaryDim            = Color(0xFFBFB0F0);

  static const Color secondary             = Color(0xFFBCCBB1);
  static const Color onSecondary           = Color(0xFF364430);
  static const Color secondaryContainer    = Color(0xFF1C2917);

  // Tertiary: the "neon green" accent
  static const Color tertiary              = Color(0xFFEEFFDD);
  static const Color onTertiary            = Color(0xFF3B6A1D);
  static const Color tertiaryContainer     = Color(0xFFC3FB9C);
  static const Color onTertiaryContainer   = Color(0xFF336215);

  static const Color onBackground          = Color(0xFFF0DFFF);
  static const Color onSurface             = Color(0xFFF0DFFF);
  static const Color onSurfaceVariant      = Color(0xFFB5A4C8);
  static const Color outlineVariant        = Color(0xFF504260);
  static const Color outline               = Color(0xFF7E6F90);
  static const Color surfaceBright         = Color(0xFF332646);

  // Glassmorphism helper
  static Color glassPanel = const Color(0xFF2C203C).withValues(alpha: 0.70);
}

// ─── ColorScheme ────────────────────────────────────────────────────────────
const ColorScheme kColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary:              AppColors.primary,
  onPrimary:            AppColors.onPrimary,
  primaryContainer:     AppColors.primaryContainer,
  onPrimaryContainer:   AppColors.onPrimaryContainer,
  secondary:            AppColors.secondary,
  onSecondary:          AppColors.onSecondary,
  secondaryContainer:   AppColors.secondaryContainer,
  onSecondaryContainer: Color(0xFF99A990),
  tertiary:             AppColors.tertiary,
  onTertiary:           AppColors.onTertiary,
  tertiaryContainer:    AppColors.tertiaryContainer,
  onTertiaryContainer:  AppColors.onTertiaryContainer,
  error:                Color(0xFFFD6F85),
  onError:              Color(0xFF490013),
  errorContainer:       Color(0xFF8A1632),
  onErrorContainer:     Color(0xFFFF97A3),
  surface:              AppColors.surface,
  onSurface:            AppColors.onSurface,
  onSurfaceVariant:     AppColors.onSurfaceVariant,
  outline:              AppColors.outline,
  outlineVariant:       AppColors.outlineVariant,
  shadow:               Colors.black,
  scrim:                Colors.black,
  inverseSurface:       Color(0xFFFFF7FF),
  onInverseSurface:     Color(0xFF5A5263),
  inversePrimary:       Color(0xFF645690),
  surfaceTint:          AppColors.primary,
);

// ─── Typography ─────────────────────────────────────────────────────────────
TextTheme _buildTextTheme() {
  const base = TextStyle(color: AppColors.onSurface);
  return TextTheme(
    displayLarge:   GoogleFonts.epilogue(textStyle: base.copyWith(fontSize: 57, fontWeight: FontWeight.w900, letterSpacing: -0.25)),
    displayMedium:  GoogleFonts.epilogue(textStyle: base.copyWith(fontSize: 45, fontWeight: FontWeight.w900)),
    displaySmall:   GoogleFonts.epilogue(textStyle: base.copyWith(fontSize: 36, fontWeight: FontWeight.w800)),
    headlineLarge:  GoogleFonts.epilogue(textStyle: base.copyWith(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
    headlineMedium: GoogleFonts.epilogue(textStyle: base.copyWith(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
    headlineSmall:  GoogleFonts.epilogue(textStyle: base.copyWith(fontSize: 24, fontWeight: FontWeight.w700)),
    titleLarge:     GoogleFonts.epilogue(textStyle: base.copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
    titleMedium:    GoogleFonts.manrope(textStyle: base.copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15)),
    titleSmall:     GoogleFonts.manrope(textStyle: base.copyWith(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1)),
    bodyLarge:      GoogleFonts.manrope(textStyle: base.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
    bodyMedium:     GoogleFonts.manrope(textStyle: base.copyWith(fontSize: 14, fontWeight: FontWeight.w400)),
    bodySmall:      GoogleFonts.manrope(textStyle: base.copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
    labelLarge:     GoogleFonts.manrope(textStyle: base.copyWith(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.1)),
    labelMedium:    GoogleFonts.manrope(textStyle: base.copyWith(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    labelSmall:     GoogleFonts.manrope(textStyle: base.copyWith(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
  );
}

// ─── ThemeData ───────────────────────────────────────────────────────────────
ThemeData buildAppTheme({bool highContrast = false}) {
  final text = _buildTextTheme();
  final colorScheme = highContrast
      ? kColorScheme.copyWith(
          primary: Colors.white,
          onPrimary: Colors.black,
          surface: const Color(0xFF060507),
          onSurface: Colors.white,
          onSurfaceVariant: const Color(0xFFE6E1EE),
          outline: Colors.white,
          outlineVariant: const Color(0xFFB5AFBF),
        )
      : kColorScheme;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: text,

    // AppBar — transparent by default, no elevation tint
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: text.titleLarge?.copyWith(color: AppColors.primary),
      iconTheme: const IconThemeData(color: AppColors.onSurface),
    ),

    // Cards — no elevation borders, XL radius
    cardTheme: CardThemeData(
      color: AppColors.surfaceContainerLow,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: EdgeInsets.zero,
    ),

    // Icon
    iconTheme: const IconThemeData(color: AppColors.onSurface, size: 24),

    // NavigationBar — we use a custom widget but set a theme fallback
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceContainerHighest.withValues(alpha: 0.70),
      indicatorColor: AppColors.primary.withValues(alpha: 0.20),
      height: 72,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
          letterSpacing: 0.2,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
          size: 24,
        );
      }),
    ),

    // Filled Button
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        textStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      ),
    ),

    // Slider
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.outlineVariant,
      thumbColor: AppColors.onSurface,
      overlayColor: Color(0x1ADACDFF),
      trackHeight: 3,
    ),

    // Input decoration (search bars)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceContainerHigh,
      selectedColor: AppColors.primaryContainer,
      labelStyle: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      side: BorderSide.none,
    ),
  );
}
