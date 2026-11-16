import 'package:flutter/material.dart';

import '../dominio/nivel.dart';

/// Paleta violeta "coquette" de Habla Fluido: lavanda, ciruela y rosa empolvado.
class Paleta {
  static const violeta = Color(0xFF6B4BA1); // principal
  static const ciruela = Color(0xFF3B2A5A); // títulos y texto fuerte
  static const lila = Color(0xFFEDE4F8); // fondos suaves
  static const lavanda = Color(0xFFF8F4FC); // fondo general
  static const rosa = Color(0xFFE9A8C2); // acento coquette
  static const rosaClaro = Color(0xFFFBE7EF);
  static const texto = Color(0xFF2E2440);
  static const suave = Color(0xFF8C7DA6); // texto secundario
  static const borde = Color(0xFFE8DFF2);

  // Retroalimentación (suaves, pero siempre acompañadas de texto)
  static const bien = Color(0xFF2F8F6B);
  static const casi = Color(0xFFC07A2C);
  static const mal = Color(0xFFC2456B);
  static const sobra = Color(0xFF9A90A8);
}

/// Ícono y color de cada habilidad, para usarlos igual en toda la app.
IconData iconoDe(Habilidad h) => switch (h) {
      Habilidad.escucha => Icons.headphones_rounded,
      Habilidad.pronunciacion => Icons.record_voice_over_rounded,
      Habilidad.lectura => Icons.menu_book_rounded,
      Habilidad.escritura => Icons.edit_note_rounded,
      Habilidad.conversacion => Icons.forum_rounded,
    };

class TemaHabla {
  static ThemeData get claro {
    const esquema = ColorScheme(
      brightness: Brightness.light,
      primary: Paleta.violeta,
      onPrimary: Colors.white,
      primaryContainer: Paleta.lila,
      onPrimaryContainer: Paleta.ciruela,
      secondary: Paleta.rosa,
      onSecondary: Paleta.ciruela,
      secondaryContainer: Paleta.rosaClaro,
      onSecondaryContainer: Paleta.ciruela,
      error: Paleta.mal,
      onError: Colors.white,
      errorContainer: Paleta.rosaClaro,
      onErrorContainer: Color(0xFF7A1F3D),
      surface: Colors.white,
      onSurface: Paleta.texto,
      onSurfaceVariant: Paleta.suave,
      outline: Paleta.borde,
    );

    final redondo = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: Paleta.lavanda,
      appBarTheme: const AppBarTheme(
        backgroundColor: Paleta.lavanda,
        foregroundColor: Paleta.ciruela,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Paleta.ciruela,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Paleta.borde),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Paleta.violeta,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Paleta.lila,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: redondo,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Paleta.violeta,
          side: const BorderSide(color: Paleta.violeta),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: redondo,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Paleta.violeta),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Paleta.suave),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Paleta.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Paleta.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Paleta.violeta, width: 1.6),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Paleta.violeta,
        linearTrackColor: Paleta.lila,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Paleta.ciruela,
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(color: Paleta.borde),
    );
  }
}
