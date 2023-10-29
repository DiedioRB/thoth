import 'package:flutter/material.dart';


class Botao extends StatelessWidget {
final String texto;
final Color corFundo;
final Color corTexto;
final VoidCallback callback;

  Botao({
    required this.texto,
    required this.corFundo,
    required this.corTexto,
    required this.callback
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          color: corFundo,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ]
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        child: Text(
          texto,
          style: TextStyle(
            color: corTexto,
            fontSize: 18
          ),
        ),
      ),
    );
  }
}
