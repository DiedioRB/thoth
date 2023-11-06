import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/interfaces/item_form.dart';
import 'package:thoth/models/topico.dart';

class Tema {
  static const String collection = "temas";

  final DocumentReference? id;
  String descricao;
  String codigo;
  final List<DocumentReference> topicosReferences;
  final List<Topico> _topicos = [];

  static List<ItemForm> getFields({Tema? tema}) {
    return [
      ItemForm.build(
          descricao: "nome",
          valor: tema?.descricao,
          icon: const Icon(Icons.edit),
          modificadores: [ItemFormModifiers.naoNulo]),
      ItemForm.build(
          descricao: "código",
          valor: tema?.codigo,
          icon: const Icon(Icons.password),
          modificadores: [ItemFormModifiers.naoNulo]),
    ];
  }

  Tema(
      {required this.descricao,
      required this.topicosReferences,
      required this.codigo,
      this.id});

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
        codigo: data?['codigo'],
        id: snapshot.reference);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "descricao": descricao,
      "topicos": topicosReferences,
      "codigo": codigo
    };
  }

  Future<List<Topico>> get topicos async {
    if (_topicos.isEmpty && topicosReferences.isNotEmpty) {
      List<List<DocumentReference>> sublist = [];
      for (var i = 0; i < topicosReferences.length; i += 10) {
        sublist.add(topicosReferences.sublist(
            i,
            i + 10 > topicosReferences.length
                ? topicosReferences.length
                : i + 10));
      }

      FirebaseFirestore db = FirebaseFirestore.instance;
      _topicos.clear();
      for (var sublista in sublist) {
        await Topico.getCollection(db)
            .where(FieldPath.documentId, whereIn: sublista)
            .get()
            .then((value) => {
                  _topicos.clear(),
                  for (var topico in value.docs)
                    {_topicos.add(topico.data() as Topico)}
                });
      }
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
    await Tema.getCollection(db).doc(id?.id).set(this);
  }

  update() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Tema.getCollection(db).doc(id?.id).update(toFirestore());
  }

  delete() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Tema.getCollection(db).doc(id?.id).delete();
  }

  static Future<List<Tema>> tudo() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Tema> temas = [];
    await getCollection(db).get().then((value) {
      temas.clear();
      for (var tema in value.docs) {
        temas.add(tema.data() as Tema);
      }
    });
    return temas;
  }

  @override
  String toString() {
    return descricao;
  }

  @override
  bool operator ==(Object other) => other is Tema && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
