import 'package:intl/intl.dart';

class Weather {
  final String locationName;
  final List<DailyWeather> days;

  Weather({
    required this.locationName,
    required this.days,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      locationName: json['address'] ?? 'Unknown Location',
      days: (json['days'] as List<dynamic>?)
              ?.map((dayJson) => DailyWeather.fromJson(dayJson))
              .toList() ??
          [],
    );
  }
}

//weather daily
class DailyWeather {
  String datetime;
  String weatherStateName;
  int temperature;
  int maxTemp;
  int humidity;
  int winSpeed;

  DailyWeather({
    required this.weatherStateName,
    required this.temperature,
    required this.maxTemp,
    required this.humidity,
    required this.winSpeed,
    required this.datetime,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    final myDate = DateTime.tryParse(json['datetime'] ?? '') ?? DateTime.now();
    final currentDate = DateFormat('E MMM dd, yyyy').format(myDate);

    return DailyWeather(
      weatherStateName: json['conditions'] ?? 'Unknown',
      temperature: (json['temp'] ?? 0).toInt(),
      maxTemp: (json['tempmax'] ?? 0).toInt(),
      humidity: (json['humidity'] ?? 0).toInt(),
      winSpeed: (json['windspeed'] ?? 0).toInt(),
      datetime: currentDate,
    );
  }
}
