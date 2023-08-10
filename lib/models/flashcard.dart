import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/tema.dart';

class Flashcard {
  //TODO: corrigir a obtenção para puxar o tema e as perguntas automaticamente
  //TODO: criar decks e tópicos
  static const String collection = "flashcards";

  final Tema tema;
  final List<Pergunta> perguntas;

  Flashcard({required this.tema, required this.perguntas});

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Flashcard>(
        fromFirestore: Flashcard.fromFirestore,
        toFirestore: (Flashcard item, _) => item.toFirestore());
  }

  factory Flashcard.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Flashcard(
        tema: data?['tema'],
        perguntas: (data?['perguntas'] is Iterable)
            ? List.from(data?['respostas'])
            : []);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "tema": tema,
      "perguntas": perguntas,
    };
  }

  @override
  String toString() {
    return "${tema.descricao}: ${perguntas.length} respostas";
  }
}
