import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/tiles/product_title.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    //forma de fazer uma tab que apresenta a mesma lista de duas maneiras
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: snapshot != null
                ? Text(snapshot?.data["title"])
                : Text("Blusa"),
            centerTitle: true,
            //forma de uma tab que apresenta dois icones
            bottom: TabBar(
              tabs: [Icon(Icons.grid_on), Icon(Icons.grid_off)],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("products")
                .document(snapshot.documentID)
                .collection("items")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else
                return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      GridView.builder(
                          padding: EdgeInsets.all(4.0),
                          //Forma de fazer widget no formato de retangulo com espaçamento
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 4.0,
                                  childAspectRatio: 0.65),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return ProductTile(
                                "grid",
                                ProductData.fromDocument(
                                    snapshot.data.documents[index]));
                          }),
                      ListView.builder(
                          padding: EdgeInsets.all(4.0),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return ProductTile(
                                "list",
                                ProductData.fromDocument(
                                    snapshot.data.documents[index]));
                          })
                    ]);
            },
          )),
    );
  }
}
