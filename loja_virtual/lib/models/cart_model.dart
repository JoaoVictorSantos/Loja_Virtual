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
        price = c.quantity * c.productData.price;
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
}
