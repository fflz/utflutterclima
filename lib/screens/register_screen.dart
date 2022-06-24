import 'package:flutter/material.dart';
import 'package:utflutterclima/models/user.dart';
import 'package:utflutterclima/screens/home_screen.dart';
import 'package:utflutterclima/services/register_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/register_ctr.dart';

class registerPage extends StatefulWidget {
  const registerPage({Key? key}) : super(key: key);
  @override
  State<registerPage> createState() => _registerPageState();
}

enum registerStatus { notSignIn, signIn }

class _registerPageState extends State<registerPage>
    implements RegisterCallBack {
  registerStatus _registerStatus = registerStatus.notSignIn;
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late String _username, _password;

  late RegisterResponse _response;

  _registerPageState() {
    _response = RegisterResponse(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form!.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _response.makeRegister(_username, _password);
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _registerStatus =
          value == 1 ? registerStatus.signIn : registerStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.commit();
      _registerStatus = registerStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_registerStatus) {
      case registerStatus.notSignIn:
        var registerBtn = RaisedButton(
          onPressed: _submit,
          child: Text("register"),
          color: Colors.green,
        );
        var registerForm = Column(
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
                      decoration: InputDecoration(labelText: "Username"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onSaved: (val) => _password = val!,
                      decoration: InputDecoration(labelText: "Password"),
                    ),
                  )
                ],
              ),
            ),
            registerBtn
          ],
        );

        return Scaffold(
          appBar: AppBar(
            title: Text("register Page"),
          ),
          key: scaffoldKey,
          body: Container(
            child: Center(
              child: registerForm,
            ),
          ),
        );
        break;
      case registerStatus.signIn:
        return HomeScreen(signOut);
        break;
    }
  }

  savePref(int value, String user, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("user", user);
      preferences.setString("pass", pass);
      preferences.commit();
    });
  }

  @override
  void onRegisterError(String error) {
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onRegisterSuccess(User user) async {
    if (user != null) {
      savePref(1, user.username, user.password);
      _registerStatus = registerStatus.signIn;
    } else {
      _showSnackBar("Registro concluido com sucesso");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
