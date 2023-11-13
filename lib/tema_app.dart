import 'package:flutter/material.dart';

//As cores definidas como 'primary' são aquelas de tom mais escuro, usadas em backgrounds
//As cores definidas como 'secondary' são aquelas de tom mais claro, usadas em fontes daquelas cores

abstract class TemaApp {
  //Cores padrão
  static const Color lightPrimary = Color(0xFFB39DDB);
  static const Color darkPrimary = Color(0xFF654E92); //dark purple
  static const Color darkSecondary = Color(0xFF501CB0); //Shiny purple
  static const Color contrastPrimary = Colors.white;
  static const Color contrastSecondary = Color(0xFFFFD835);
  static const Color errorPrimary = Color(0xFFEF5350);
  static const Color branco = Colors.white;
  static const Color purple = Color.fromARGB(255, 101, 78, 146);

  //Cores específicas para cada atividade
  static const Color quizPrimary = Color(0xFF1C69B0);
  static const Color quizSecondary = Color(0xFF247CCE);
  static const Color quizTertiary = Color(0xFFDCEBF9);

  static const Color flashcardPrimary = Color(0xFF654E92);
  static const Color flashcardSecondary = Color(0xFF501CB0);

  static const Color kartPrimary = Color(0xFFB01C8B);
  static const Color kartSecondary = Color(0xFFCB119C);

  static const Color success = Colors.green;

  static const Color rankingFirst = Color(0xFFFBC02D);
  static const Color rankingSecond = Color(0xFF616161);
  static const Color rankingThird = Color(0xFFE65100);

  //Cores específicas para componentes
  static Color appBarPrimary = Color(
      0xFF654E92); //Color.fromARGB(255, 101, 78, 146); //Colors.deepPurple.shade600;
  static Color cardPrimary = Color(0xFFF5F5F5); //Color(0xFFECE4FD);

  //Tamanhos padrão
  static double titleSize = 22;

  static ThemeData get tema {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: darkPrimary,
        onPrimary: branco,
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
