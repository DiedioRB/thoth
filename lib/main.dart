import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/lista_cards.dart';
import 'package:thoth/components/perfil.dart';
import 'package:thoth/models/pergunta.dart';
import 'package:thoth/models/usuario.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/tema_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Thoth',
      theme: TemaApp.tema,
      onGenerateRoute: (RouteSettings settings) {
        var routes = Routes.routes(settings);
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder(context));
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Pergunta> _perguntas = [];
  Usuario usuario = Usuario(
      nome: "Lorem",
      email: "Ipsum",
      salas: ["Introdução a Python", "Fullstack"]);

  void _fetchPerguntas(FirebaseFirestore db) {
    Pergunta.getCollection(db).get().then(
      (event) {
        List<Pergunta> ps = [];
        for (var pergunta in event.docs) {
          Pergunta p = pergunta.data() as Pergunta;
          ps.add(p);
        }
        setState(() {
          _perguntas = ps;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseApp app = Firebase.app();
    final FirebaseFirestore db = FirebaseFirestore.instanceFor(app: app);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Perfil(usuario: usuario),
            Expanded(child: ListaCards(perguntas: _perguntas)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _fetchPerguntas(db),
        tooltip: 'Atualizar',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
