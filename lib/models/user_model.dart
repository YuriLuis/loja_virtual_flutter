import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{
  //usuario atual

  bool isLoading = false;

  void signUp(){

  }

  void signIn() async{
    this.isLoading = true;
    notifyListeners();

   await Future.delayed(Duration(seconds: 3));

   this.isLoading = false;
   notifyListeners();
  }

  void recoverPass(){

  }

  // ignore: missing_return
  bool isLoggedIn(){

  }
}