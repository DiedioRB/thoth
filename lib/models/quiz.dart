import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/interfaces/item_form.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/topico.dart';

class Quiz {
  static const String collection = "quizzes";

  final DocumentReference? id;
  String nome;
  final List<DocumentReference> perguntasReferences;
  final List<Pergunta> _perguntas = [];
  final int? quantidadePerguntas;
  DocumentReference? topicoReference;
  Topico? _topico;

  static List<ItemForm> getFields({Quiz? quiz}) {
    return [
      ItemForm.build(
          descricao: "nome",
          valor: quiz?.nome,
          icon: const Icon(Icons.edit),
          modificadores: [ItemFormModifiers.naoNulo]),
    ];
  }

  Quiz(
      {required this.nome,
      required this.perguntasReferences,
      this.quantidadePerguntas,
      this.id,
      this.topicoReference});

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Quiz>(
        fromFirestore: Quiz.fromFirestore,
        toFirestore: (Quiz item, _) => item.toFirestore());
  }

  factory Quiz.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    List<DocumentReference> perguntas = [];
    for (var pergunta in data?['perguntas']) {
      perguntas.add(pergunta);
    }
    return Quiz(
        nome: data?['nome'],
        perguntasReferences: perguntas,
        id: snapshot.reference,
        topicoReference: data?['topico']);
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
    for (var pergunta in perguntas) {
      perguntasReferences.add(pergunta.id!);
    }
  }

  create() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Quiz.getCollection(db).doc(id?.id).set(this);
  }

  update() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Quiz.getCollection(db).doc(id?.id).update(toFirestore());
  }

  delete() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Quiz.getCollection(db).doc(id?.id).delete();
  }
}
