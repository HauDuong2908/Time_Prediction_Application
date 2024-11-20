import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Models/district.dart';
import 'package:weather_app/Provider/location_provider.dart';

class Initializeasyncdata extends ChangeNotifier {
  List<String> citiesWeather = [];

  Future<void> initializeAsyncData(BuildContext context) async {
    final location = Provider.of<LocationProvider>(context, listen: false);
    final selectedCities = District.getSelectedCities();

    for (var city in selectedCities) {
      citiesWeather.add(city.city);
    }

    citiesWeather = citiesWeather.toSet().toList();

    if (citiesWeather.isNotEmpty) {
      final citiesLocation = citiesWeather[0];
      await location.loadLocation(context, citiesLocation);
    }
  }
}
