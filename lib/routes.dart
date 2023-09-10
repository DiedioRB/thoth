import 'package:flutter/material.dart';
import 'package:thoth/views/cadastro_usuario.dart';
import 'package:thoth/views/cadastro_tema.dart';
import 'package:thoth/views/cadastro_topico.dart';
import 'package:thoth/views/login.dart';
import 'package:thoth/views/menu.dart';
import 'package:thoth/views/quizzes.dart';
import 'package:thoth/views/temas.dart';
import 'package:thoth/views/cadastro_quiz.dart';
import 'package:thoth/views/topicos.dart';
import 'package:thoth/views/cadastro_perguntas.dart';
import 'package:thoth/views/atividade_quiz.dart';

class Routes {
  static const String home = "/";
  static const String login = "/login";
  static const String menu = "/menu";
  static const String cadastroUsuario = "/cadastro";
  static const String quizzes = "/quizzes";
  static const String quizzesForm = "/quizzes/form";
  static const String cadastroQuiz = "/quizzes/cadastro";
  static const String temas = "/temas";
  static const String cadastroTema = "/temas/cadastro";
  static const String topicos = "/topicos";
  static const String cadastroTopico = "/topicos/cadastro";
  static const String cadastroPerguntas = "/perguntas/cadastro";
  static const String atividadeQuiz = "quizzes/quiz";

  static var routes = <String, WidgetBuilder>{
    home: (context) => const Login(),
    login: (context) => const Login(),
    cadastroUsuario: (context) => CadastroUsuario(),
    menu: (context) => const Menu(),
    quizzes: (context) => const Quizzes(),
    cadastroQuiz: (context) => const CadastroQuiz(),
    temas: (context) => const Temas(),
    cadastroTema: (context) => const CadastroTema(),
    topicos: (context) => const Topicos(),
    cadastroTopico: (context) => const CadastroTopico(),
    cadastroPerguntas: (context) => CadastroPerguntas(),
    atividadeQuiz: (context) => AtividadeQuiz()
  };
}
