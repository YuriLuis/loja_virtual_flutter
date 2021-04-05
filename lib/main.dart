import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/cart_model.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:loja_virtual_flutter/screens/home_screen.dart';
import 'package:loja_virtual_flutter/screens/login_screen.dart';
import 'package:loja_virtual_flutter/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>( // User model
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
          // ignore: missing_return
          builder: (context, child, userModel){
            return ScopedModel<CartModel>(   // Cart model
              model: CartModel(userModel),
              child: MaterialApp(
                title: 'Loja Virtual',
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    primaryColor:Color.fromARGB(255, 55, 139, 206)),
                debugShowCheckedModeBanner: false,
                home: HomeScreen(),
              ),
            );
          },
        ));
  }
}
