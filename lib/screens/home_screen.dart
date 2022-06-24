import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:utflutterclima/models/weather.dart';
import 'package:utflutterclima/services/api_service.dart';
import 'package:utflutterclima/utilities/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback signOut;
  const HomeScreen(this.signOut, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Icon customIcon = const Icon(Icons.search_sharp);
  Widget customSearchBar = const Text('Cidade');
  String city = "";
  List<Weather> weatherList = [];

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  var value;

  String getValue(state) {
    state ??= "UG9udGElMjBHcm9zc2E=";
    return (utf8.decode(base64.decode(state)));
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
    });
  }

  @override
  void initState() {
    getWeatherData(getValue(null));
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    if (weatherList.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: buildBackGroundColorGradient(weatherList[0].status),
          ),
        ),
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          appBar: buildAppBarWidget(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Image.network(weatherList[0].icon,
                  width: MediaQuery.of(context).size.width / 3),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                "${double.parse(weatherList[0].degree).round().toString()}°C",
                style: TextStyle(
                  fontSize: 70.0,
                  fontWeight: FontWeight.w300,
                  color: buildTextColor(weatherList[0].status),
                ),
              ),
              Text(
                buildWeatherStatusListText(weatherList[0].description),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w300,
                  color: buildTextColor(weatherList[0].status),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: weatherList.length - 1,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            buildWeatherListText(weatherList[index + 1].day),
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          Image.network(
                            weatherList[index + 1].icon,
                            height: 50,
                          ),
                          Row(
                            children: [
                              Text(
                                "${double.parse(weatherList[index + 1].min).round()}°",
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Color.fromARGB(255, 0, 51, 255),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "${double.parse(weatherList[index + 1].max).round()}°",
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Color.fromARGB(161, 255, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Color.fromARGB(0, 0, 0, 0),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  List<Color> buildBackGroundColorGradient(String weather) {
    if (weather.toLowerCase() == "snow") {
      return [niceWhite, niceDarkBlue];
    } else if (weather.toLowerCase() == "rain") {
      return [niceVeryDarkBlue, niceDarkBlue];
    } else {
      return [niceBlue, niceDarkBlue];
    }
  }

  Color buildTextColor(String weather) {
    if (weather.toLowerCase() == "snow") {
      return niceTextDarkBlue;
    } else if (weather.toLowerCase() == "rain") {
      return Colors.black;
    } else {
      return Colors.black;
    }
  }

  void getWeatherData(String cityData) {
    ApiService.getWeatherDataByCity(cityData).then((data) {
      Map resultBody = json.decode(data.body);
      if (resultBody['success'] == true) {
        setState(() {
          city = resultBody['city'];
          Iterable result = resultBody['result'];
          weatherList =
              result.map((watherData) => Weather(watherData)).toList();
        });
      }
    });
  }

  AppBar buildAppBarWidget() {
    return AppBar(
      leading: IconButton(
        color: Colors.black,
        onPressed: () {
          signOut();
        },
        icon: Icon(Icons.logout_sharp),
        iconSize: 45,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            buildWeatherListText(weatherList[0].day),
            style: TextStyle(
              fontSize: 16.0,
              color: buildTextColor(weatherList[0].status),
            ),
          ),
          Text(
            weatherList[0].date,
            style: TextStyle(
              fontSize: 16.0,
              color: buildTextColor(weatherList[0].status),
            ),
          ),
        ],
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_pin,
                  color: buildTextColor(weatherList[0].status),
                ),
                Text(
                  city.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: buildTextColor(weatherList[0].status),
                  ),
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          width: 15.0,
        ),
        IconButton(
          icon: customIcon,
          onPressed: () {
            setState(() {
              if (customIcon.icon == Icons.search) {
                print("implementar"); // busca cidade
              } else {
                customIcon = const Icon(Icons.search);
                customSearchBar = const Text('Cidade');
              }
            });
          },
          color: Colors.black,
        )
      ],
    );
  }

  String buildWeatherStatusListText(String description) {
    switch (description.toLowerCase()) {
      case "heavy intensity rain":
        return "chuva forte";
      case "moderate rain":
        return "chuva moderada";
      case "light rain":
        return "chuva fraca";
      case "light snow":
        return "neve fraca";
      case "heavy intensity snow":
        return "neve forte";
      case "sky is clear":
        return "céu limpo";
      case "overcast clouds":
        return "nublado";
      default:
        return "to do";
    }
  }

  String buildWeatherListText(String day) {
    switch (day.toLowerCase()) {
      case "monday":
        return "Segunda-feira";
      case "tuesday":
        return "Terça-feira      ";
      case "wednesday":
        return "Quarta-feira    ";
      case "thursday":
        return "Quinta-feira     ";
      case "friday":
        return "Sexta-Feira      ";
      case "saturday":
        return "Sábado           ";
      case "sunday":
        return "Domingo         ";
      default:
        return "erro api";
    }
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
