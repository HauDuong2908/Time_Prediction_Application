// ignore: file_names
import 'package:dio/dio.dart';
import 'package:weather_app/API/Config/config.dart';

class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: Config.baseUrl,
          ),
        );

  Future<Response> getApi(String location) async {
    final url =
        "${Config.baseUrl}/$location?unitGroup=metric&key=${Config.apiKey}&contentType=json";
    return await _dio.get(url.toString());
  }
}
