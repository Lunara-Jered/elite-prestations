import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../providers/gallery_provider.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gallery = ref.watch(galleryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notre Galerie'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: gallery.when(
          data: (photos) {
            if (photos.isEmpty) {
              return const Center(child: Text('Aucune photo pour le moment.'));
            }
            return GridView.builder(
  padding: const EdgeInsets.all(8),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    childAspectRatio: 1,
  ),
  itemCount: photos.length,
  itemBuilder: (context, index) {
    final photo = photos[index];
    return GestureDetector(
      onTap: () {
        // OUVERTURE EN PLEIN ÉCRAN
        showDialog(
          context: context,
          builder: (context) => Dialog.fullscreen(
            backgroundColor: Colors.black,
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer( // Permet de zoomer
                    child: Image.network(photo.imageUrl, fit: BoxFit.contain),
                  ),
                ),
                Positioned(
                  top: 40, right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              photo.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.gray200,
                child: const Icon(Icons.broken_image, color: AppColors.gray400),
              ),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
                child: Text(
                  photo.category,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Erreur : $error')),
        ),
      ),
    );
  }
}