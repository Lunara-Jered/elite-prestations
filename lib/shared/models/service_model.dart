class ServiceModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final List<String> features;
  final int basePrice;
  final String unit;
  final String? imageUrl;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.features,
    required this.basePrice,
    required this.unit,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'description': description,
        'features': features,
        'basePrice': basePrice,
        'unit': unit,
        'imageUrl': imageUrl,
      };

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
        description: json['description'] as String,
        features: (json['features'] as List<dynamic>).cast<String>(),
        basePrice: (json['basePrice'] as num).toInt(),
        unit: json['unit'] as String,
        imageUrl: json['imageUrl'] as String?,
      );
}
