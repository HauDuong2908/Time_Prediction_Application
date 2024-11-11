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

  // Phương thức để tạo danh sách các đối tượng District từ dữ liệu JSON
  static List<District> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((locationJson) {
      return District(
        isSlected: false,
        city: locationJson['name'] ?? '',
        country: 'Việt Nam',
        isDefault: false,
      );
    }).toList();
  }

  static List<District> getSelectedCities(List<District> districts) {
    return districts.where((district) => district.isSlected).toList();
  }
}
