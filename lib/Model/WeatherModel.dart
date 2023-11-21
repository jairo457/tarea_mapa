class WeatherModel {
  String? main;
  String? description;
  double? temp;
  double? feels_like;
  double? temp_min;
  double? temp_max;
  double? humidity;
  String? icon;
  String? dat;

  WeatherModel({
    this.main,
    this.description,
    this.temp,
    this.feels_like,
    this.temp_min,
    this.temp_max,
    this.humidity,
    this.icon,
    this.dat,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      main: map['main'] ?? '',
      //cualense ??, si es nulo lo de la izquierda
      //asigna lo de la derecha
      description: map['description'],
      temp:
          (map['temp'] is int) ? (map['temp'] as int).toDouble() : map['temp'],
      feels_like: (map['feels_like'] is int)
          ? (map['feels_like'] as int).toDouble()
          : map['feels_like'],
      temp_min: (map['temp_min'] is int)
          ? (map['temp_min'] as int).toDouble()
          : map['temp_min'],
      temp_max: (map['temp_max'] is int)
          ? (map['temp_max'] as int).toDouble()
          : map['temp_max'],
      humidity: (map['humidity'] is int)
          ? (map['humidity'] as int).toDouble()
          : map['humidity'],
      icon: map['icon'] ?? '',
      dat: map['dat'] ?? '',
    );
  }
}
