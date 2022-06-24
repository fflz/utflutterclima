import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:utflutterclima/models/user.dart';
import 'package:utflutterclima/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utflutterclima/screens/register_screen.dart';
import 'package:geolocator/geolocator.dart';
import '../services/login_response.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  int resposta = 1;
  String city = "";

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  _LoginPageState() {
    _response = LoginResponse(this);
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  Future<String> location(double lat, double long) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyBLZhg8_hVfas7rTv_Lp3dwbVKvdFjsEQI');
    Response response = await http.get(url);
    Map<String, dynamic> data = jsonDecode(response.body);
    String cityName = data["results"][0]["address_components"][3]["long_name"];

    return cityName;
  }

  Future<String> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;
    //print("Latitude: $lat and Longitude: $long");
    final coordinates = new Coordinates(lat, long);
    String city = await location(lat, long);
    return await city;
  }

  void _submit() {
    final form = formKey.currentState;

    if (form!.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        //_response.doLogin(_username, _password);
      });
    }
  }

  void _submitRegister() {
    final form = formKey.currentState;
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
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        var loginBtn = RaisedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomeScreen((signOut))));
          },
          child: Text("Login"),
          color: Colors.green,
        );
        var registerBtn = RaisedButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => registerPage()));
          },
          child: new Text("Cadastro"),
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
          body: Container(
            child: Center(
              child: loginForm,
            ),
          ),
        );

      case LoginStatus.signIn:
        return HomeScreen((signOut));
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
  void onLoginError(String error) {
    _showSnackBar("Usuario ou senha incorreta!");
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onRegister(String error) {
    _showSnackBar("Usuario cadastrado com sucesso!");
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
