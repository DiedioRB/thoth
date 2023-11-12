import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoth/models/usuario.dart';
import 'package:thoth/models/resposta.dart';


class Teste extends StatefulWidget {
  const Teste({super.key});

  @override
  State<Teste> createState() => _TesteState();
}

class _TesteState extends State<Teste> {


  @override
  void initState() {
    super.initState();


    getUser();

  }

  void getUser() async {
    Usuario? user = await Usuario.logged();
    if(user != null){
      CollectionReference? respRef = user.respostasCollection;
      print(respRef);
    } else {
      print("no user bitch");
    }

    //await Resposta.getDataFromSubcollection(userRef);
    //print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Teste"),
      )
    );
  }
}
