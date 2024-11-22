import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Repo/WeatherRepo.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/Provider/weather_provider.dart';

class LocationProvider extends ChangeNotifier {
  Weather? weatherData;

  final WeatherRepo _weatherrepo;
  LocationProvider(this._weatherrepo);

  String location = '';
  bool isLoading = true;
  List<DailyWeather> weatherList = [];

  void setLocation(String newLocation) {
    if (location != newLocation) {
      location = newLocation;
      notifyListeners();
    }
  }

  Future<void> loadLocation(BuildContext context, String location) async {
    final weather = Provider.of<WeatherPro>(context, listen: false);

    setLocation(location);
    isLoading = true;
    notifyListeners();

    final weatherAPI = await _weatherrepo.fetchWeather("location");

    if (weatherAPI != null) {
      weatherData = weatherAPI;
      weatherList = weatherData!.days;

      if (weatherList.isNotEmpty) {
        final DateTime now = DateTime.now();
        int weekday = now.weekday;
        int future = 7 - weekday;

        final consolidateWeatherlists = weatherList.take(future + 7).toList();
        if (consolidateWeatherlists.isNotEmpty) {
          weather.updateWeatherData(consolidateWeatherlists[0]);
          weather.consolidateWeatherList = consolidateWeatherlists;
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }
}
