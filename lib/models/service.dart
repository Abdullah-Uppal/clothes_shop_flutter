class Service {
  final String id;
  final String name;
  final String description;

  Service({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
