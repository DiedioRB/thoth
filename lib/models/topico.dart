import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/models/pergunta.dart';

class Topico {
  static const String collection = "topicos";

  final DocumentReference? id;
  final String descricao;
  final List<DocumentReference> perguntasReferences;
  final List<Pergunta> _perguntas = [];

  Topico({required this.descricao, required this.perguntasReferences, this.id});

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Topico>(
        fromFirestore: Topico.fromFirestore,
        toFirestore: (Topico item, _) => item.toFirestore());
  }

  factory Topico.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    List<DocumentReference> perguntas = [];
    for (var pergunta in data?['perguntas']) {
      perguntas.add(pergunta);
    }
    return Topico(
        descricao: data?['descricao'],
        perguntasReferences: perguntas,
        id: snapshot.reference);
  }

  Map<String, dynamic> toFirestore() {
    return {"descricao": descricao, "perguntas": perguntasReferences};
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

  atualizaReferencias(List<Pergunta> perguntas) {
    perguntasReferences.clear();
    for (var pergunta in perguntas) {
      perguntasReferences.add(pergunta.id!);
    }
  }

  create() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Topico.getCollection(db).doc(id?.id).set(this);
  }

  update() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Topico.getCollection(db).doc(id?.id).update(toFirestore());
  }

  delete() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Topico.getCollection(db).doc(id?.id).delete();
  }

  @override
  String toString() {
    return descricao;
  }
}
