import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens and theme definitions for Knocksy.
///
/// Never hard-code spacing, radii, colours or animation durations in feature
/// code — always reference these tokens so the dashboard stays visually
/// coherent and easy to retheme.
class AppConst {
  AppConst._();

  // ---------------------------------------------------------------- Spacing
  static const double padding = 15.0;

  // ----------------------------------------------------------------- Radii
  static const double radius = 12.0;
  static const double radiusSmall = 6.0;

  static final BorderRadius borderRadius = BorderRadius.circular(radius);
  static const BorderRadius borderRadiusTopOnly = BorderRadius.only(
    topLeft: Radius.circular(radius),
    topRight: Radius.circular(radius),
  );

  // ------------------------------------------------------------ Animation
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(milliseconds: 2200);
  static const Cubic curves = Curves.easeInOut;

  // --------------------------------------------------------------- Shadows
  static const BoxShadow boxShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  );

  static const BoxShadow softShadow = BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  // --------------------------------------------------------------- Colours
  // Knocksy brand palette — exact tokens from the Figma file.
  static const Color primary = Color(0xffF5530B); // signature Knocksy orange

  // Primary CTA on white sheets — bright trust-blue.
  static const Color accent = Color(0xff2A86E0);

  static const Color appBlack = Color(0xff0B0B1E); // primary text

  static const Color lightGray = Color(0xffF9F9F9); // light panel bg
  static const Color gray = Color(0xffCAD5E3); // card borders / dividers
  static const Color darkGray = Color(0xff65657B); // secondary text

  static const Color lightBackgroundColour = Color(0xffFDFDFD);

  // Used internally by the theme builder for ink ripples / text selection.
  static const Color splashColor = Color(0xff838383);
  static const Color hoverColor = Color(0x331F3A5F);

  static const Color success = Color(0xff04D386);
  static const Color warning = Color(0xffFFAE2C);
  static const Color errorColor = Color(0xffE03A3A);

  // ------------------------------------------------------------ Typography
  // Built lazily so Google Fonts can resolve correctly at runtime.
  static TextStyle get t1 => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get t2 => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  // ------------------------------------------------------------------ Misc
  static const ScrollPhysics scrollPhysics = BouncingScrollPhysics();

  // --------------------------------------------------------------- Themes
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: false);
    return base.copyWith(
      brightness: Brightness.light,
      primaryColor: primary,
      canvasColor: lightBackgroundColour,
      scaffoldBackgroundColor: lightBackgroundColour,
      splashColor: splashColor,
      hoverColor: hoverColor,
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        secondary: accent,
        error: errorColor,
        surface: lightBackgroundColour,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: accent,
        selectionColor: hoverColor,
        selectionHandleColor: hoverColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: appBlack,
        displayColor: appBlack,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightBackgroundColour,
        surfaceTintColor: lightBackgroundColour,
        titleTextStyle: GoogleFonts.poppins(
          color: appBlack,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: appBlack, size: 24),
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: accent),
    );
  }
}
