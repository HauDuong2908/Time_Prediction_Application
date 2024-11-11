import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:weather_app/Models/district.dart';

class LocationService {
  final dio = Dio();

  Future<List<District>> fetchLocation() async {
    final response = await dio.get("https://provinces.open-api.vn/api/");

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(jsonDecode(response.data));
      return District.fromJsonList(data);
    } else {
      throw Exception('Error fetching locations');
    }
  }
}
