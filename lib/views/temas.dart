import 'dart:async';
import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/item_tema.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/models/usuario.dart';
import 'package:thoth/routes.dart';

class Temas extends StatefulWidget {
  final bool? isAdmin;
  const Temas({super.key, this.isAdmin = false});

  @override
  State<Temas> createState() => _TemasState();
}

class _TemasState extends State<Temas> {
  List<Tema> _temas = [];
  List<DocumentReference> _temasUsuario = [];
  List<Topico> todosTopicos = [];
  List<Topico> topicos = [];

  Tema novoTema =
      Tema(descricao: "", topicosReferences: [], codigo: "", id: null);
  late FormBuilder formBuilder;
  StreamSubscription? watcher;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore db = FirebaseFirestore.instance;

    watcher = Tema.getCollection(db).snapshots().listen(listen);
  }

  void listen(value) async {
    Usuario? u = await Usuario.logged();
    if (!(widget.isAdmin ?? false)) {
      _temasUsuario = u!.temasReferences;
    }

    List<Tema> temas = [];
    if (value.docs.isNotEmpty) {
      for (var tema in value.docs) {
        Tema t = tema.data() as Tema;
        if ((widget.isAdmin ?? false) || _temasUsuario.contains(t.id)) {
          temas.add(tema.data() as Tema);
        }
      }
      _temas.clear();
      setState(() {
        _temas = temas;
      });
    }
  }

  void _modalAdicionarTema() {
    TextEditingController codigoController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Entrar em um tema"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: codigoController,
                  decoration:
                      const InputDecoration(labelText: "Código do tema"),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    String codigo = codigoController.value.text;
                    Navigator.of(context).pop();
                    _buscarTemaPorCodigo(codigo);
                  },
                  child: const Text("Buscar"))
            ],
          );
        });
  }

  void _buscarTemaPorCodigo(String codigo) async {
    List<Tema> temas = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    await Tema.getCollection(db)
        .where("codigo", isEqualTo: codigo)
        .get()
        .then((value) => {
              for (var tema in value.docs) {temas.add(tema.data() as Tema)}
            });
    _modalBuscaCodigo(temas);
  }

  _modalBuscaCodigo(List<Tema> temas) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Selecionar tema"),
            content: SizedBox(
              width: double.maxFinite,
              child: temas.isEmpty
                  ? const Text("Nenhum tema encontrado")
                  : ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: temas.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(temas[index].descricao),
                          trailing: IconButton(
                              onPressed: () async {
                                Usuario? usuario = await Usuario.logged();
                                await usuario!.entrarNoTema(temas[index]);
                                if (!(widget.isAdmin ?? false)) {
                                  setState(() {
                                    _temas.add(temas[index]);
                                  });
                                }
                                _fecharModal();
                              },
                              tooltip: "Entrar",
                              icon: const Icon(Icons.arrow_forward)),
                        );
                      }),
            ),
          );
        });
  }

  _fecharModal() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                    title: _scrollController.hasClients &&
                            _scrollController.offset > 100
                        ? Text("Temas")
                        : Text("Seja bem vindo!\n\n\nEstudante!"));
              },
            ),
          ),
          SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ItemTema(
                      tema: _temas[index],
                      modifiable: widget.isAdmin ?? false,
                    );
                  },
                  childCount: _temas.length,
                ),
              ))
        ],
      ),
      floatingActionButton: (widget.isAdmin ?? false)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.cadastroTema);
              },
              tooltip: "Novo tema",
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () {
                _modalAdicionarTema();
              },
              tooltip: "Entrar em um novo tema",
              child: const Icon(Icons.add),
            ),
    );
  }

  @override
  void dispose() {
    if (watcher != null) {
      watcher!.cancel();
      watcher = null;
    }
    _scrollController.dispose();
    super.dispose();
  }
}
