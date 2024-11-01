// weather
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
      locationName: json['address'],
      days: (json['day'] as List)
          .map((dayJson) => DailyWeather.fromJson(dayJson))
          .toList(),
    );
  }
}

//weather daily
class DailyWeather {
  String datetime;
  String weatherStateName = 'Loading...';
  int temperature;
  int maxTemp;
  int humidity;
  int winSpeed;

  DailyWeather(
      {required this.weatherStateName,
      required this.temperature,
      required this.maxTemp,
      required this.humidity,
      required this.winSpeed,
      required this.datetime});

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    final myDate = DateTime.parse(json[0]['datetime']);
    final currentDate = DateFormat('E MMM dd, yyyy').format(myDate);

    return DailyWeather(
      weatherStateName: json['conditions'] ?? '',
      temperature: json['temp'] as int,
      maxTemp: json['tempmax'] as int,
      humidity: json['humidity'] as int,
      winSpeed: json['windspeed'] as int,
      datetime: currentDate,
    );
  }
}
