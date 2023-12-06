import 'package:flutter/material.dart';
import 'package:thoth/models/interfaces/pesquisavel.dart';

mixin Pesquisa<T extends Pesquisavel> {
  final List<T> itensPesquisa = [];
  final TextEditingController searchController = TextEditingController();

  void search(List<T> todos) {
    String find = searchController.text;
    itensPesquisa.clear();
    if (find.isNotEmpty) {
      for (var pesquisavel in todos) {
        if (pesquisavel
            .textoPesquisavel()
            .toLowerCase()
            .contains(find.toLowerCase())) {
          itensPesquisa.add(pesquisavel);
        }
      }
    } else {
      itensPesquisa.addAll(todos);
    }
  }

  Widget barraPesquisa() {
    return TextField(
      controller: searchController,
      decoration:
          const InputDecoration(icon: Icon(Icons.search), hintText: "Buscar"),
    );
  }
}
