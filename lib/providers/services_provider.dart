// TODO: Implement services state and data access.
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modèle Service minimal (mocké)
class ServiceModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final List<String> features;
  final int basePrice; // FCFA
  final String unit;   // 'jour', 'nuit', 'forfait', 'sur devis'
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
}

/// Provider des services (mocké avec les 6 services Élite Prestations)
final servicesProvider = Provider<List<ServiceModel>>((ref) {
  return const [
    ServiceModel(
      id: '1',
      name: 'Location de Salle Événementielle',
      slug: 'location-salle',
      description:
          'Une salle spacieuse et modulable d\'une capacité de 200 places.',
      features: [
        'Capacité : 200 personnes',
        'Espace modulable',
        'Équipement de base inclus',
        'Localisation stratégique',
      ],
      basePrice: 250000,
      unit: 'jour',
    ),
    ServiceModel(
      id: '2',
      name: 'Organisation de Mariages',
      slug: 'mariage',
      description:
          'Service complet ou à la carte pour un mariage personnalisé.',
      features: [
        'Matériel (sono, décoration…)',
        'Service traiteur',
        'Photographie et vidéo',
        'Personnel dédié',
      ],
      basePrice: 1500000,
      unit: 'sur devis',
    ),
    ServiceModel(
      id: '3',
      name: 'Appartement Meublé',
      slug: 'appartement',
      description:
          'Chambre nuptiale ou hébergement confortable pour vos invités.',
      features: [
        'Salon, chambre, douche, cuisine',
        'WiFi haut débit',
        'Accès sécurisé 24h/24',
        'Idéal mariages et séjours',
      ],
      basePrice: 35000,
      unit: 'nuit',
    ),
    ServiceModel(
      id: '4',
      name: 'Service de Nettoyage',
      slug: 'nettoyage',
      description:
          'Nettoyage professionnel avant et après vos événements.',
      features: [
        'Nettoyage avant événement',
        'Nettoyage après événement',
        'Produits professionnels',
        'Équipe qualifiée',
      ],
      basePrice: 50000,
      unit: 'forfait',
    ),
    ServiceModel(
      id: '5',
      name: 'Services Professionnels',
      slug: 'services-pro',
      description:
          'Accueil, protocole et restauration pour vos événements d\'entreprise.',
      features: [
        'Protocole et accueil',
        'Service pause-café',
        'Service café pour enterrement',
        'Personnel qualifié',
      ],
      basePrice: 0,
      unit: 'sur devis',
    ),
    ServiceModel(
      id: '6',
      name: 'Transport & Accompagnement',
      slug: 'transport',
      description:
          'Solutions de transport et services d\'accompagnement.',
      features: [
        'Transport (bus, véhicules)',
        'Accueil à l\'aéroport',
        'Accompagnement événementiel',
        'Service personnalisé',
      ],
      basePrice: 0,
      unit: 'sur devis',
    ),
  ];
});
