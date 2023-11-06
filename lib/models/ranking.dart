import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/usuario.dart';

class Ranking {
  static const String collection = "rankings";

  final DocumentReference? id;
  final DocumentReference temaReference;
  DateTime? semana;
  final List<Map<String, dynamic>> registros;

  Ranking(
      {required this.temaReference,
      this.semana,
      required this.registros,
      this.id}) {
    semana ??= comecoSemana();
  }

  static CollectionReference getCollection(FirebaseFirestore db) {
    return db.collection(collection).withConverter<Ranking>(
        fromFirestore: Ranking.fromFirestore,
        toFirestore: (Ranking item, _) => item.toFirestore());
  }

  factory Ranking.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    List<Map<String, dynamic>> registros = [];
    for (var registro in data?['registros']) {
      registros.add(registro);
    }
    return Ranking(
        temaReference: data?['tema'],
        semana: DateTime.fromMillisecondsSinceEpoch(
            (data?['semana'] as Timestamp).millisecondsSinceEpoch),
        registros: registros,
        id: snapshot.reference);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "tema": temaReference,
      "semana": semana,
      "registros": registros,
    };
  }

  Future<void> carregaUsuarios() async {
    for (var registro in registros) {
      Usuario? usuario = await Usuario.find(registro["usuario"]);
      registro["carregado"] = usuario;
    }
  }

  static Future<Ranking> doTema(Tema tema) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Ranking? ranking;
    await getCollection(db)
        .where("semana", isGreaterThanOrEqualTo: comecoSemana())
        .where("tema", isEqualTo: tema.id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ranking = value.docs.first.data() as Ranking?;
      }
    });
    if (ranking != null) {
      return ranking!;
    } else {
      Ranking novo = Ranking(
          temaReference: tema.id!, registros: [], semana: comecoSemana());
      novo.create();
      return novo;
    }
  }

  static DateTime comecoSemana() {
    DateTime comecoSemana =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    return DateTime(comecoSemana.year, comecoSemana.month, comecoSemana.day);
  }

  adicionaRegistro(int pontos, Usuario usuario) async {
    Map<String, dynamic> registro;
    if (registros.isNotEmpty) {
      registro = registros.firstWhere(
          (element) => element["usuario"] == usuario.id,
          orElse: () => {});
      if (registro.isNotEmpty) {
        registro['pontuacao'] += pontos;
      } else {
        registro = {"pontuacao": pontos, "usuario": usuario.id};
        registros.add(registro);
      }
    } else {
      registro = {"pontuacao": pontos, "usuario": usuario.id};
      registros.add(registro);
    }
    updateRegistros();
  }

  create() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Ranking.getCollection(db).doc(id?.id).set(this);
  }

  update() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Ranking.getCollection(db).doc(id?.id).update(toFirestore());
  }

  updateRegistros() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Ranking.getCollection(db)
        .doc(id?.id)
        .update({'registros': registros});
  }

  delete() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Ranking.getCollection(db).doc(id?.id).delete();
  }
}
