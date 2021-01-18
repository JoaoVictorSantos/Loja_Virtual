import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductScreen(product)));
      },
      child: Card(
        child: type == "grid"
            ? Column(
                //Forma de deixar a coluna esticada.
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //Forma de deixar a imagem no inicio do card.
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    //Forma de deixar a imagem retangular, pois, o aspectRatio
                    // é altura dividido pela largura.
                    aspectRatio: 0.8,
                    child: Image.network(
                      this.product.images[0],
                      //Forma de fazer a imagem ocupar todo o espaço necessário.
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          product.title,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "R\$ ${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  ))
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Permite colocar widgets com base na relação diretamente porpocional
                  // ex: 1 - 1, 1 - 2....
                  Flexible(
                      flex: 1,
                      child: Image.network(
                        this.product.images[0],
                        //Forma de fazer a imagem ocupar todo o espaço necessário.
                        fit: BoxFit.cover,
                        height: 250.0,
                      )),
                  Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "R\$ ${product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Theme.of(context).primaryColor),
                            )
                          ],
                        ),
                      ))
                ],
              ),
      ),
    );
  }
}
