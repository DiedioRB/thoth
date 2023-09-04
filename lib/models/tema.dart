import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/models/topico.dart';

class Tema {
  static const String collection = "temas";

  final DocumentReference? id;
  final String descricao;
  final List<DocumentReference> topicosReferences;
  final List<Topico> _topicos = [];

  Tema({required this.descricao, required this.topicosReferences, this.id});

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Tema>(
        fromFirestore: Tema.fromFirestore,
        toFirestore: (Tema item, _) => item.toFirestore());
  }

  factory Tema.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    List<DocumentReference> topicos = [];
    for (var topico in data?['topicos']) {
      topicos.add(topico);
    }
    return Tema(
        descricao: data?['descricao'],
        topicosReferences: topicos,
        id: snapshot.reference);
  }

  Map<String, dynamic> toFirestore() {
    return {"descricao": descricao, "topicos": topicosReferences};
  }

  Future<List<Topico>> get topicos async {
    if (_topicos.isEmpty && topicosReferences.isNotEmpty) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await Topico.getCollection(db)
          .where(FieldPath.documentId, whereIn: topicosReferences)
          .get()
          .then((value) => {
                _topicos.clear(),
                for (var topico in value.docs)
                  {_topicos.add(topico.data() as Topico)}
              });
    }
    return _topicos;
  }

  atualizaReferencias(List<Topico> topicos) {
    topicosReferences.clear();
    for (var topico in topicos) {
      topicosReferences.add(topico.id!);
    }
  }

  create() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Tema.getCollection(db).doc(id?.id).set(this);
  }

  update() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Tema.getCollection(db).doc(id?.id).update(toFirestore());
  }

  delete() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Tema.getCollection(db).doc(id?.id).delete();
  }

  @override
  String toString() {
    return descricao;
  }
}
