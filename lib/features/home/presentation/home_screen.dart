import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/services_provider.dart';
import '../../../providers/gallery_provider.dart'; // Assure-toi d'avoir créé ce provider
import '../../../shared/widgets/service_card.dart';
import '../../../shared/widgets/whatsapp_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(servicesProvider);
    final gallery = ref.watch(galleryProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // ─────────────────────────────────
                // APPBAR
                // ─────────────────────────────────
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  title: const Text(AppStrings.appName),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                // ─────────────────────────────────
                // HERO
                // ─────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: _HeroCard(),
                  ),
                ),

                // ─────────────────────────────────
                // SERVICES (SUPABASE)
                // ─────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nos Services',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton(
                          onPressed: () => context.go('/services'),
                          child: const Row(
                            children: [
                              Text('Tout voir'),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: services.when(
                    data: (serviceList) => SizedBox(
                      height: 260,
                      child: serviceList.isEmpty
                          ? const Center(child: Text('Aucun service disponible'))
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: serviceList.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 280,
                                  child: ServiceCard(
                                    service: serviceList[index],
                                    onTap: () => context.go('/services'),
                                  ),
                                );
                              },
                            ),
                    ),
                    loading: () => const SizedBox(
                      height: 260,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) => SizedBox(
                      height: 260,
                      child: Center(
                        child: Text(
                          'Impossible de charger les services : $error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                  ),
                ),

                // ─────────────────────────────────
                // RÉALISATIONS (SUPABASE STORAGE)
                // ─────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                    child: Text(
                      'Nos Réalisations',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),

                gallery.when(
                  data: (photos) => SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: photos.isEmpty
                        ? const SliverToBoxAdapter(
                            child: Center(child: Text('Aucune photo disponible')),
                          )
                        : SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final photo = photos[index];
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        photo.imageUrl,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            color: AppColors.gray100,
                                            child: const Center(
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: AppColors.gray200,
                                            child: const Icon(Icons.broken_image, color: AppColors.gray400),
                                          );
                                        },
                                      ),
                                      // Dégradé et catégorie en bas de l'image
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
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
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount: photos.length > 4 ? 4 : photos.length, // Limite à 4 sur l'accueil
                            ),
                          ),
                  ),
                  loading: () => const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (error, stackTrace) => SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: Center(child: Text('Erreur galerie : $error')),
                    ),
                  ),
                ),

                // ─────────────────────────────────
                // INSTAGRAM (Placeholder conservé)
                // ─────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                    child: Row(
                      children: [
                        const Icon(Icons.photo_camera_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Suivez-nous @eliteprestation',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 6,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.gray200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.image_outlined,
                              color: AppColors.gray400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),

            // ─────────────────────────────────
            // FAB WHATSAPP FLOTTANT
            // ─────────────────────────────────
            const Positioned(
              bottom: 16,
              right: 16,
              child: WhatsAppButton(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// HERO CARD
// ─────────────────────────────────────────
class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // Image de fond depuis Unsplash (libre de droits)
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=1000&auto=format&fit=crop'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Overlay sombre pour lire le texte
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x66000000), Color(0xCC000000)],
                ),
              ),
            ),
          ),

          // Contenu
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ÉLITE PRESTATIONS',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Le Meilleur Pour Vous',
                      style: TextStyle(
                        color: AppColors.gray300,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Élégance &\nProfessionnalisme',
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.go('/booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(0, 44),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 16),
                          SizedBox(width: 8),
                          Text('Planifier mon événement'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
