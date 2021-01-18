import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/card_model.dart';
import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Permite que toda a aplicação que está abaixo tenha acesso as informações do model,
    //que no caso é UserModel.
    return ScopedModel(
      model: UserModel(),
      //Como o CardModel precisa de algumas informações do usuário, ele precisa
      //está dentro do UserModel para ter acesso as informações
      child: ScopedModel<CardModel>(
        model: CardModel(),
        child: MaterialApp(
          title: "Flutter's Clothing",
          theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Color.fromARGB(255, 4, 125, 141)),
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        ),
      ),
    );
  }
}
