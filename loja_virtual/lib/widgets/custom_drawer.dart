import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  Widget _buildDrawerBack() => Container(
        decoration: BoxDecoration(
          //Forma de fazer um degrade na tela do app
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
              //Indica onde o degrade vai começar e terminar
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(children: <Widget>[
        _buildDrawerBack(),
        ListView(
          padding: EdgeInsets.only(left: 32.0, top: 16.0),
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    //Forma de posicionar widget na tela
                    Positioned(
                        top: 8.0,
                        left: 0.0,
                        child: Text(
                          "Flutter's\nClothing",
                          style: TextStyle(
                              fontSize: 34.0, fontWeight: FontWeight.bold),
                        )),
                    Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Olá,${model.isLoggerIn() ? model.userData["name"] : ""}",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      !model.isLoggerIn()
                                          ? "Entre ou cadastra-se >"
                                          : "Sair",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      if (model.isLoggerIn())
                                        model.signOut();
                                      else
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
                                    },
                                  )
                                ]);
                          },
                        ))
                  ],
                )),
            Divider(),
            DrawerTile(Icons.home, "Inicio", pageController, 0),
            DrawerTile(Icons.list, "Produtos", pageController, 1),
            DrawerTile(Icons.location_on, "Lojas", pageController, 2),
            DrawerTile(
                Icons.playlist_add_check, "Meus Pedidos", pageController, 3)
          ],
        )
      ]),
    );
  }
}
