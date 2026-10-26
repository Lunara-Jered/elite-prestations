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

  Map<String, dynamic> toSupabaseJson() => {
        'name': name,
        'slug': slug,
        'description': description,
        'features': features,
        'base_price': basePrice,
        'unit': unit,
        'image_url': imageUrl,
      };

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: '${json['id']}',
        // On ajoute un ?? '' pour éviter le crash si le name ou le slug est null
        name: json['name'] as String? ?? 'Service sans nom',
        slug: json['slug'] as String? ?? '',
        description: json['description'] as String? ?? '',
        features: (json['features'] as List<dynamic>? ?? const [])
            .map((feature) => feature.toString())
            .toList(),
        basePrice: ((json['base_price'] ?? json['basePrice'] ?? 0) as num)
            .toInt(),
        unit: json['unit'] as String? ?? 'forfait',
        imageUrl: (json['image_url'] ?? json['imageUrl']) as String?,
      );
}
