import 'package:flutter/material.dart';
import 'package:thoth/components/menu_lateral.dart';
import 'package:thoth/components/botao.dart';
import 'package:thoth/helpers/auth_helper.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/tema_app.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  void _logout(BuildContext context) {
    AuthHelper.logout();
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: const Drawer(
            child: MenuLateral(),
          ),
          appBar: AppBar(
              bottom: const TabBar(tabs: [
                Tab(icon: Icon(Icons.book_outlined)),
                Tab(icon: Icon(Icons.admin_panel_settings_outlined)),
              ]),
              actions: [
                IconButton(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  tooltip: "Desconectar",
                ),
              ]),
          body: TabBarView(
            children: [
              Center(
                  child: Center(
                child: Botao(
                  texto: "Visão do aluno",
                  corFundo: TemaApp.darkPrimary,
                  corTexto: TemaApp.branco,
                  callback: () async {
                    Navigator.of(context)
                        .pushNamed(Routes.temas, arguments: false);
                  },
                ),
              )),
              Center(
                  child: GridView.extent(
                maxCrossAxisExtent: 300,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  Card(
                    child: InkWell(
                      child: Center(
                          child: Text(
                        "Temas",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                      onTap: () async {
                        Navigator.of(context)
                            .pushNamed(Routes.temas, arguments: true);
                      },
                    ),
                  ),
                  Card(
                    child: InkWell(
                      child: Center(
                          child: Text(
                        "Tópicos",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(Routes.topicos, arguments: [null, true]);
                      },
                    ),
                  ),
                  Card(
                    child: InkWell(
                      child: Center(
                          child: Text(
                        "Quizzes",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.quizzes,
                            arguments: [null, null, true]);
                      },
                    ),
                  ),
                  Card(
                    child: InkWell(
                      child: Center(
                          child: Text(
                        "Flashcards",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.flashcards);
                      },
                    ),
                  ),
                  Card(
                    child: InkWell(
                      child: Center(
                          child: Text(
                        "Decks",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.decks);
                      },
                    ),
                  ),
                ],
              )),
            ],
          )),
    ));
  }
}
