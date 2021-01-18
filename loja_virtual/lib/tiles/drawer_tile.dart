import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData _icon;
  final String _text;
  final PageController controller;
  //indica qual é a pagina que o icone faz referencia.
  final int page;

  DrawerTile(this._icon, this._text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    //Apresenta um efeito visual no click
    return Material(
      color: Colors.transparent,
      //Apresenta uma animação(efeito) de toque.
      child: InkWell(
        onTap: () {
          //Fechando o menu antes de mudar de pagina
          Navigator.of(context).pop();
          //chamando a pagina que o icone faz refencia.
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                this._icon,
                size: 32.0,
                color: controller.page.round() == page
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                this._text,
                style: TextStyle(
                    fontSize: 16.0,
                    color: controller.page.round() == page
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
