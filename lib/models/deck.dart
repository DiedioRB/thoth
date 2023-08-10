import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/models/flashcard.dart';

class Deck {
  static const String collection = "decks";

  final String nome;
  final List<Flashcard> cards;
  //TODO: puxar os cards corretamente

  Deck({required this.nome, required this.cards});

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Deck>(
        fromFirestore: Deck.fromFirestore,
        toFirestore: (Deck item, _) => item.toFirestore());
  }

  factory Deck.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Deck(nome: data?['nome'], cards: List.from(data?['cards']));
  }

  Map<String, dynamic> toFirestore() {
    return {"nome": nome, "cards": cards};
  }
}
