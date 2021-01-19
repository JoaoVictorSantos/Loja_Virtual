import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          //Usando o StreamBuilder, pois, assim, ele vai ficar monitorando o
          //registro na base de dados.
          child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection("orders")
                  .document(orderId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  int status = snapshot.data["status"];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Código do pedido: $orderId",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        _buildProductsText(snapshot.data),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "Status do pedido",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCircule("1", "Preparação", status, 1),
                          Container(
                            height: 1.0,
                            width: 40.0,
                            color: Colors.grey[500],
                          ),
                          _buildCircule("2", "Transporte", status, 2),
                          Container(
                            height: 1.0,
                            width: 40.0,
                            color: Colors.grey[500],
                          ),
                          _buildCircule("3", "Entrega", status, 3),
                        ],
                      ),
                    ],
                  );
                }
              }),
        ));
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "Descrição: \n";

    for (LinkedHashMap p in snapshot.data["products"]) {
      text +=
          "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"].toStringAsFixed(2)}) \n";
    }
    text += "Total: R\$ ${snapshot.data["totalPrice"].toStringAsFixed(2)}";
    return text;
  }

  Widget _buildCircule(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
