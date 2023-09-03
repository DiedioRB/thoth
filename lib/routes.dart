import 'package:flutter/material.dart';
import 'package:thoth/views/tela_cadastro.dart';
import 'package:thoth/views/tela_login.dart';
import 'package:thoth/views/tela_menu.dart';
import 'package:thoth/views/tela_quizzes.dart';
import 'package:thoth/views/tela_cadastro_quiz.dart';
import 'package:thoth/views/tela_cadastro_perguntas.dart';

class Routes {
  static const String home = "/";
  static const String login = "/login";
  static const String menu = "/menu";
  static const String cadastro = "/cadastro";
  static const String quizzes = "/quizzes";
  static const String quizzesForm = "/quizzes/form";
  static const String cadastroQuiz = "/quizzes/cadastro";
  static const String cadastroPerguntas = "perguntas/cadastro";
  //static const String editarQuiz = "/quizzes/editar"; - Comentado para verificar a necessidade

  static var routes = <String, WidgetBuilder>{
    home: (context) => Login(),
    login: (context) => Login(),
    cadastro: (context) => Cadastro(),
    menu: (context) => const Menu(),
    quizzes: (context) => Quizzes(),
    cadastroQuiz: (context) => CadastroQuiz(),
    cadastroPerguntas: (context) => CadastroPerguntas()
  };
}
