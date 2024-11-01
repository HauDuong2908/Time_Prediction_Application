import 'package:http/http.dart' as http;
import 'package:weather_app/Models/district.dart';
import 'dart:convert';
import 'package:weather_app/Models/weather_model.dart';

class ApiService {
  //Location
  String location = '';
  final List<String> cities = ['Đà Nẵng'];
  final selectedCities = District.getSelectedCities();

  static String testProp = 'TEST';

  //List Data
  List consolidateWeatherList = [];
  List forecastDays = [];

  //API
  final String baseUrl =
      'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/';
  final String apiKey = 'YCVZZSMMKNN59RN74H9VEQDH4';

  Future<Weather?> fetchWeather(String location) async {
    final url = Uri.parse(
        "$baseUrl/$location?unitGroup=metric&key=$apiKey&contentType=json");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final consolidateWeather = result;
      final List<Map<String, dynamic>> dataList = [];
      final DateTime now = DateTime.now();

      int weekday = now.weekday;
      int future = 7 - weekday;
      // int past = 7 - future;

      for (int i = 0; i < future + 7; i++) {
        dataList.add(consolidateWeather[i]);
      }
      consolidateWeatherList = dataList.toSet().toList();
      return Weather.fromJson(result);
    }
    return null;
  }
}
