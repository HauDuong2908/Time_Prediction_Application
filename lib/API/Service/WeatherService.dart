import 'package:weather_app/API/Client/API_client.dart';
import 'package:weather_app/Models/weather_model.dart';

class Weatherservice {
  final ApiClient _apiClient;

  Weatherservice(this._apiClient);

  Future<Weather?> fetchApi(String location) async {
    final response = await _apiClient.getApi(location);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;
      return Weather.fromJson(data);
    } else {
      print(response.statusCode);
      return null;
    }
  }
}
