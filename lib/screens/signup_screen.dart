import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';


class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Criar Conta'),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            if(model.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Nome Completo'),
                    // ignore: missing_return
                    validator: (text){
                      if(text.isEmpty){
                        return 'Nome inválido!';
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    // ignore: missing_return
                    validator: (text){
                      if(text.isEmpty || !text.contains('@')){
                        return 'Email inválido!';
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(hintText: 'Senha'),
                    obscureText: true,
                    // ignore: missing_return
                    validator: (text){
                      if(text.isEmpty || text.length <6){
                        return 'Senha inválida!';
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(hintText: 'Endereço'),
                    // ignore: missing_return
                    validator: (text){
                      if(text.isEmpty){
                        return 'Endereço inválido!';
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if(_formKey.currentState.validate()){
                        Map<String, dynamic> userData = {
                          'name' : _nameController.text,
                          'email' : _emailController.text,
                          'address' : _addressController.text
                        };
                        model.signUp(userData: userData, pass: _passController.text, onSucess: _onSucess, onFailure: _onFailure);
                      }
                    },
                    child: Text(
                      'Criar conta',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            );
          },
        )
    );
  }

  void _onSucess(){}
  void _onFailure(){}
}

