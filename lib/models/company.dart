class Company {
  final String id;
  final String name;
  final String description;
  final String employeeCount;
  final String location;
  final String logoUrl; // Placeholder for now, can be asset or network image
  final String website;

  Company({
    required this.id,
    required this.name,
    required this.description,
    required this.employeeCount,
    required this.location,
    this.logoUrl = '',
    this.website = '',
  });
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'].toString(),
      name: json['place_name'] ?? 'Unknown Company',
      description: json['description'] ?? '',
      employeeCount: json['employee_count']?.toString() ?? 'Unknown',
      location: json['city'] ?? 'Unknown Location',
      logoUrl: json['logo'] ?? '',
      website: json['website'] ?? '',
    );
  }
}

