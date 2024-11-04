import 'package:flutter/material.dart';
import 'package:weather_app/API/weather_service.dart';
import 'package:weather_app/Models/district.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/widget/weather_enum.dart';

class WeatherPro extends ChangeNotifier {
  ApiService weatherService = ApiService();
  Weather? weatherData;

  String location = '';
  String? errorMessage;
  String imageUrl = '';
  bool isSaved = false;

  // Khai báo biến với giá trị mặc định.
  String weatherStateNames = 'Loading...';
  int temperatures = 0;
  int maxTemps = 0;
  int humidities = 0;
  int winSpeeds = 0;
  String currentDates = 'Loading...';

  // List
  final List<String> cities = ['Đà Nẵng'];
  List WeatherList = [];
  List consolidateWeatherList = [];
  List forecastDays = [];

  final selectedCities = District.getSelectedCities();

  Future<void> loadWeather(String location) async {
    final weatherAPI = await ApiService().fetchWeather(location);
    debugPrint('weatherAPI: $weatherAPI');

    if (weatherAPI != null) {
      weatherData = weatherAPI;

      // Thay đổi cách lấy trạng thái thời tiết
      WeatherList = weatherData!.days;

      if (WeatherList.isNotEmpty) {
        final DateTime now = DateTime.now();
        int weekday = now.weekday;
        int future = 7 - weekday;

        final consolidateWeatherlists = WeatherList.take(future + 7).toList();

        weatherStateNames = consolidateWeatherlists[0].weatherStateName;
        temperatures = consolidateWeatherlists[0].temperature;
        maxTemps = consolidateWeatherlists[0].maxTemp;
        humidities = consolidateWeatherlists[0].humidity;
        winSpeeds = consolidateWeatherlists[0].winSpeed;
        currentDates = consolidateWeatherlists[0].datetime;

        // Lấy trạng thái thời tiết từ chuỗi
        final listWeatherState = weatherStateNames.split(',');
        final listEnumState = listWeatherState
            .map((e) => WeatherState.getEnumFromCode(e.trim()))
            .toList();

        // Kiểm tra và lấy image

        imageUrl = listEnumState.first.image;

        consolidateWeatherList = consolidateWeatherlists.toSet().toList();
        debugPrint('List weather: $consolidateWeatherList');

        notifyListeners();
      }
    } else {
      errorMessage = "Failed to fetch weather data.";
    }
  }
}
