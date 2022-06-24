import 'dart:async';
import 'package:utflutterclima/models/user.dart';
import 'package:utflutterclima/data/register_ctr.dart';

class RegisterRequest {
  LoginCtr con = new LoginCtr();
  Future<User?> makeRegister(String username, String password) {
    var result = con.makeRegister(username, password);
    return result;
  }
}
