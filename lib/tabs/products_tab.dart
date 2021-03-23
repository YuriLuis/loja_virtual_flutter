import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("products").getDocuments(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var dividerdTiles = ListTile.divideTiles(
                  tiles: snapshot.data.documents.map((e) => CategoryTile(e)).toList(),
          color: Colors.grey).toList();
          return ListView(
            children: dividerdTiles
          );
        }
      },
    );
  }
}
