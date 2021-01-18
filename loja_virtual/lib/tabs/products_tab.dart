import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("products").getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            print(snapshot.data.documents.length);
            //Quando tiver conexão com o firebase, deve-se utilizar esse metodo.
            //Forma de colocar uma linha entre os itens da lista
            var dividedTiles = ListTile.divideTiles(
                    tiles: snapshot.data.documents.map((doc) {
                      return CategoryTile(doc);
                    }).toList(),
                    color: Colors.green[500])
                .toList();

            return ListView(
              children: dividedTiles,
            );
          }
        });
  }
}
