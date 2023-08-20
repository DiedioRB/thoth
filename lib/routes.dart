import 'package:flutter/material.dart';
import 'package:thoth/views/tela_cadastro.dart';
import 'package:thoth/views/tela_login.dart';
import 'package:thoth/views/tela_menu.dart';

class Routes {
  static const String home = "/";
  static const String login = "/login";
  static const String menu = "/menu";
  static const String cadastro = "/cadastro";

  static var routes = <String, WidgetBuilder>{
    home: (context) => Login(),
    login: (context) => Login(),
    cadastro: (context) => Cadastro(),
    menu: (context) => const Menu()
  };
}
