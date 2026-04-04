class RestaurantDetail {
  final int id;
  final String name;
  final String description;
  final String rating;
  final String image;
  final String logo;
  final String supportPhone;
  final String supportEmail;
  final bool isFreeDelivery;
  final int? deliveryTime;
  final Map<String, dynamic> address;
  final List<Map<String, dynamic>>? workingDays;
  final List<Map<String, dynamic>>? itemList;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.logo,
    required this.supportPhone,
    required this.supportEmail,
    required this.address,
    required this.workingDays,
    required this.rating,
    required this.isFreeDelivery,
    required this.deliveryTime,
    required this.itemList,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'] ?? 0,
      description: json['description'] ?? "No Description",
      image: json["image"] ?? "",
      logo: json['logo'] ?? "",
      supportPhone: json['supportPhone']?.toString() ?? "N/A",
      supportEmail: json['supportEmail'] ?? "N/A",
      address: json['address'] as Map<String, dynamic>? ?? {},
      workingDays:
          (json['workingDays'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .toList() ??
          [],
      name: json['name'] ?? "",
      rating: json['rating'].toString(),
      isFreeDelivery:
          json["isFreeDelivery"] == 1 || json["isFreeDelivery"] == true,
      deliveryTime: json["deliveryTime"] is int ? json["deliveryTime"] : null,
      itemList:
          (json['itemList'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .toList() ??
          [],
    );
  }
}
