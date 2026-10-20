import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/local_storage_service.dart';
import '../shared/models/service_model.dart';

export '../shared/models/service_model.dart';

const _servicesStorageKey = 'services';

const _defaultServices = [
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
    description: 'Service complet ou à la carte pour un mariage personnalisé.',
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
    description: 'Nettoyage professionnel avant et après vos événements.',
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
    description: 'Solutions de transport et services d\'accompagnement.',
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

final servicesProvider =
    NotifierProvider<ServicesNotifier, List<ServiceModel>>(
  ServicesNotifier.new,
);

class ServicesNotifier extends Notifier<List<ServiceModel>> {
  late LocalStorageService _storage;
  late Future<void> _initialization;

  @override
  List<ServiceModel> build() {
    _storage = ref.read(localStorageServiceProvider);
    _initialization = Future<void>.value();
    final saved = _storage.readList(
      _servicesStorageKey,
      ServiceModel.fromJson,
    );
    if (saved.isNotEmpty) return saved;

    _initialization = _saveDefaults();
    return List.unmodifiable(_defaultServices);
  }

  Future<void> _saveDefaults() async {
    try {
      await _storage.saveList(
        _servicesStorageKey,
        _defaultServices,
        (service) => service.toJson(),
      );
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'services provider',
          context: ErrorDescription('while saving default services'),
        ),
      );
    }
  }

  Future<void> addService(ServiceModel service) async {
    if (state.any((item) => item.id == service.id)) {
      throw StateError('Un service avec cet identifiant existe déjà.');
    }
    await _save([...state, service]);
  }

  Future<void> updateService(ServiceModel service) async {
    final index = state.indexWhere((item) => item.id == service.id);
    if (index < 0) throw StateError('Service introuvable.');
    final updated = [...state];
    updated[index] = service;
    await _save(updated);
  }

  Future<void> deleteService(String id) async {
    if (!state.any((service) => service.id == id)) {
      throw StateError('Service introuvable.');
    }
    await _save(state.where((service) => service.id != id).toList());
  }

  Future<void> _save(List<ServiceModel> services) async {
    await _initialization;
    await _storage.saveList(
      _servicesStorageKey,
      services,
      (service) => service.toJson(),
    );
    state = List.unmodifiable(services);
  }
}
