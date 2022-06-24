import 'package:utflutterclima/models/user.dart';
import 'dart:async';
import 'package:utflutterclima/data/database_helper.dart';

class LoginCtr {
  DatabaseHelper con = new DatabaseHelper();

  Future<User?> makeRegister(String user, String password) async {
    var dbClient = await con.db;
    var res = await dbClient.rawQuery(
        "INSERT INTO user (username, password) VALUES ('$user', '$password')");
    if (res.length > 0) {
      return new User.fromMap(res.first);
    }
    return null;
  }
}
