import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/tema.dart';

class Flashcard {
  static const String collection = "flashcards";

  final DocumentReference? id;
  final DocumentReference tema;
  final List<DocumentReference> perguntasReferences;
  Tema? _tema;
  final List<Pergunta> _perguntas = [];

  Flashcard({required this.tema, required this.perguntasReferences, this.id});

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
    List<DocumentReference> perguntas = [];
    for (var pergunta in data?['perguntas']) {
      perguntas.add(pergunta);
    }
    return Flashcard(
        tema: data?['tema'],
        perguntasReferences: perguntas,
        id: snapshot.reference);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "tema": tema,
      "perguntas": perguntasReferences,
    };
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
    for (var pergunta in perguntas) {
      perguntasReferences.add(pergunta.id!);
    }
  }

  create() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Flashcard.getCollection(db).doc(id?.id).set(this);
  }

  update() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Flashcard.getCollection(db).doc(id?.id).update(toFirestore());
  }

  delete() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Flashcard.getCollection(db).doc(id?.id).delete();
  }

  @override
  String toString() {
    return "${_tema?.descricao}: ${perguntasReferences.length} respostas";
  }
}
