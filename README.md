# Elite Prestations

Application mobile Flutter pour Android et iOS.

## Prérequis

- Flutter SDK
- Android Studio avec Android SDK
- Xcode pour la compilation iOS

## Installation

```bash
flutter pub get
```

## Lancement

```bash
flutter run
```

## Configuration

- Nom de l'application : **Elite Prestations**
- Identifiant Android : `com.eliteprestations`
- Identifiant iOS : `com.eliteprestations`

## Structure du code

- `lib/core/` regroupe les constantes, thèmes, routes, utilitaires et services.
- `lib/features/` contient les écrans et la logique organisée par fonctionnalité.
- `lib/shared/` contient les modèles et widgets réutilisables.
- `lib/providers/` est réservé aux providers partagés entre plusieurs fonctionnalités.
- `assets/` accueille les images, icônes et polices de l'application.

Les fichiers de fonctionnalité nouvellement créés sont des points de départ à
compléter. Les fichiers d'images et de polices doivent être ajoutés avant de
pouvoir les déclarer comme assets Flutter.
