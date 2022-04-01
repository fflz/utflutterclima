import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static Future getWeatherDataByCity(String city) async {
    return await http.get(
        Uri.parse(
            "https://api.collectapi.com/weather/getWeather?data.lang=en&data.city=$city"),
        headers: {
          HttpHeaders.authorizationHeader:
              'apikey 2noi5N915HwsDfwrFh2sOW:4HtH986I681sZOenuictHs',
          HttpHeaders.contentTypeHeader: 'application/json'
        });
  }
}
/* REPOSTA DA API, retirado diretamente do link https://collectapi.com/api/weather/weather-api?tab=pricing 
   Porém, no nosso app a resposta é em ingles diferente do exemplo abaixo que retorna em turco (origem do site/api)
{
  "result": [
    {
      "date": "24.09.2018",
      "day": "Pazartesi",
      "icon": "https://image.flaticon.com/icons/svg/143/143769.svg",
      "description": "açık",
      "status": "Clear",
      "degree": "31",
      "min": "11.6",
      "max": "31",
      "night": "11.6",
      "humidity": "17"
    },
    {
      "date": "25.09.2018",
      "day": "Salı",
      "icon": "https://image.flaticon.com/icons/svg/143/143769.svg",
      "description": "yağmurlu",
      "status": "Rainy",
      "degree": "24.14",
      "min": "7.63",
      "max": "25.82",
      "night": "9.09",
      "humidity": "35"
    },
    "..."
  ]
} */
