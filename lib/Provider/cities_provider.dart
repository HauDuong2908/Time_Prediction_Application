import 'package:flutter/material.dart';
import 'package:weather_app/Models/district.dart';

class CitiesProvider extends ChangeNotifier {
  List<District> citiesLocation = [];
  List<District> selectedCities = [];

  Future<void> loadDistricts() async {
    await District.loadDistrictsFromJson();

    citiesLocation = District.citiesList
        .where((district) => district.isDefault == false)
        .toSet()
        .toList();

    selectedCities = District.getSelectedCities();
    notifyListeners();
  }

  void toggleCitySelection(District city) {
    city.isSlected = !city.isSlected;
    if (city.isSlected && !selectedCities.contains(city)) {
      selectedCities.add(city);
    } else if (!city.isSlected) {
      selectedCities.removeWhere((c) => c.city == city.city);
    }
    notifyListeners();
  }

  String addLocation(String location) {
    final city = citiesLocation.firstWhere(
      (district) => district.city.toLowerCase() == location.toLowerCase(),
      orElse: () => District(
          city: 'not found', isDefault: false, isSlected: false, country: ''),
    );

    if (city.city == 'not found') {
      return "Không tìm thấy địa điểm";
    } else if (!selectedCities.any((c) => c.city == city.city)) {
      city.isSlected = true;
      selectedCities.add(city);
      notifyListeners();
      return "Đã thêm địa điểm thành công";
    } else {
      return "Địa điểm đã tồn tại";
    }
  }
}
