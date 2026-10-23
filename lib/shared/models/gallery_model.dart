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
    return GalleryModel(
      id: json['id'],
      // On récupère l'URL publique de l'image depuis Supabase Storage
      imageUrl: Supabase.instance.client.storage
          .from('gallery')
          .getPublicUrl(json['image_url']),
      category: json['category'] ?? 'Général',
      caption: json['caption'],
    );
  }
}
