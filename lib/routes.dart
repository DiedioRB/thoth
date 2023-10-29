import 'package:flutter/material.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/views/cadastro_usuario.dart';
import 'package:thoth/views/cadastro_tema.dart';
import 'package:thoth/views/cadastro_topico.dart';
import 'package:thoth/views/kart.dart';
import 'package:thoth/views/login.dart';
import 'package:thoth/views/menu.dart';
import 'package:thoth/views/quizzes.dart';
import 'package:thoth/views/temas.dart';
import 'package:thoth/views/cadastro_quiz.dart';
import 'package:thoth/views/topicos.dart';
import 'package:thoth/views/cadastro_perguntas.dart';
import 'package:thoth/views/atividade_quiz.dart';
import 'package:thoth/views/pontuacao.dart';
import 'package:thoth/views/flashcards.dart';
import 'package:thoth/views/decks.dart';
import 'package:thoth/views/cadastro_deck.dart';
import 'package:thoth/views/atividade_flashcard.dart';
import 'package:thoth/views/ver_perfil.dart';
import 'package:thoth/views/editar_perfil.dart';

class Routes {
  static const String home = "/";
  static const String login = "/login";
  static const String menu = "/menu";
  static const String cadastroUsuario = "/cadastro";
  static const String quizzes = "/quizzes";
  static const String flashcards = "/flashcards";
  static const String quizzesForm = "/quizzes/form";
  static const String cadastroQuiz = "/quizzes/cadastro";
  static const String temas = "/temas";
  static const String cadastroTema = "/temas/cadastro";
  static const String topicos = "/topicos";
  static const String cadastroTopico = "/topicos/cadastro";
  static const String cadastroPerguntas = "/perguntas/cadastro";
  static const String atividadeQuiz = "/quizzes/quiz";
  static const String pontuacao = "/quizzes/quiz/resultado";
  static const String kart = "/kart";
  static const String decks = "/decks";
  static const String cadastroDeck = "/decks/cadastro";
  static const String atividadeFlashcard = "/flashcards/atividade";
  static const String perfil = "/perfil";
  static const String editarPerfil = "/perfil/editar";

  static routes(RouteSettings settings) {
    return <String, WidgetBuilder>{
      home: (context) => const Login(),
      login: (context) => const Login(),
      cadastroUsuario: (context) => CadastroUsuario(),
      menu: (context) => const Menu(),
      quizzes: (context) => Quizzes(topico: settings.arguments as Topico?),
      flashcards: (context) => Flashcards(tema: settings.arguments as Tema?),
      cadastroQuiz: (context) => const CadastroQuiz(),
      temas: (context) => Temas(isAdmin: settings.arguments as bool?),
      cadastroTema: (context) => const CadastroTema(),
      topicos: (context) => Topicos(
            tema: (settings.arguments as List?)?[0],
            isAdmin: (settings.arguments as List?)?[1],
          ),
      cadastroTopico: (context) => const CadastroTopico(),
      cadastroPerguntas: (context) => CadastroPerguntas(),
      atividadeQuiz: (context) =>
          AtividadeQuiz(listaPerguntas: settings.arguments as List<Pergunta>),
      pontuacao: (context) => Pontuacao(
        pontos: (settings.arguments as List?)?[0],
        cor: (settings.arguments as List?)?[1],
      ),
      kart: (context) => const Kart(),
      decks: (context) => const Decks(),
      cadastroDeck: (context) => const CadastroDeck(),
      perfil: (context) => const VerPerfil(),
      editarPerfil: (context) => const EditarPerfil(),
      atividadeFlashcard: (context) => AtividadeFlashcard(
          topico: (settings.arguments as List?)?[0],
          deck: (settings.arguments as List?)?[1],
      ),
    };
  }
}
