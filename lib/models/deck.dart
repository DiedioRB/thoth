import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/models/interfaces/item_form.dart';

class Deck {
  static const String collection = "decks";

  final DocumentReference? id;
  final String nome;
  final List<DocumentReference> perguntasReferences;
  final List<Pergunta> _perguntas = [];
  DocumentReference? topicoReference;
  Topico? _topico;

  static List<ItemForm> getFields({Deck? deck}) {
    return [
      ItemForm.build(
          descricao: "nome",
          valor: deck?.nome
      )
    ];
  }

  Deck({
    required this.nome,
    required this.perguntasReferences,
    this.id,
    this.topicoReference
  });

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
    return {
      "nome": nome,
      "perguntas": perguntasReferences,
      "topico": topicoReference
    };
  }

  Future<List<Pergunta>> get perguntas async {
    if (_perguntas.isEmpty && perguntasReferences.isNotEmpty) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await Pergunta.getCollection(db)
          .where(FieldPath.documentId, whereIn: perguntasReferences)
          .get()
          .then((value) => {
                _perguntas.clear(),
                for (var pergunta in value.docs)
                  {_perguntas.add(pergunta.data() as Pergunta)}
              });
    }
    return _perguntas;
  }

  Future<Topico?> get tema async {
    if (_topico == null && topicoReference != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await Topico.getCollection(db)
          .where(FieldPath.documentId, isEqualTo: topicoReference)
          .get()
          .then((value) => {_topico = value.docs.first.data() as Topico});
    }
    return _topico;
  }

  atualizaReferencias(List<Pergunta> perguntas) {
    perguntasReferences.clear();
    for (var perg in perguntas) {
      perguntasReferences.add(perg.id!);
    }
  }

  create() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Deck.getCollection(db).doc(id?.id).set(this);
  }

  update() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Deck.getCollection(db).doc(id?.id).update(toFirestore());
  }

  delete() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Deck.getCollection(db).doc(id?.id).delete();
  }
}
