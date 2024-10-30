// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  static List<District> citiesList = [
    District(
        isSlected: false,
        city: 'Hà Nội',
        country: 'Việt Nam',
        isDefault: false),
    District(
        isSlected: false,
        city: 'Hồ CHí Minh',
        country: 'Việt Nam',
        isDefault: false),
    District(
        isSlected: false,
        city: 'Quảng Nam',
        country: 'Việt Nam',
        isDefault: false),
  ];

  static List<District> getSelectedCities() {
    List<District> selectedCities = District.citiesList;
    return selectedCities
        .where((district) => district.isSlected == true)
        .toList();
  }
}
