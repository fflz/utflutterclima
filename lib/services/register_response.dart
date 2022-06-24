import 'package:utflutterclima/services/register_request.dart';
import 'package:utflutterclima/models/user.dart';

abstract class RegisterCallBack {
  void onRegisterSuccess(User user);
  void onRegisterError(String error);
}

class RegisterResponse {
  RegisterCallBack _callBack;
  RegisterRequest registerRequest = new RegisterRequest();
  RegisterResponse(this._callBack);
  doLogin(String username, String password) {
    registerRequest
        .makeRegister(username, password)
        .then((user) => _callBack.onRegisterSuccess(user!))
        .catchError((onError) => _callBack.onRegisterError(onError.toString()));
  }

  void makeRegister(String username, String password) {}
}
