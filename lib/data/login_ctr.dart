import 'package:utflutterclima/models/user.dart';
import 'dart:async';
import 'package:utflutterclima/data/database_helper.dart';

class LoginCtr {
  DatabaseHelper con = new DatabaseHelper();
//insertion
  Future<int> saveUser(User user) async {
    var dbClient = await con.db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  //deletion
  Future<int> deleteUser(User user) async {
    var dbClient = await con.db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<User?> getLogin(String user, String password) async {
    var dbClient = await con.db;
    var res = await dbClient.rawQuery(
        "SELECT * FROM user WHERE username = '$user' and password = '$password'");
    if (res.length > 0) {
      return new User.fromMap(res.first);
    }
    return null;
  }

  Future<int?> makeRegister(String user, String password) async {
    var dbClient = await con.db;
    var res = await dbClient.rawQuery(
        "INSERT INTO user (username, password) VALUES ('$user', '$password')");
  }

  Future<List<User>?> getAllUser() async {
    var dbClient = await con.db;
    var res = await dbClient.query("user");

    List<User>? list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : null;
    return list;
  }
}
