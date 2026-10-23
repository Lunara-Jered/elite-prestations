import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../shared/models/gallery_model.dart';

final galleryProvider = FutureProvider<List<GalleryModel>>((ref) async {
  final response = await Supabase.instance.client
      .from('gallery')
      .select()
      .order('display_order', ascending: true);
      
  return (response as List)
      .map((item) => GalleryModel.fromJson(item))
      .toList();
});
