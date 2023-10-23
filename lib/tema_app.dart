import 'package:flutter/material.dart';

//As cores definidas como 'primary' são aquelas de tom mais escuro, usadas em backgrounds
//As cores definidas como 'secondary' são aquelas de tom mais claro, usadas em fontes daquelas cores


abstract class TemaApp {
  //Cores padrão
  static Color lightPrimary = Colors.deepPurple.shade200;
  static Color darkPrimary =  Color(0xFF654E92); //dark purple
  static Color darkSecondary = Color(0xFF501CB0); //Shiny purple
  static Color contrastPrimary = Colors.white;
  static Color contrastSecondary = Colors.yellow.shade600;
  static Color errorPrimary = Colors.red.shade400;
  static Color branco = Colors.white;
  static Color purple = Color.fromARGB(255, 101, 78, 146);

  //Cores específicas para cada atividade
  static Color quizPrimary = Color(0xFF1C69B0);
  static Color quizSecondary = Color(0xFF247CCE);
  static Color quizTerciary = Color(0xFFDCEBF9);

  static Color flashcardPrimary = Color(0xFF654E92);
  static Color flashcardSecondary = Color(0xFF501CB0);

  static Color kartPrimary = Color(0xFFB01C8B);
  static Color kartSecondary = Color(0xFFCB119C);

  //Cores específicas para componentes
  static Color appBarPrimary = Color(0xFF654E92); //Color.fromARGB(255, 101, 78, 146); //Colors.deepPurple.shade600;
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
