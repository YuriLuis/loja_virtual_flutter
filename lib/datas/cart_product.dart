import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual_flutter/datas/product_data.dart';
import 'package:loja_virtual_flutter/main.dart';

class CartProduct{

  String cid;
  String category;
  String pid;
  int quantity;
  String size;
  ProductData productData;

  CartProduct.fromDocument(DocumentSnapshot snapshot){
   cid = snapshot.documentID;
   category = snapshot.data['category'];
   pid = snapshot.data['pid'];
   quantity = snapshot.data['quantity'];
   size = snapshot.data['size'];
  }

  CartProduct();

  Map<String, dynamic> toMap(){
    return {
    'category' : category,
      'pid' : pid,
      'quantity' : quantity,
      'size' : size,
      //'product' : productData.toResumedMap()
    };
  }
}