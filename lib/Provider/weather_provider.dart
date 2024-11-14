import 'package:flutter/material.dart';
import 'package:weather_app/API/weather_service.dart';
import 'package:weather_app/Models/district.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/widget/weather_enum.dart';

class WeatherPro extends ChangeNotifier {
  final ApiService weatherService = ApiService();
  bool isLoading = true;
  Weather? weatherData;

  String? selectedDate;
  int selectedDayIndex = 0;

  final int selectedId = 0;
  List<String> listWeatherState = [];
  List<District> citiesLocation = [];
  List<District> selectedCities = [];

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

  List<String> citiesWeather = [];

  List<DailyWeather> weatherList = [];
  List<DailyWeather> consolidateWeatherList = [];

  void setLocation(String newLocation) {
    if (location != newLocation) {
      location = newLocation;
      notifyListeners();
    }
  }

  Future<void> loadLocation(String location) async {
    setLocation(location);
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
      citiesWeather.add(city.city);
    }

    citiesWeather = citiesWeather.toSet().toList();

    if (citiesWeather.isNotEmpty) {
      final citiesLocation = citiesWeather[0];
      await loadLocation(citiesLocation);
    }
  }

  Future<void> loadDistricts() async {
    await District.loadDistrictsFromJson();

    citiesLocation = District.citiesList
        .where((district) => district.isDefault == false)
        .toSet()
        .toList();

    selectedCities = District.getSelectedCities();
    notifyListeners();
  }

  void toggleCitySelection(District city) {
    city.isSlected = !city.isSlected;
    if (city.isSlected && !selectedCities.contains(city)) {
      selectedCities.add(city);
    } else if (!city.isSlected) {
      selectedCities.removeWhere((c) => c.city == city.city);
    }
    notifyListeners();
  }

  String addLocation(String location) {
    final city = citiesLocation.firstWhere(
      (district) => district.city.toLowerCase() == location.toLowerCase(),
      orElse: () => District(
          city: 'not found', isDefault: false, isSlected: false, country: ''),
    );

    if (city.city == 'not found') {
      return "Không tìm thấy địa điểm";
    } else if (!selectedCities.any((c) => c.city == city.city)) {
      city.isSlected = true;
      selectedCities.add(city);
      notifyListeners();
      return "Đã thêm địa điểm thành công";
    } else {
      return "Địa điểm đã tồn tại";
    }
  }
}
