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

/*    super.addListener(listener);

    _loadingCurrentUser();*/
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadingCurrentUser();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSucess,
      @required VoidCallback onFailure}) {
    this.isLoading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: pass)
        .then((authResult) async {
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

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSucess,
      @required VoidCallback onFailure}) async {
        this.isLoading = true;
        notifyListeners();
        _auth.signInWithEmailAndPassword(email: email, password: pass)
        .then((user)async{
          firebaseUser = user;
          await _loadingCurrentUser();
          onSucess();
          isLoading = false;
          notifyListeners();
        }).catchError((e){
          onFailure();
          isLoading = false;
          notifyListeners();
        });
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  // ignore: missing_return
  bool isLoggedIn() {
    return firebaseUser != null;
  }

  // ignore: missing_return
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .setData(userData);
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<Null> _loadingCurrentUser()async{
    if(firebaseUser == null){
      firebaseUser = await _auth.currentUser();
    }

    if(firebaseUser != null){
      if(userData['name'] == null){
        DocumentSnapshot docUser = await Firestore.instance.collection('users')
            .document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }

    notifyListeners();
  }
}
