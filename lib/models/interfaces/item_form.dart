import 'package:flutter/widgets.dart';

enum ItemFormModifiers { naoNulo, senha }

class ItemForm {
  final String descricaoForm;
  dynamic valor;
  final Icon? icon;
  String? Function(String? value)? validator;
  List<ItemFormModifiers> modificadores = [];

  ItemForm(
      {required this.descricaoForm, this.valor, this.icon, this.validator});

  addModifiers(List<ItemFormModifiers> modificadores) {
    this.modificadores.addAll(modificadores);
  }

  factory ItemForm.build(
      {required String descricao,
      dynamic valor,
      Icon? icon,
      String? mensagem,
      List<ItemFormModifiers>? modificadores}) {
    ItemForm newItem = ItemForm(
      descricaoForm: descricao,
      valor: valor,
      icon: icon,
      validator: (value) {
        if (modificadores!
            .any((element) => (element == ItemFormModifiers.naoNulo))) {
          //Se o valor não pode ser nulo:
          if (value == null || value.isEmpty) {
            return (mensagem != null) ? mensagem : "Preencha este campo";
          }
        }
        return null;
      },
    );
    if (modificadores != null) {
      newItem.addModifiers(modificadores);
    }
    return newItem;
  }
}
