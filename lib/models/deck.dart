import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/models/flashcard.dart';

class Deck {
  static const String collection = "decks";

  final DocumentReference? id;
  final String nome;
  final List<DocumentReference> cardsReferences;
  final List<Flashcard> _cards = [];

  Deck({required this.nome, required this.cardsReferences, this.id});

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
    return Deck(
        nome: data?['nome'],
        cardsReferences: List.from(data?['cards']),
        id: snapshot.reference);
  }

  Map<String, dynamic> toFirestore() {
    return {"nome": nome, "cards": cardsReferences};
  }

  Future<List<Flashcard>> get flashcards async {
    if (_cards.isEmpty && cardsReferences.isNotEmpty) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await Flashcard.getCollection(db)
          .where(FieldPath.documentId, whereIn: cardsReferences)
          .get()
          .then((value) => {
                _cards.clear(),
                for (var flashcard in value.docs)
                  {_cards.add(flashcard.data() as Flashcard)}
              });
    }
    return _cards;
  }

  atualizaReferencias(List<Flashcard> cards) {
    cardsReferences.clear();
    for (var card in cards) {
      cardsReferences.add(card.id!);
    }
  }

  create() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Deck.getCollection(db).doc(id?.id).set(this);
  }

  update() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Deck.getCollection(db).doc(id?.id).update(toFirestore());
  }

  delete() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Deck.getCollection(db).doc(id?.id).delete();
  }
}
