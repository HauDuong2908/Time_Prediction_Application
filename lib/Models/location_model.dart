// ignore_for_file: public_member_api_docs, sort_constructors_first

class Location {
  String name;
  String division_type;

  Location({
    required this.name,
    required this.division_type,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    String name = (json['name'] ?? 'Unknown')
        .replaceAll(RegExp(r'\b(Thành Phố|Tỉnh)\b'), '')
        .trim();

    return Location(
      name: name,
      division_type: json['division_type'] ?? 'Unknown',
    );
  }
}
