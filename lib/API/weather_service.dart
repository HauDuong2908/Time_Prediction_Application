import 'package:http/http.dart' as http;
import 'package:weather_app/Models/district.dart';
import 'dart:convert';
import 'package:weather_app/Models/weather_model.dart';

class ApiService {
  // Location
  String location = '';
  final List<String> cities = ['Đà Nẵng'];
  final selectedCities = District.getSelectedCities();

  // List Data
  List consolidateWeatherList = [];
  List forecastDays = [];

  // API
  final String baseUrl =
      'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/';
  final String apiKey = 'YCVZZSMMKNN59RN74H9VEQDH4';

  // Getter cho consolidateWeatherList
  List get data => consolidateWeatherList;

  Future<Weather?> fetchWeather(String location) async {
    final url = Uri.parse(
        "$baseUrl/$location?unitGroup=metric&key=$apiKey&contentType=json");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      print("Failed to load weather data. Status code: ${response.statusCode}");
      return null;
    }
  }
}
