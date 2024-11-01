import 'package:flutter/material.dart';
import 'package:weather_app/API/weather_service.dart';
import 'package:weather_app/Models/district.dart';
import 'package:weather_app/Models/weather_model.dart';

class WeatherPro extends ChangeNotifier {
  ApiService weatherService = ApiService();
  Weather? weatherData;

  String location = '';
  String? errorMessage;
  String imageUrl = '';
  bool isSaved = false;

  // List
  final List<String> cities = ['Đà Nẵng'];
  List consolidateWeatherList = [];
  List forecastDays = [];

  final selectedCities = District.getSelectedCities();

  Future<void> _loadWeather() async {
    final weather = await ApiService().fetchWeather(location);
    weatherData = weather;
  }
}
