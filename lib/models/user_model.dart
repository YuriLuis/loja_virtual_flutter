import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  //usuario atual

  bool isLoading = false;

  void signUp ({
    @required Map<String, dynamic> userData,@required String pass,
    @required VoidCallback onSucess,
    @required VoidCallback onFailure}) {
      this.isLoading = true;
      notifyListeners();
      _auth.createUserWithEmailAndPassword(
              email: userData['email'], password: pass)
          .then((authResult) async{
        firebaseUser = authResult;
        await _saveUserData(userData);
        onSucess();
        this.isLoading = false;
        notifyListeners();
      }).catchError((e) {
        onFailure();
        this.isLoading = false;
        notifyListeners();
      });
  }

  void signIn() async {
    this.isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    this.isLoading = false;
    notifyListeners();
  }

  void recoverPass() {}

  // ignore: missing_return
  bool isLoggedIn() {}

  // ignore: missing_return
  Future<Null> _saveUserData(Map<String, dynamic> userData) async{
    this.userData = userData;
    await Firestore.instance.collection('users').document(firebaseUser.uid).setData(userData);
  }
}
