/// Model class representing a real estate property.
class Property {
  final String id;
  final String title;
  final String city;
  final String type; // Flat, House, Villa
  final int price; // Price in INR
  final int bedrooms;
  final int area; // Area in sq ft
  final String description;
  bool isFavorite;

  Property({
    required this.id,
    required this.title,
    required this.city,
    required this.type,
    required this.price,
    required this.bedrooms,
    required this.area,
    required this.description,
    this.isFavorite = false,
  });
}
