import 'package:weather_app/API/Service/WeatherService.dart';
import 'package:weather_app/Models/weather_model.dart';

class WeatherRepo {
  final Weatherservice _weatherservice;

  WeatherRepo(this._weatherservice);

  Future<Weather?> fetchWeather(String location) async {
    try {
      return await _weatherservice.fetchApi(location);
    } catch (e) {
      throw Exception(e);
    }
  }
}
