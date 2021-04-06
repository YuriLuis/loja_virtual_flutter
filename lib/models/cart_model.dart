import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual_flutter/datas/cart_product.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;

  String couponCode;
  int discountPercentage = 0;

  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadingCartItems();
    }
  }

  static CartModel of(BuildContext context) {
    return ScopedModel.of(context);
  }

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) => cartProduct.cid = doc.documentID);
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .delete();

    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  Future<String> finishOrder() async {
    if (products.length == 0) {
      return null;
    } else {
      isLoading = true;
      notifyListeners();

      double productsPrice = getProductsPrice();
      double shipPrice = getShipPrice();
      double discount = getDiscount();
      double total = getTotalCart();

      //Adiciona o pedido na collections orders no firestore
      DocumentReference reference =
      await Firestore.instance.collection('orders').add({
        'clientId': user.firebaseUser.uid,
        'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
        'shipPrice': shipPrice,
        'productsPrice': productsPrice,
        'discount': discount,
        'total': total,
        'status': 1
      });

      Firestore.instance
          .collection('users')
          .document(user.firebaseUser.uid)
          .collection('orders')
          .document(reference.documentID)
          .setData({'orderId': reference.documentID});

      QuerySnapshot query = await Firestore.instance.collection('users')
          .document(user.firebaseUser.uid).collection('cart')
          .getDocuments();
      for(DocumentSnapshot doc in query.documents){
        doc.reference.delete();
      }

      products.clear();
      discountPercentage = 0;
      couponCode = null;
      isLoading = false;
      notifyListeners();

      return reference.documentID;
    }
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void _loadingCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  // ignore: missing_return
  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  void updatePrices() {
    notifyListeners();
  }

  // ignore: missing_return
  double getShipPrice() {
    return 10.0;
  }

  // ignore: missing_return
  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getTotalCart() {
    return getProductsPrice() + getShipPrice() - getDiscount();
  }
}
