class Restaurant {
  final int id;
  final String name;
  final String description;
  final String image;
  final String logo;
  final double rating;
  final double distance;
  final double deliveryTime;
  final List<String> category;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.logo,
    required this.rating,
    required this.distance,
    required this.deliveryTime,
    required this.category,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: (json['description'] ?? "").toString().trim(),
      image: json["image"],
      logo: json["logo"],
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
      distance: (json["distance"] as num?)?.toDouble() ?? 0.0,
      deliveryTime: (json["deliveryTime"] as num?)?.toDouble() ?? 0.0,
      category: json["categoryName"] != null
          ? List<String>.from(json["categoryName"])
          : [],
    );
  }
}
