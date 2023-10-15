import 'package:flutter/material.dart';

abstract class TemaApp {
  //Cores padrão
  static Color lightPrimary = Colors.deepPurple.shade200;
  static Color darkPrimary = Colors.deepPurple.shade800;
  static Color darkSecondary = Colors.deepPurple.shade600;
  static Color contrastPrimary = Colors.yellow.shade600;
  static Color contrastSecondary = Colors.yellow.shade600;
  static Color errorPrimary = Colors.red.shade400;
  static Color branco = Colors.white;
  static Color purple = Color.fromARGB(255, 101, 78, 146);

  //Cores específicas para componentes
  static Color appBarPrimary = Colors.deepPurple.shade600;
  static Color cardPrimary = Colors.purple.shade50;

  //Tamanhos padrão
  static double titleSize = 22;

  static ThemeData get tema {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: darkPrimary,
        onPrimary: contrastPrimary,
        secondary: darkSecondary,
        onSecondary: contrastSecondary,
        error: errorPrimary,
        onError: branco,
        background: branco,
        onBackground: darkSecondary,
        surface: branco,
        onSurface: darkSecondary,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: contrastPrimary,
        unselectedLabelColor: lightPrimary,
        indicatorColor: contrastPrimary,
      ),
      appBarTheme: AppBarTheme(
        color: appBarPrimary,
        iconTheme: IconThemeData(
          color: contrastPrimary,
        ),
        titleTextStyle: TextStyle(color: contrastPrimary, fontSize: titleSize),
      ),
      cardTheme: CardTheme(color: cardPrimary),
    );
  }
}
