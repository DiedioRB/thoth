import 'package:flutter/material.dart';
import 'package:thoth/models/atividade.dart';
import 'package:thoth/models/deck.dart';
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
import 'package:thoth/views/ranking_tema.dart';
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
  static const String rankingTema = "/temas/ranking";

  static routes(RouteSettings settings) {
    return <String, WidgetBuilder>{
      home: (context) => const Login(),
      login: (context) => const Login(),
      cadastroUsuario: (context) => CadastroUsuario(),
      menu: (context) => const Menu(),
      quizzes: (context) => Quizzes(
          tema: (settings.arguments as List?)?[0] as Tema?,
          topico: (settings.arguments as List?)?[1] as Topico?,
          modifiable: (settings.arguments as List?)?[2] as bool),
      flashcards: (context) => Flashcards(
            tema: (settings.arguments as List?)?[0] as Tema?,
            deck: (settings.arguments as List?)?[1] as Deck?,
          ),
      cadastroQuiz: (context) => const CadastroQuiz(),
      temas: (context) => Temas(isAdmin: settings.arguments as bool?),
      cadastroTema: (context) => const CadastroTema(),
      topicos: (context) => Topicos(
            tema: (settings.arguments as List?)?[0] as Tema?,
            isAdmin: (settings.arguments as List?)?[1] as bool?,
          ),
      cadastroTopico: (context) => const CadastroTopico(),
      cadastroPerguntas: (context) =>
          CadastroPerguntas(tema: settings.arguments as Tema),
      atividadeQuiz: (context) => AtividadeQuiz(
            tema: (settings.arguments as List?)?[0] as Tema,
            perguntas: (settings.arguments as List?)?[1] as List<Pergunta>,
          ),
      pontuacao: (context) => Pontuacao(
            atividade: (settings.arguments as List?)?[0] as Atividade,
            cor: (settings.arguments as List?)?[1] as CorPontuacao,
          ),
      kart: (context) => Kart(
            tema: (settings.arguments as List?)?[0] as Tema,
            topico: (settings.arguments as List?)?[1] as Topico,
          ),
      decks: (context) => Decks(
            tema: (settings.arguments as List?)?[0] as Tema?,
            topico: (settings.arguments as List?)?[1] as Topico?,
          ),
      cadastroDeck: (context) => const CadastroDeck(),
      perfil: (context) => const VerPerfil(),
      editarPerfil: (context) => const EditarPerfil(),
      atividadeFlashcard: (context) => AtividadeFlashcard(
            tema: (settings.arguments as List?)?[0] as Tema?,
            topico: (settings.arguments as List?)?[1] as Topico?,
            deck: (settings.arguments as List?)?[2] as Deck?,
          ),
      rankingTema: (context) => RankingTema(tema: settings.arguments as Tema),
    };
  }
}
