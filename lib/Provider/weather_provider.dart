import 'package:flutter/material.dart';
import 'package:weather_app/API/weather_service.dart';
import 'package:weather_app/Models/district.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/widget/weather_enum.dart';

class WeatherPro extends ChangeNotifier {
  final ApiService weatherService = ApiService();
  Weather? weatherData;

  String? selectedDate;
  int selectedDayIndex = 0;

  final int selectedId = 0;

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
  List<dynamic> weatherList = [];
  List<dynamic> consolidateWeatherList = [];
  List<dynamic> forecastDays = [];

  final selectedCities = District.getSelectedCities();

  // Phương thức tải dữ liệu thời tiết cho một thành phố
  Future<void> loadWeather(String location) async {
    try {
      final weatherAPI = await weatherService.fetchWeather(location);

      if (weatherAPI != null) {
        weatherData = weatherAPI;
        weatherList = weatherData!.days;

        if (weatherList.isNotEmpty) {
          // Tính toán ngày hiện tại và lấy dữ liệu thời tiết 7 ngày tiếp theo
          final DateTime now = DateTime.now();
          int weekday = now.weekday;
          int future = 7 - weekday;

          final consolidateWeatherlists = weatherList.take(future + 7).toList();
          if (consolidateWeatherlists.isNotEmpty) {
            updateWeatherData(consolidateWeatherlists[0]);
            consolidateWeatherList = consolidateWeatherlists;
          }
        }
        notifyListeners();
      }
    } catch (e) {
      errorMessage = "Lỗi khi tải dữ liệu thời tiết: $e";
      notifyListeners();
    }
  }

  // Phương thức cập nhật dữ liệu thời tiết cho ngày đã chọn
  void updateWeatherData(dynamic weather) {
    weatherStateNames = weather.weatherStateName ?? 'N/A';
    temperatures = weather.temperature ?? 0;
    maxTemps = weather.maxTemp ?? 0;
    humidities = weather.humidity ?? 0;
    winSpeeds = weather.winSpeed ?? 0;
    currentDates = weather.datetime ?? 'N/A';

    // Lấy trạng thái thời tiết từ chuỗi
    final listWeatherState = weatherStateNames.split(',');
    final listEnumState = listWeatherState
        .map((e) => WeatherState.getEnumFromCode(e.trim()))
        .whereType<WeatherState>()
        .toList();

    imageUrl = listEnumState.isNotEmpty ? listEnumState.first.image : '';
  }

  // Lấy dữ liệu thời tiết cho ngày được chọn
  Weather? getWeatherForSelectedDay() {
    if (consolidateWeatherList.isNotEmpty &&
        selectedDayIndex < consolidateWeatherList.length) {
      return consolidateWeatherList[selectedDayIndex];
    }
    return null;
  }

  // Phương thức để cập nhật ngày đã chọn
  Future<void> selectDay(int index) async {
    if (index < consolidateWeatherList.length) {
      selectedDayIndex = index;
      updateWeatherData(consolidateWeatherList[index]);
      selectedDate = consolidateWeatherList[index].datetime;
      notifyListeners();
    }
  }
}
