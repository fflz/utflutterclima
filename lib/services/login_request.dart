import 'dart:async';
import 'package:utflutterclima/models/user.dart';
import 'package:utflutterclima/data/login_ctr.dart';

class LoginRequest {
  LoginCtr con = new LoginCtr();
  Future<User?> getLogin(String username, String password) {
    var result = con.getLogin(username, password);
    return result;
  }
}

class RegisterRequest {
  LoginCtr con = new LoginCtr();
  Future<User?> makeRegister(String username, String password) async {
    Future result = con.makeRegister(username, password);
  }
}
