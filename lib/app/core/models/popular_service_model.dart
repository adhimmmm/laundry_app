class PopularService {
  final int id;
  final String name;
  final String subtitle;
  final String price;
  final String description;
  final String? image_url;

  PopularService({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.description,
    this.image_url,
  });

  factory PopularService.fromMap(Map<String, dynamic> json) {
    return PopularService(
      id: json['id'],
      name: json['name'],
      subtitle: json['subtitle'],
      price: json['price'].toString(),
      description: json['description'] ?? '',
      image_url: json['image'],
    );
  }
}
