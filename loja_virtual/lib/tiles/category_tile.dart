import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
//  Quando tiver conexão com o firebase, deve-se usar esse construtor
  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    //Permite que widget(item) de uma lista esteja pre-formatado,
    //o que facilita no desenvolvimento

    return ListTile(
      leading: CircleAvatar(
        //conteudo que ficara no inicio do widget
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data['icon']),
      ),
      title:
          Text(snapshot.data["title"]), //Conteudo que ficara no meio do widget
      trailing: Icon(Icons
          .keyboard_arrow_right), //Conteudo que vai ficar no final do widget
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CategoryScreen(snapshot)));
      },
    );
  }
}
