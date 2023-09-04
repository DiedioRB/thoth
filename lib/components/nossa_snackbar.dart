import 'package:flutter/material.dart';

class NossaSnackbar {

  //TODO: ADICIONAR ESTILIZAÇÃO CONFORME TEMA

  static mostrar( BuildContext context ,String texto ) {
    final snackBar = SnackBar(
      content: Text('${texto}'),
    );

    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}