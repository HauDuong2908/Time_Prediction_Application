import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:weather_app/Models/location_model.dart';

class LocationService {
  @override
  // ignore: override_on_non_overriding_member
  Future<List<Location>?> loadDataLocation() async {
    final String response = await rootBundle.loadString('json\cities.json');
    final jsonBody = jsonDecode(response) as Map;
    final locationList = jsonBody['Location'] as List;
    List<Location> location =
        locationList.map((location) => Location.fromJson(location)).toList();
    return location;
  }
}
