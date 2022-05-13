import 'package:flutter/material.dart';
import 'package:utflutterclima/models/user.dart';
import 'package:utflutterclima/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/login_ctr.dart';

import '../services/login_response.dart';
import '../utilities/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> implements LoginCallBack {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  late String _username, _password;
  late LoginResponse _response;
  late RegisterResponse _Rresponse;
  int resposta = 0;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  _LoginPageState() {
    _response = LoginResponse(this);
    _Rresponse = RegisterResponse();
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  void _submit() {
    final form = formKey.currentState;

    if (form!.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _response.doLogin(_username, _password);
      });
    }
  }

  void _submitRegister() {
    final form = formKey.currentState;

    if (form!.validate()) {
      setState(() {
        form.save();
        resposta = _Rresponse.doRegister(_username, _password);
        _showSnackBar("Usuario cadastrado com sucesso!");
      });
    }
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        var loginBtn = RaisedButton(
          onPressed: _submit,
          child: Text("Login"),
          color: Colors.green,
        );
        var registerBtn = RaisedButton(
          onPressed: _submitRegister,
          child: Text("Cadastro"),
          color: Colors.green,
        );
        var loginForm = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onSaved: (val) => _username = val!,
                      decoration: InputDecoration(labelText: "Usuario"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                        onSaved: (val) => _password = val!,
                        decoration: InputDecoration(labelText: "Senha"),
                        obscureText: true),
                  )
                ],
              ),
            ),
            loginBtn,
            registerBtn
          ],
        );

        return Scaffold(
          appBar: AppBar(
            title: Text("UTFlutter Login"),
          ),
          key: scaffoldKey,
          body: Center(
            child: loginForm,
          ),
        );
      case LoginStatus.signIn:
        return HomeScreen(signOut);
    }
  }

  savePref(int value, String user, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("user", user);
      preferences.setString("pass", pass);
    });
  }

  @override
  void onLoginError(String error) {
    _showSnackBar("Usuario ou senha incorreta!");
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(User user) async {
    if (user != null) {
      savePref(1, user.username, user.password);
      _loginStatus = LoginStatus.signIn;
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
