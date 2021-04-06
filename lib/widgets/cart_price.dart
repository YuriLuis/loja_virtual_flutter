import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {
  final VoidCallback buy;
  CartPrice(this.buy);
  @override
  Widget build(BuildContext context) {
    var __corPadrao = Theme.of(context).primaryColor;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CartModel>(
          // ignore: missing_return
          builder: (context, child, model){
            double price = model.getProductsPrice();
            double discount = model.getDiscount();
            double ship = model.getShipPrice();
            double total = model.getTotalCart();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Resumo do pedido', textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal'),
                    Text(' R\$ ${price.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Desconto'),
                    Text(' R\$ ${discount.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Entrega'),
                    Text(' R\$ ${ship.toStringAsFixed(2)}')
                  ],
                ),
                Divider(),
                SizedBox(height: 4.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: TextStyle(fontWeight: FontWeight.w500),),
                    Text(' R\$ ${total.toStringAsFixed(2)}', style: TextStyle(color: __corPadrao , fontSize: 16.0),)
                  ],
                ),
                SizedBox(height: 12.0,),
                RaisedButton(
                  child: Text('Finalizar Pedido'),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: buy,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
