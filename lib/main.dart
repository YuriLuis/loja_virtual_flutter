import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/screens/home_screen.dart';
import 'package:loja_virtual_flutter/screens/login_screen.dart';
import 'package:loja_virtual_flutter/screens/signup_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja Virtual',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromARGB(255, 4, 125, 141)),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
