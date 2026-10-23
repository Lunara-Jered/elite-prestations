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
flutter run \
  --dart-define=SUPABASE_URL=https://your-project-ref.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-public-anon-key
```

L'application lit `SUPABASE_URL` et `SUPABASE_ANON_KEY` au démarrage. Seule la
clé publique `anon` doit être fournie au client Flutter ; ne placez jamais la
clé `service_role` dans l'application. Sans ces variables, les écrans concernés
affichent une erreur de configuration au lieu de simuler une connexion réussie.

Le projet Supabase doit fournir une table `services` avec les colonnes `id`,
`name`, `slug`, `description`, `features`, `base_price`, `unit` et `image_url`.
La table `reservations` doit fournir `id`, `reference`, `service_name`,
`start_date`, `end_date`, `duration`, `total_ttc`, `deposit`, `status`,
`options`, `created_at`, `user_id`, `client_name` et `client_email`. Les colonnes
`id` sont générées par la base ; `user_id` doit accepter `NULL` si les réservations
invitées sont autorisées. Configurez les politiques RLS adaptées à ces tables.
Pour qu'une réservation soit rattachée à un compte et filtrée par utilisateur,
l'utilisateur doit être authentifié auprès de Supabase.

La table `invoices` doit fournir les colonnes `id` (texte), `number`, `type`,
`client_name`, `client_address`, `client_nif`, `client_email`, `client_phone`,
`issue_date`, `due_date`, `lines` (JSON), `subtotal_ht`, `tps`, `total_ttc`,
`notes`, `conditions`, `subject`, `invoice_status`, `devis_status`,
`created_at` et `user_id`. Les factures sont lues, créées et mises à jour dans
Supabase ; configurez ses politiques RLS pour autoriser les opérations adaptées.
Les devis restent stockés localement.

La confirmation ouvre WhatsApp avec un récapitulatif prérempli. Pour des raisons
de consentement, l'utilisateur doit appuyer sur « Envoyer » dans WhatsApp.

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
