import 'package:flutter/material.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/views/tela_cadastro.dart';
import 'package:thoth/views/tela_cadastro_tema.dart';
import 'package:thoth/views/tela_cadastro_topico.dart';
import 'package:thoth/views/tela_flashcards.dart';
import 'package:thoth/views/tela_login.dart';
import 'package:thoth/views/tela_menu.dart';
import 'package:thoth/views/tela_quizzes.dart';
import 'package:thoth/views/tela_temas.dart';
import 'package:thoth/views/tela_cadastro_quiz.dart';
import 'package:thoth/views/tela_topicos.dart';
import 'package:thoth/views/tela_cadastro_perguntas.dart';

class Routes {
  static const String home = "/";
  static const String login = "/login";
  static const String menu = "/menu";
  static const String cadastro = "/cadastro";
  static const String quizzes = "/quizzes";
  static const String flashcards = "/flashcards";
  static const String quizzesForm = "/quizzes/form";
  static const String cadastroQuiz = "/quizzes/cadastro";
  static const String temas = "/temas";
  static const String cadastroTema = "/temas/cadastro";
  static const String topicos = "/topicos";
  static const String cadastroTopico = "/topicos/cadastro";
  static const String cadastroPerguntas = "perguntas/cadastro";
  //static const String editarQuiz = "/quizzes/editar"; - Comentado para verificar a necessidade

  static routes(RouteSettings settings) {
    return <String, WidgetBuilder>{
      home: (context) => const Login(),
      login: (context) => const Login(),
      cadastro: (context) => Cadastro(),
      menu: (context) => const Menu(),
      quizzes: (context) => Quizzes(topico: settings.arguments as Topico?),
      flashcards: (context) => Flashcards(tema: settings.arguments as Tema?),
      cadastroQuiz: (context) => const CadastroQuiz(),
      temas: (context) => const Temas(),
      cadastroTema: (context) => const CadastroTema(),
      topicos: (context) => Topicos(tema: settings.arguments as Tema?),
      cadastroTopico: (context) => const CadastroTopico(),
      cadastroPerguntas: (context) => CadastroPerguntas()
    };
  }
}
