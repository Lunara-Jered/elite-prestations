// TODO: Implement the service details screen.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../providers/services_provider.dart';
import '../../booking/providers/booking_provider.dart'; // <-- IMPORT AJOUTÉ

class ServiceDetailScreen extends ConsumerWidget {
  final String slug;

  const ServiceDetailScreen({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(servicesProvider);
    if (services.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (services.hasError) {
      return Scaffold(
        body: Center(
          child: Text('Impossible de charger le service : ${services.error}'),
        ),
      );
    }
    final serviceList = services.requireValue;
    final matchingServices = serviceList.where((item) => item.slug == slug);
    if (matchingServices.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Service introuvable.')),
      );
    }
    final service = matchingServices.first;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final imagePath = service.imageUrl;
    final serviceImageUrl = imagePath == null || imagePath.isEmpty
      ? null
      : imagePath.startsWith('http://') || imagePath.startsWith('https://')
        ? imagePath
        : Supabase.instance.client.storage
          .from('services')
          .getPublicUrl(imagePath);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ─────────────────────────────────
          // IMAGE HERO (SliverAppBar)
          // ─────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/services'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ajouté aux favoris (à venir)'),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // IMAGE DYNAMIQUE ICI
                    serviceImageUrl != null
                      ? Image.network(
                        serviceImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColors.gray800,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 64,
                                color: AppColors.gray600,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.gray800,
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 64,
                              color: AppColors.gray600,
                            ),
                          ),
                        ),
                  // Overlay gradient pour lisibilité
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─────────────────────────────────
          // CONTENU (Ton code existant reste identique)
          // ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text('4.9', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(width: 12),
                      const Text('•', style: TextStyle(color: AppColors.textMuted)),
                      const SizedBox(width: 12),
                      Text(
                        'Élite Prestations',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isLight ? AppColors.gray100 : AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isLight ? AppColors.border : AppColors.borderDark,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tarif',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textMuted,
                              ),
                        ),
                        Text(
                          service.basePrice > 0
                              ? 'Dès ${_formatPrice(service.basePrice)} / ${service.unit}'
                              : 'Sur devis',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          color: AppColors.textMuted,
                        ),
                  ),
                  const SizedBox(height: 32),
                  Divider(color: isLight ? AppColors.border : AppColors.borderDark),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Ce qui est inclus',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...service.features.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isLight ? AppColors.primary : AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: isLight ? AppColors.white : AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              f,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // espace pour la barre sticky
                ],
              ),
            ),
          ),
        ],
      ),

      // ─────────────────────────────────
      // BARRE STICKY EN BAS
      // ─────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLight ? AppColors.surface : AppColors.surfaceDark,
          border: Border(
            top: BorderSide(
              color: isLight ? AppColors.border : AppColors.borderDark,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    service.basePrice > 0 ? _formatPrice(service.basePrice) : 'Sur devis',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (service.basePrice > 0)
                    Text(
                      '/ ${service.unit}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  // ACTION DU BOUTON RÉSERVER ICI
                  onPressed: () {
                    // 1. On pré-sélectionne le service
                    ref.read(bookingProvider.notifier).selectService(service);
                    // 2. On lance le tunnel de réservation
                    context.go('/booking');
                  },
                  child: const Text('Réserver maintenant'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(str[i]);
    }
    return '$buffer FCFA';
  }
}
