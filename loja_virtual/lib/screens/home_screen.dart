import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  //Permite fazer um controle das paginas, assim,
  //conseguimos chamar a pagina pelo seu index
  final _pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    //PageView -> Permite que as paginas deslizem para o lado ou
    //que uma determinada pagina possa ser chamada.
    return PageView(
      controller: _pageViewController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(body: HomeTab(), drawer: CustomDrawer(_pageViewController)),
        Scaffold(
            appBar: AppBar(
              title: Text("Produtos"),
              centerTitle: true,
            ),
            body: ProductsTab(),
            drawer: CustomDrawer(_pageViewController))
      ],
    );
  }
}
