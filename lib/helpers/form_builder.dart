import 'package:flutter/material.dart';
import 'package:thoth/models/interfaces/item_form.dart';

class FormBuilder {
  final List<ItemForm> _items = [];
  final List<TextFormField> _fields = [];
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> controllers = [];
  final Map<String, dynamic> _values = {};

  FormBuilder(List<ItemForm> fields) {
    addFields(fields);
  }

  void addField(ItemForm item) {
    _items.add(item);
    if (item.type == ItemFormTypes.text) {
      _fields.add(_createTextFormField(item));
    }
  }

  void addFields(List<ItemForm> items) {
    for (ItemForm item in items) {
      _items.add(item);
      if (item.type == ItemFormTypes.text) {
        _fields.add(_createTextFormField(item));
      }
    }
  }

  Map<String, dynamic> get values {
    return _values;
  }

  TextFormField _createTextFormField(ItemForm item) {
    TextEditingController newController =
        TextEditingController(text: item.valor);
    values.update(item.descricaoForm, (value) => item.valor,
        ifAbsent: () => item.valor);

    newController.addListener(() {
      String val = newController.text;
      print(val);
      _values.update(
        item.descricaoForm,
        (value) => val,
        ifAbsent: () => val,
      );
    });
    TextFormField newField = TextFormField(
      validator: item.validator,
      decoration:
          InputDecoration(icon: item.icon, labelText: item.descricaoForm),
      obscureText:
          (item.modificadores.contains(ItemFormModifiers.senha)) ? true : false,
      controller: newController,
    );

    controllers.add(newController);
    return newField;
  }

  bool get isValid {
    return _formKey.currentState!.validate();
  }

  Widget build() {
    return Form(
      key: _formKey,
      child: Column(
        children: _fields,
      ),
    );
  }
}
