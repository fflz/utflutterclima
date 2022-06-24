class Weather {
  late String date;
  late String day;
  late String icon;
  late String description;
  late String status;
  late String degree;
  late String min;
  late String max;
  late String night;
  late String humidity;

  Weather(Map json) {
    date = json['date'] ?? "Erro 100";
    day = json['day'] ?? "Erro 101";
    icon = json['icon'] ?? "Erro 102";
    description = json['description'] ?? "Erro 103";
    status = json['status'] ?? "Erro 104";
    degree = json['degree'] ?? "Erro 105";
    min = json['min'] ?? "Erro 106";
    max = json['max'] ?? "Erro 107";
    night = json['night'] ?? "Erro 108";
    humidity = json['humidity'] ?? "Erro 109";
  }
}
