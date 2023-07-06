import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/perguntas.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Thoth',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo.shade700),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Projeto Thoth - Flashcards',
      ),
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
  int _counter = 0;
  List<Pergunta> _perguntas = [];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _fetchPerguntas(FirebaseFirestore db) {
    db.collection("perguntas").get().then(
      (event) {
        List<Pergunta> ps = [];
        for (var pergunta in event.docs) {
          Pergunta p = Pergunta(
              pergunta: pergunta.data()["pergunta"],
              resposta: pergunta.data()["resposta"]);
          ps.add(p);
          print("${pergunta.id} => ${pergunta.data()}");
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(_perguntas.length, (index) {
            return Center(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FlipCard(
                      fill: Fill.fillBack,
                      direction: FlipDirection.HORIZONTAL,
                      side: CardSide.FRONT,
                      front: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade300,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Center(
                            child: Padding(
                          child: Text(_perguntas[index].pergunta,
                              style: TextStyle(color: Colors.white)),
                          padding: EdgeInsets.all(5),
                        )),
                      ),
                      back: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade300,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Center(
                            child: Padding(
                          child: Text(_perguntas[index].resposta,
                              style: TextStyle(color: Colors.white)),
                          padding: EdgeInsets.all(5),
                        )),
                      ),
                    )));
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _fetchPerguntas(db),
        tooltip: 'Atualizar',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
