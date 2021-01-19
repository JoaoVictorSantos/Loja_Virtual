import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(this.product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  String size;

  //Passando no contrutor ao invés de fazer widget.product.
  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(this.product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
              aspectRatio: 0.9,
              //Forma de apresentar a imagem no formato de carrosel.
              child: Carousel(
                  //Passando as imagens que serão apresentadas no carrosel.
                  images: product.images.map((url) {
                    return NetworkImage(url);
                  }).toList(),
                  dotSize: 4.0,
                  //Definindo o tamanho dos pontos
                  dotSpacing: 15.0,
                  //Definindo o espaçamento entre eles.
                  dotBgColor: Colors.transparent,
                  dotColor: primaryColor,
                  autoplay:
                      false //Forma de deixar o carrosel parado e não passando as imagens,),
                  )),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  maxLines: 3, //Máximo de linhas que serão ocupadas
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.5),
                    children: product.sizes.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  4.0)), //Forma de deixar a bordar circular
                              border: Border.all(
                                  color: s == size
                                      ? primaryColor
                                      : Colors.green[500],
                                  width: 3.0)),
                          width: 50.0,
                          alignment: Alignment.center,
                          child: Text(s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: size != null
                        ? () {
                            //Forma de acessar o model sem usar o ScopedModelDescendant
                            if (UserModel.of(context).isLoggerIn()) {
                              CartProduct cartProduct = CartProduct();
                              cartProduct.quantity = 1;
                              cartProduct.size = size;
                              cartProduct.pid = product.id;
                              cartProduct.category = product.category;
                              cartProduct.productData = product;

                              CartModel.of(context).addCardItem(cartProduct);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            }
                          }
                        : null,
                    child: Text(
                      UserModel.of(context).isLoggerIn()
                          ? "Adicionar ao Carrinho"
                          : "Entrar para Comprar",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
