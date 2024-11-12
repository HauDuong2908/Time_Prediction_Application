import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class District {
  bool isSlected;
  final String city;
  final String country;
  final bool isDefault;

  District({
    required this.isSlected,
    required this.city,
    required this.country,
    required this.isDefault,
  });

  static List<District> citiesList = [];

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      isSlected: false,
      city: json['city'],
      country: 'Việt Nam',
      isDefault: false,
    );
  }

  static List<District> getSelectedCities() {
    return citiesList.where((district) => district.isSlected).toList();
  }

  static Future<void> loadDistrictsFromJson() async {
    final String response = await rootBundle.loadString('json/cities.json');
    final List<dynamic> data = json.decode(response);

    citiesList = data.map((item) => District.fromJson(item)).toList();
  }
}
