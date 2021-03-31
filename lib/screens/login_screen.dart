import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:loja_virtual_flutter/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Entrar'),
          centerTitle: true,
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              },
              child: Text(
                'Criar Conta',
                style: TextStyle(fontSize: 15.0),
              ),
              textColor: Colors.white,
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          // ignore: missing_return
          builder: (context, child, model) {
            if (model.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    // ignore: missing_return
                    validator: (text) {
                      if (text.isEmpty || !text.contains('@')) {
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
                    validator: (text) {
                      if (text.isEmpty || text.length < 6) {
                        return 'Senha inválida!';
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child: Text(
                        'Esqueci minha senha!',
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if(_emailController.text.isEmpty){
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Insira seu email para recuperação'),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          ));
                        }else {
                          model.recoverPass(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Confira seu email'),
                            backgroundColor: Theme.of(context).primaryColor,
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  RaisedButton(
                    child: Text(
                      'Entrar',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {}
                      model.signIn(
                          email: _emailController.text,
                          pass: _passController.text,
                          onSucess: _onSucess,
                          onFailure: _onFailure);
                    },
                  )
                ],
              ),
            );
          },
        ));
  }

  void _onSucess() {
    Navigator.of(context).pop();
  }

  void _onFailure() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Falha ao Entrar'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));

  }

}
