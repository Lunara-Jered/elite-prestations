import 'package:supabase_flutter/supabase_flutter.dart';

class GalleryModel {
  final int id;
  final String imageUrl;
  final String category;
  final String? caption;

  GalleryModel({
    required this.id,
    required this.imageUrl,
    required this.category,
    this.caption,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
  final rawUrl = json['image_url'] as String? ?? '';
  
  // Si l'URL est déjà complète, on la garde. Sinon, on la construit.
  final finalUrl = rawUrl.startsWith('http') 
      ? rawUrl 
      : Supabase.instance.client.storage.from('gallery').getPublicUrl(rawUrl);

  return GalleryModel(
    id: json['id'],
    imageUrl: finalUrl,
    category: json['category'] ?? 'Général',
    caption: json['caption'],
  );
}
}
