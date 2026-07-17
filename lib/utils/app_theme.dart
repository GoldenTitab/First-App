import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary900 = Color(0xFF0A0E36);
  static const Color primary800 = Color(0xFF111752);
  static const Color primary700 = Color(0xFF161E6A);
  static const Color primary600 = Color(0xFF1A2375);
  static const Color primary500 = Color(0xFF1D2780);
  static const Color primary400 = Color(0xFF4A52A0);
  static const Color primary300 = Color(0xFF7880BF);
  static const Color primary200 = Color(0xFFABB0D9);
  static const Color primary100 = Color(0xFFD5D8EE);
  static const Color primary50 = Color(0xFFEAEBF7);

  // Secondary
  static const Color secondary900 = Color(0xFF211F4A);
  static const Color secondary800 = Color(0xFF363472);
  static const Color secondary700 = Color(0xFF4A4892);
  static const Color secondary600 = Color(0xFF5856A2);
  static const Color secondary500 = Color(0xFF6765B2);
  static const Color secondary400 = Color(0xFF8A89C5);
  static const Color secondary300 = Color(0xFFABABD7);
  static const Color secondary200 = Color(0xFFCCCBE8);
  static const Color secondary100 = Color(0xFFE5E5F4);
  static const Color secondary50 = Color(0xFFF2F2FA);

  // Accent 1 (Gold/Orange)
  static const Color accent1_900 = Color(0xFF5C3800);
  static const Color accent1_800 = Color(0xFF8A5400);
  static const Color accent1_700 = Color(0xFFAD6B00);
  static const Color accent1_600 = Color(0xFFCC8800);
  static const Color accent1_500 = Color(0xFFF5A623);
  static const Color accent1_400 = Color(0xFFF7B94E);
  static const Color accent1_300 = Color(0xFFFACB7A);
  static const Color accent1_200 = Color(0xFFFCDDA8);
  static const Color accent1_100 = Color(0xFFFEEDD2);
  static const Color accent1_50 = Color(0xFFFFF6EC);

  // Accent 2 (Red)
  static const Color accent2_900 = Color(0xFF4A0D08);
  static const Color accent2_800 = Color(0xFF7A1812);
  static const Color accent2_700 = Color(0xFF9E251B);
  static const Color accent2_600 = Color(0xFFC03529);
  static const Color accent2_500 = Color(0xFFE74C3C);
  static const Color accent2_400 = Color(0xFFED7268);
  static const Color accent2_300 = Color(0xFFF39C95);
  static const Color accent2_200 = Color(0xFFF8C3BF);
  static const Color accent2_100 = Color(0xFFFCE1DF);
  static const Color accent2_50 = Color(0xFFFEF0EF);

  // Neutral
  static const Color neutral900 = Color(0xFF111316);
  static const Color neutral800 = Color(0xFF212529);
  static const Color neutral700 = Color(0xFF343A40);
  static const Color neutral600 = Color(0xFF495057);
  static const Color neutral500 = Color(0xFF6C757D);
  static const Color neutral400 = Color(0xFFADB5BD);
  static const Color neutral300 = Color(0xFFCED4DA);
  static const Color neutral200 = Color(0xFFDEE2E6);
  static const Color neutral100 = Color(0xFFF1F3F5);
  static const Color neutral50 = Color(0xFFF8F9FA);

  // Success
  static const Color success900 = Color(0xFF0B3D22);
  static const Color success800 = Color(0xFF145E34);
  static const Color success700 = Color(0xFF1C7D45);
  static const Color success600 = Color(0xFF219A52);
  static const Color success500 = Color(0xFF27AE60);
  static const Color success400 = Color(0xFF52C07D);
  static const Color success300 = Color(0xFF80D09F);
  static const Color success200 = Color(0xFFAEE2C3);
  static const Color success100 = Color(0xFFD4F0E0);
  static const Color success50 = Color(0xFFEAF8F0);

  // Error
  static const Color error900 = Color(0xFF4A0D08);
  static const Color error800 = Color(0xFF7A1812);
  static const Color error700 = Color(0xFF9E251B);
  static const Color error600 = Color(0xFFC03529);
  static const Color error500 = Color(0xFFE74C3C);
  static const Color error400 = Color(0xFFED7268);
  static const Color error300 = Color(0xFFF39C95);
  static const Color error200 = Color(0xFFF8C3BF);
  static const Color error100 = Color(0xFFFCE1DF);
  static const Color error50 = Color(0xFFFEF0EF);

  // Warning
  static const Color warning900 = Color(0xFF4F3000);
  static const Color warning800 = Color(0xFF7A4A00);
  static const Color warning700 = Color(0xFF9E6200);
  static const Color warning600 = Color(0xFFBF7B00);
  static const Color warning500 = Color(0xFFF39C12);
  static const Color warning400 = Color(0xFFF6B240);
  static const Color warning300 = Color(0xFFF9C870);
  static const Color warning200 = Color(0xFFFBDCA6);
  static const Color warning100 = Color(0xFFFDEDD2);
  static const Color warning50 = Color(0xFFFEF6EC);

  // Info
  static const Color info900 = Color(0xFF0D3050);
  static const Color info800 = Color(0xFF164D7E);
  static const Color info700 = Color(0xFF1E65A4);
  static const Color info600 = Color(0xFF267EC0);
  static const Color info500 = Color(0xFF3498DB);
  static const Color info400 = Color(0xFF5DB0E4);
  static const Color info300 = Color(0xFF8AC8ED);
  static const Color info200 = Color(0xFFB7DDF5);
  static const Color info100 = Color(0xFFD9EEF9);
  static const Color info50 = Color(0xFFECF6FD);

  // Dark Theme Specific Colors
  static const Color darkInputFill = Color(0xFF252848);
  static const Color darkInputBorder = Color(0xFF3A3D6A);
  static const Color darkCardBorder = Color(0xFF2E3058);
  static const Color darkSurfaceContainerHighest = Color(0xFF2A2C50);
  static const Color darkOutline = Color(0xFF3A3D6A);
  static const Color darkOutlineVariant = Color(0xFF2E3058);
}

class AppTheme {
  AppTheme._();

  static const Color primary = AppColors.primary500;
  static const Color secondary = AppColors.secondary500;
  static const Color info = AppColors.info500;
  static const Color warning = AppColors.warning500;
  static const Color error = AppColors.error500;
  static const Color success = AppColors.success500;
  static const Color accent1 = AppColors.accent1_500;
  static const Color accent2 = AppColors.accent2_500;

  static const Color surface = Color(0xFFF4F5FA);
  static const Color darkSurface = Color(0xFF1C1E2E);
  static const Color darkBackground = Color(0xFF12131F);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Vazir',
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primary100,
      onPrimaryContainer: AppColors.primary900,
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondary100,
      onSecondaryContainer: AppColors.secondary900,
      tertiary: accent1,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.accent1_100,
      onTertiaryContainer: AppColors.accent1_900,
      error: error,
      onError: Colors.white,
      errorContainer: AppColors.error100,
      onErrorContainer: AppColors.error900,
      surface: surface,
      onSurface: AppColors.neutral900,
      surfaceContainerHighest: AppColors.neutral100,
      outline: AppColors.neutral300,
      outlineVariant: AppColors.neutral200,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.neutral900,
      onInverseSurface: AppColors.neutral50,
      inversePrimary: AppColors.primary200,
    ),
    scaffoldBackgroundColor: surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Vazir',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 50),
        textStyle: const TextStyle(
          fontFamily: 'Vazir',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        textStyle: const TextStyle(fontFamily: 'Vazir', fontSize: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.neutral50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.neutral200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(
        color: AppColors.neutral400,
        fontFamily: 'Vazir',
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: AppColors.neutral300,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.primary100,
      labelStyle: const TextStyle(
        color: AppColors.primary700,
        fontFamily: 'Vazir',
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.neutral100,
      thickness: 1,
    ),
    badgeTheme: const BadgeThemeData(
      backgroundColor: error,
      textColor: Colors.white,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    fontFamily: 'Vazir',
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary300,
      onPrimary: AppColors.primary900,
      primaryContainer: AppColors.primary800,
      onPrimaryContainer: AppColors.primary100,
      secondary: AppColors.secondary300,
      onSecondary: AppColors.secondary900,
      secondaryContainer: AppColors.secondary800,
      onSecondaryContainer: AppColors.secondary100,
      tertiary: AppColors.accent1_300,
      onTertiary: AppColors.accent1_900,
      tertiaryContainer: AppColors.accent1_800,
      onTertiaryContainer: AppColors.accent1_100,
      error: AppColors.error300,
      onError: AppColors.error900,
      errorContainer: AppColors.error800,
      onErrorContainer: AppColors.error100,
      surface: darkSurface,
      onSurface: AppColors.neutral100,
      surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.neutral100,
      onInverseSurface: AppColors.neutral900,
      inversePrimary: AppColors.primary600,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: AppColors.neutral100,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Vazir',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.neutral100,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary400,
        foregroundColor: AppColors.primary900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 50),
        textStyle: const TextStyle(
          fontFamily: 'Vazir',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary300,
        textStyle: const TextStyle(fontFamily: 'Vazir', fontSize: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkInputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkInputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary300, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error300, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(
        color: AppColors.neutral600,
        fontFamily: 'Vazir',
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.darkCardBorder),
      ),
      color: darkSurface,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: AppColors.primary300,
      unselectedItemColor: AppColors.neutral600,
      type: BottomNavigationBarType.fixed,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.primary800,
      labelStyle: const TextStyle(
        color: AppColors.primary200,
        fontFamily: 'Vazir',
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkCardBorder,
      thickness: 1,
    ),
    badgeTheme: const BadgeThemeData(
      backgroundColor: AppColors.error400,
      textColor: Colors.white,
    ),
  );
}
