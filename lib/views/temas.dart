import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/item_tema.dart';
import 'package:thoth/helpers/form_builder.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/routes.dart';

class Temas extends StatefulWidget {
  final bool? isAdmin;
  const Temas({super.key, this.isAdmin = false});

  @override
  State<Temas> createState() => _TemasState();
}

class _TemasState extends State<Temas> {
  List<Tema> _temas = [];
  List<Topico> todosTopicos = [];
  List<Topico> topicos = [];

  Tema novoTema = Tema(descricao: "", topicosReferences: [], id: null);
  late FormBuilder formBuilder;
  StreamSubscription? watcher;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore db = FirebaseFirestore.instance;
    watcher = Tema.getCollection(db).snapshots().listen(listen);
  }

  void listen(value) {
    List<Tema> temas = [];
    if (value.docs.isNotEmpty) {
      for (var tema in value.docs) {
        temas.add(tema.data() as Tema);
      }
      _temas.clear();
      setState(() {
        _temas = temas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
           SliverAppBar(
             shape: const RoundedRectangleBorder(
                 borderRadius:  BorderRadius.all(Radius.circular(20))
             ),
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context,  BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  title: _scrollController.hasClients &&
                      _scrollController.offset > 100
                      ? Text("Temas")
                      : Text("Seja bem vindo!\n\n\nEstudante!")
                );
              },
            ),
          ),
           SliverPadding(
             padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
             sliver:  SliverList(
               delegate: SliverChildBuilderDelegate(
                     (BuildContext context, int index) {
                   return ItemTema(
                     tema: _temas[index],
                     modifiable: widget.isAdmin ?? false,
                   );
                 },
                 childCount: _temas.length,
               ),
             )
           )


        ],
      ),
      floatingActionButton: (widget.isAdmin ?? false)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.cadastroTema);
              },
              child: const Icon(Icons.add),
            )
          : null,
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
