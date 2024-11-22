import 'package:dio/dio.dart';
import 'package:weather_app/Models/weather_model.dart';

class ApiService {
  final dio = Dio();

  final String baseUrl =
      'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/';
  final String apiKey = 'YCVZZSMMKNN59RN74H9VEQDH4';

  Future<Weather?> fetchWeather(String location) async {
    final url = Uri.parse(
        "$baseUrl/$location?unitGroup=metric&key=$apiKey&contentType=json");
    final response = await dio.get(url.toString());

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;
      return Weather.fromJson(data);
    } else {
      print(response.statusCode);
      return null;
    }
  }
}