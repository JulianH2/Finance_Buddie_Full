import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  int _paletteIndex = 0;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  int get paletteIndex => _paletteIndex;

  Color get primaryColor => const Color(0xFF2D3A5F); // Azul oscuro profesional
  Color get primaryLight => const Color(0xFF4D5F8E); // Azul medio
  Color get primaryDark => const Color(0xFF1A2340); // Azul muy oscuro
  Color get secondaryColor => const Color(0xFF116466); // Verde azulado oscuro
  Color get accentColor => const Color(0xFF8C4B45); // Rojo oscuro profesional
  Color get borderColor => Colors.grey[400]!;
  Color get goldAccent =>
      const Color(0xFFB68D40); // Dorado más apagado y sofisticado
  Color get tealAccent => const Color(0xFF0F7173); // Verde azulado más oscuro

  Color get _lightBackground =>
      const Color(0xFFF5F7FA); // Gris muy claro con tono azulado
  Color get _lightSurface => Colors.white;
  Color get _lightText =>
      const Color(0xFF202734); // Casi negro con tono azulado
  Color get _lightHintText => const Color(0xFF6E7685); // Gris medio profesional
  Color get _lightError => const Color(0xFF993333); // Rojo más oscuro
  Color get _lightSuccess =>
      const Color(0xFF2A6350); // Verde oscuro profesional
  Color get _lightWarning =>
      const Color(0xFFAD7D37); // Naranja/ámbar profesional

  Color get _darkBackground =>
      const Color(0xFF10151E); // Azul oscuro casi negro
  Color get _darkSurface => const Color(0xFF1A2130); // Azul oscuro grisáceo
  Color get _darkText => const Color(0xFFE6EAF0); // Blanco ligeramente azulado
  Color get _darkHintText => const Color(0xFF9AA0B0); // Gris claro profesional
  Color get _darkError => const Color(0xFFB05A5A); // Rojo más suave
  Color get _darkSuccess => const Color(0xFF408876); // Verde más oscuro
  Color get _darkWarning => const Color(0xFFBD9555); // Ámbar suave

  Color get backgroundColor => isDarkMode ? _darkBackground : _lightBackground;
  Color get surfaceColor => isDarkMode ? _darkSurface : _lightSurface;
  Color get textColor => isDarkMode ? _darkText : _lightText;
  Color get textColorA => isDarkMode ? _lightText : _darkText;
  Color get hintTextColor => isDarkMode ? _darkHintText : _lightHintText;
  Color get errorColor => isDarkMode ? _darkError : _lightError;
  Color get successColor => isDarkMode ? _darkSuccess : _lightSuccess;
  Color get warningColor => isDarkMode ? _darkWarning : _lightWarning;
  Color get cardColor => isDarkMode ? const Color(0xFF202634) : Colors.white;
  Color get dividerColor =>
      isDarkMode ? const Color(0xFF2E3544) : const Color(0xFFDCE0E9);

  Color get iconColor => isDarkMode ? _darkText : _lightText;
  Color get disabledIconColor => isDarkMode ? _darkHintText : _lightHintText;

  Color get buttonColor =>
      secondaryColor; // Verde oscuro para botones principales
  Color get buttonTextColor =>
      Colors.white; // Texto blanco para mejor contraste
  Color get disabledButtonColor =>
      isDarkMode ? const Color(0xFF2D333F) : const Color(0xFFE2E5EC);

  Color get appBarColor => isDarkMode ? const Color(0xFF141C2B) : primaryColor;
  Color get appBarTextColor => Colors.white;
  Color get appBarIconColor => Colors.white;

  Color get inputFillColor =>
      isDarkMode ? const Color(0xFF1E2432) : const Color(0xFFEEF1F8);
  Color get inputBorderColor =>
      isDarkMode ? const Color(0xFF384052) : const Color(0xFFCCD0DA);
  Color get inputTextColor => isDarkMode ? _darkText : _lightText;
  Color get inputLabelColor => isDarkMode ? _darkHintText : _lightHintText;
  Color get inputErrorColor => isDarkMode ? _darkError : _lightError;

  Color get featuredPropertyBadgeColor => goldAccent;
  Color get availableIndicatorColor => successColor;
  Color get unavailableIndicatorColor => errorColor;
  Color get pendingIndicatorColor => warningColor;
  Color get premiumPropertyHighlightColor => goldAccent.withOpacity(0.15);

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void changePalette(int index) {
    if (index >= 0 && index <= 2) {
      _paletteIndex = index;
      notifyListeners();
    }
  }

  ThemeData get themeData {
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;

    final baseTextTheme = GoogleFonts.nunitoSansTextTheme();
    final headingTextTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        primaryContainer: primaryDark,
        secondary: secondaryColor,
        secondaryContainer: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColor,
        onBackground: textColor,
        onError: Colors.white,
      ),
      fontFamily: 'NunitoSans',
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      dividerColor: dividerColor,
      disabledColor: isDarkMode ? _darkHintText : _lightHintText,
      hintColor: hintTextColor,
      textTheme: TextTheme(
        displayLarge: headingTextTheme.displayLarge?.copyWith(
          color: textColor,
          letterSpacing: -1.5,
          fontWeight: FontWeight.w300,
          fontSize: 96,
        ),
        displayMedium: headingTextTheme.displayMedium?.copyWith(
          color: textColor,
          letterSpacing: -0.5,
          fontWeight: FontWeight.w300,
          fontSize: 60,
        ),
        displaySmall: headingTextTheme.displaySmall?.copyWith(
          color: textColor,
          letterSpacing: 0,
          fontWeight: FontWeight.w400,
          fontSize: 48,
        ),
        headlineMedium: headingTextTheme.headlineMedium?.copyWith(
          color: textColor,
          letterSpacing: 0.25,
          fontWeight: FontWeight.w400,
          fontSize: 34,
        ),
        headlineSmall: headingTextTheme.headlineSmall?.copyWith(
          color: textColor,
          letterSpacing: 0,
          fontWeight: FontWeight.w400,
          fontSize: 24,
        ),
        titleLarge: headingTextTheme.titleLarge?.copyWith(
          color: textColor,
          letterSpacing: 0.15,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: textColor,
          letterSpacing: 0.15,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        titleSmall: baseTextTheme.titleSmall?.copyWith(
          color: textColor,
          letterSpacing: 0.1,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: textColor,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: textColor,
          letterSpacing: 0.25,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          color: buttonTextColor,
          letterSpacing: 1.25,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: hintTextColor,
          letterSpacing: 0.4,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          color: hintTextColor,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w400,
          fontSize: 10,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: appBarColor,
        iconTheme: IconThemeData(color: appBarIconColor),
        titleTextStyle: GoogleFonts.poppins(
          color: appBarTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: inputErrorColor),
        ),
        labelStyle: GoogleFonts.nunitoSans(
          color: inputLabelColor,
          fontSize: 16,
        ),
        hintStyle: GoogleFonts.nunitoSans(color: inputLabelColor, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: buttonColor,
        disabledColor: disabledButtonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryColor, // Cambiado para ser más coherente
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      cardTheme: CardTheme(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      chipTheme: ChipThemeData(
        backgroundColor:
            isDarkMode ? const Color(0xFF242D3C) : const Color(0xFFECEFF5),
        disabledColor: disabledButtonColor,
        selectedColor: secondaryColor.withOpacity(0.2),
        secondarySelectedColor: secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: GoogleFonts.nunitoSans(fontSize: 14, color: textColor),
        secondaryLabelStyle: GoogleFonts.nunitoSans(
          fontSize: 14,
          color: Colors.white,
        ),
        brightness: brightness,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: secondaryColor,
        unselectedLabelColor: hintTextColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
