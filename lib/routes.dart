import 'package:flutter/material.dart';
import 'package:thoth/views/tela_cadastro.dart';
import 'package:thoth/views/tela_login.dart';
import 'package:thoth/views/tela_menu.dart';
import 'package:thoth/views/tela_quizzes.dart';
import 'package:thoth/views/tela_temas.dart';
import 'package:thoth/views/tela_teste_pergunta.dart';
import 'package:thoth/views/tela_cadastro_quiz.dart';

class Routes {
  static const String home = "/";
  static const String login = "/login";
  static const String menu = "/menu";
  static const String cadastro = "/cadastro";
  static const String quizzes = "/quizzes";
  static const String quizzesForm = "/quizzes/form";
  static const String cadastroQuiz = "/quizzes/cadastro";
  static const String perguntasTeste = "/perguntas/testes";
  static const String temas = "/temas";
  //static const String editarQuiz = "/quizzes/editar"; - Comentado para verificar a necessidade

  static var routes = <String, WidgetBuilder>{
    home: (context) => const Login(),
    login: (context) => const Login(),
    cadastro: (context) => Cadastro(),
    menu: (context) => const Menu(),
    quizzes: (context) => const Quizzes(),
    cadastroQuiz: (context) => const CadastroQuiz(),
    perguntasTeste: (context) => const PerguntaTeste(),
    temas: (context) => const Temas(),
    //perguntasTeste: (context) => PerguntaTeste()
  };
}
