import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/models/pergunta.dart';

class Deck {
  static const String collection = "decks";

  final DocumentReference? id;
  final String nome;
  final List<DocumentReference> perguntasReferences;
  final List<Pergunta> _perguntas = [];

  Deck({required this.nome, required this.perguntasReferences, this.id});

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
        perguntasReferences: List.from(data?['perguntas']),
        id: snapshot.reference);
  }

  Map<String, dynamic> toFirestore() {
    return {"nome": nome, "perguntas": perguntasReferences};
  }

  Future<List<Pergunta>> get perguntas async {
    if (_perguntas.isEmpty && perguntasReferences.isNotEmpty) {
      List<List<DocumentReference>> sublist = [];
      for (var i = 0; i < perguntasReferences.length; i += 10) {
        sublist.add(perguntasReferences.sublist(
            i,
            i + 10 > perguntasReferences.length
                ? perguntasReferences.length
                : i + 10));
      }

      FirebaseFirestore db = FirebaseFirestore.instance;

      _perguntas.clear();
      sublist.forEach((sublista) async {
        await Pergunta.getCollection(db)
            .where(FieldPath.documentId, whereIn: perguntasReferences)
            .get()
            .then((value) => {
                  for (var pergunta in value.docs)
                    {_perguntas.add(pergunta.data() as Pergunta)}
                });
      });
    }
    return _perguntas;
  }

  atualizaReferencias(List<Pergunta> perguntas) {
    perguntasReferences.clear();
    for (var perg in perguntas) {
      perguntasReferences.add(perg.id!);
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
