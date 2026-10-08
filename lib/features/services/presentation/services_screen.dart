import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/services_provider.dart';
import '../../../shared/widgets/service_card.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  String _selectedFilter = 'Tous';
  String _searchQuery = '';

  /// Catégories pour les filtres
  static const List<String> _filters = [
    'Tous',
    'Salle',
    'Mariage',
    'Séjour',
    'Pro',
    'Transport',
  ];

  /// Filtre les services selon la recherche et la catégorie
  List<ServiceModel> _applyFilters(List<ServiceModel> services) {
    var filtered = services;

    // Filtre par catégorie
    if (_selectedFilter != 'Tous') {
      filtered = filtered.where((s) {
        switch (_selectedFilter) {
          case 'Salle':
            return s.slug.contains('salle');
          case 'Mariage':
            return s.slug.contains('mariage');
          case 'Séjour':
            return s.slug.contains('appartement');
          case 'Pro':
            return s.slug.contains('pro') || s.slug.contains('nettoyage');
          case 'Transport':
            return s.slug.contains('transport');
          default:
            return true;
        }
      }).toList();
    }

    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((s) =>
              s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesProvider);
    final filtered = _applyFilters(services);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Services'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─────────────────────────────────
            // BARRE DE RECHERCHE
            // ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher un service…',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor:
                      isLight ? AppColors.surface : AppColors.surfaceDark,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isLight ? AppColors.border : AppColors.borderDark,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isLight ? AppColors.border : AppColors.borderDark,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isLight ? AppColors.primary : AppColors.white,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            // ─────────────────────────────────
            // FILTRES
            // ─────────────────────────────────
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedFilter = filter);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isLight ? AppColors.primary : AppColors.white)
                            : (isLight
                                ? AppColors.surface
                                : AppColors.surfaceDark),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isSelected
                              ? (isLight
                                  ? AppColors.primary
                                  : AppColors.white)
                              : (isLight
                                  ? AppColors.border
                                  : AppColors.borderDark),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? (isLight
                                    ? AppColors.white
                                    : AppColors.primary)
                                : (isLight
                                    ? AppColors.textPrimary
                                    : AppColors.textOnDark),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // ─────────────────────────────────
            // LISTE DES SERVICES
            // ─────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? _EmptySearch()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final service = filtered[index];
                        return _ServiceListTile(
                          service: service,
                          onTap: () {
                            context.go('/services/${service.slug}');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// TUILE SERVICE (version liste horizontale)
// ─────────────────────────────────────────
class _ServiceListTile extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const _ServiceListTile({
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isLight ? AppColors.surface : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLight ? AppColors.border : AppColors.borderDark,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                height: 160,
                width: double.infinity,
                color: isLight ? AppColors.gray100 : AppColors.gray800,
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: isLight ? AppColors.gray400 : AppColors.gray600,
                  ),
                ),
              ),
            ),

            // Contenu
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    service.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Features (3 premières)
                  ...service.features.take(3).map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 14,
                                color: isLight
                                    ? AppColors.primary
                                    : AppColors.white,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  f,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(height: 12),

                  // Prix + bouton
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.basePrice > 0
                            ? 'Dès ${_formatPrice(service.basePrice)}'
                            : 'Sur devis',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Réserver'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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

// ─────────────────────────────────────────
// ÉTAT VIDE (recherche sans résultats)
// ─────────────────────────────────────────
class _EmptySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun service trouvé',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez un autre mot-clé',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}
