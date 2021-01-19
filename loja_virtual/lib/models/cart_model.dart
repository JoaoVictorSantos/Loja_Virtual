import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  //Forma de o CardModel ter acesso as informações do usuário logado.
  UserModel userModel;

  List<CartProduct> products = [];
  bool isLoading = false;

  String cuponCode;
  int discountPercentage = 0;

  CartModel(this.userModel) {
    if (this.userModel.isLoggerIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void setCoupon(String cuponCode, int discountPercentage) {
    this.cuponCode = cuponCode;
    this.discountPercentage = discountPercentage;
  }

  void addCardItem(CartProduct cartProduct) {
    products.add(cartProduct);

    Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCardItem(CartProduct cartProduct) {
    Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;
    _updateCartItem(cartProduct);
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;
    _updateCartItem(cartProduct);
  }

  void _updateCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    products =
        snapshot.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
  }

  void updatePrice() {
    notifyListeners();
  }

  double getPriceProducts() {
    double price = 0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getDiscount() {
    return getPriceProducts() * (discountPercentage / 100);
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double price = getPriceProducts();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    //Salvando o pedido;
    DocumentReference refOrder =
        await Firestore.instance.collection("orders").add({
      "clientId": userModel.firebaseUser.uid,
      "products": products.map((p) => p.toMap()).toList(),
      "price": price,
      "shipPrice": shipPrice,
      "discount": discount,
      "totalPrioe": ((price + shipPrice) - discount),
      "status": 1 //faz referencia ao status do pedido
      //Sendo 1 -> preparando; 2 -> enviando; 3 -> esperando entregar; 4 -> finalizado;
    });

    //Salvando a referencia do pedido no usuário que realizou o pedido;
    await Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("orders")
        .document(refOrder.documentID)
        .setData({"orderId": refOrder.documentID});

    await _removeAllCart();

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }

  Future<Null> _removeAllCart() async {
    //Quando tem mais de um registro é QuerySnapshot, mas quando tem apenas um
    //usa o DocumentSnapshot.
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(userModel.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    products.clear();
    setCoupon(null, 0);
  }
}
