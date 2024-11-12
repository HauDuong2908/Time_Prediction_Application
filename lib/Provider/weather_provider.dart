import 'package:flutter/material.dart';
import 'package:weather_app/API/weather_service.dart';
import 'package:weather_app/Models/district.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/widget/weather_enum.dart';

class WeatherPro extends ChangeNotifier {
  final ApiService weatherService = ApiService();
  bool isLoading = true; // Trạng thái tải
  Weather? weatherData;

  String? selectedDate;
  int selectedDayIndex = 0;

  final int selectedId = 0;
  List<String> listWeatherState = [];

  String location = '';
  String? errorMessage;
  String imageUrl = '';
  bool isSaved = false;

  String weatherStateNames = 'Loading...';
  int temperatures = 0;
  int maxTemps = 0;
  int humidities = 0;
  int precipprob = 0;
  int winSpeeds = 0;
  String currentDates = 'Loading...';

  // List
  final List<String> cities = [];

  List<DailyWeather> weatherList = [];
  List<DailyWeather> consolidateWeatherList = [];

  Future<void> loadLocation(String location) async {
    isLoading = true;
    notifyListeners();

    final weatherAPI = await weatherService.fetchWeather(location);

    if (weatherAPI != null) {
      weatherData = weatherAPI;
      weatherList = weatherData!.days;

      if (weatherList.isNotEmpty) {
        final DateTime now = DateTime.now();
        int weekday = now.weekday;
        int future = 7 - weekday;

        final consolidateWeatherlists = weatherList.take(future + 7).toList();
        if (consolidateWeatherlists.isNotEmpty) {
          updateWeatherData(consolidateWeatherlists[0]);
          consolidateWeatherList = consolidateWeatherlists;
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }

  void updateWeatherData(DailyWeather weather) {
    weatherStateNames = weather.weatherStateName;
    temperatures = weather.temperature;
    maxTemps = weather.maxTemp;
    humidities = weather.humidity;
    precipprob = weather.precipprob;
    winSpeeds = weather.winSpeed;
    currentDates = weather.datetime;

    listWeatherState = weatherStateNames.split(',');
    final listEnumState = listWeatherState
        .map((e) => WeatherState.getEnumFromCode(e.trim()))
        .whereType<WeatherState>()
        .toList();

    imageUrl = listEnumState.isNotEmpty ? listEnumState.first.image : '';
  }

  void selectDay(int index) async {
    if (index < consolidateWeatherList.length) {
      selectedDayIndex = index;
      updateWeatherData(consolidateWeatherList[index]);
      selectedDate = consolidateWeatherList[index].datetime;
      notifyListeners();
    }
  }

  Future<void> initializeAsyncData() async {
    final selectedCities = District.getSelectedCities();

    for (var city in selectedCities) {
      cities.add(city.city);
    }

    if (cities.isNotEmpty) {
      final citiesLocation = cities[0];
      await loadLocation(citiesLocation);
    }
  }
}
