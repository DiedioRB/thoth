import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/interfaces/item_form.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/tema.dart';

class Topico {
  static const String collection = "topicos";

  final DocumentReference? id;
  String descricao;
  final List<DocumentReference> perguntasReferences;
  final List<Pergunta> _perguntas = [];
  DocumentReference? temaReference;
  Tema? _tema;

  static List<ItemForm> getFields({Topico? topico}) {
    return [
      ItemForm.build(
          descricao: "nome",
          valor: topico?.descricao,
          icon: const Icon(Icons.edit),
          modificadores: [ItemFormModifiers.naoNulo]),
    ];
  }

  Topico(
      {required this.descricao,
      required this.perguntasReferences,
      this.id,
      this.temaReference});

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
        id: snapshot.reference,
        temaReference: data?['tema']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "descricao": descricao,
      "perguntas": perguntasReferences,
      "tema": temaReference
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
      // ignore: avoid_function_literals_in_foreach_calls
      sublist.forEach((sublista) async {
        await Pergunta.getCollection(db)
            .where(FieldPath.documentId, whereIn: sublista)
            .get()
            .then((value) => {
                  for (var pergunta in value.docs)
                    {_perguntas.add(pergunta.data() as Pergunta)}
                });
      });
    }
    return _perguntas;
  }

  Future<Tema?> get tema async {
    if (_tema == null && temaReference != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await Tema.getCollection(db)
          .where(FieldPath.documentId, isEqualTo: temaReference)
          .get()
          .then((value) => {_tema = value.docs.first.data() as Tema});
    }
    return _tema;
  }

  atualizaReferencias(List<Pergunta> perguntas) {
    perguntasReferences.clear();
    for (var pergunta in perguntas) {
      perguntasReferences.add(pergunta.id!);
    }
  }

  create() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Topico.getCollection(db).doc(id?.id).set(this);
  }

  update() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Topico.getCollection(db).doc(id?.id).update(toFirestore());
  }

  delete() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Topico.getCollection(db).doc(id?.id).delete();
  }

  static Future<List<Topico>> todos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Topico> topicos = [];
    await getCollection(db).get().then((value) {
      topicos.clear();
      for (var topico in value.docs) {
        topicos.add(topico.data() as Topico);
      }
    });
    return topicos;
  }
}
