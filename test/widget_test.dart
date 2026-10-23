import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:elite_prestations/app.dart';

void main() {
  testWidgets('L\'application s\'initialise avec des données simulées', (WidgetTester tester) async {
    // 1. Initialise le client mocké
    final mockHttpClient = MockSupabaseHttpClient();
    
    // 2. Initialise Supabase en utilisant ce client mocké
    await Supabase.initialize(
      url: 'https://mock.supabase.co',
      anonKey: 'fakeAnonKey',
      httpClient: mockHttpClient,
    );

    // 3. Insère des fausses données dans le mock (pour les services et la galerie)
    await Supabase.instance.client.from('services').insert([
      {'id': 1, 'name': 'Salle', 'base_price': 250000, 'unit': 'jour'},
    ]);
    await Supabase.instance.client.from('gallery').insert([
      {'id': 1, 'image_url': 'chemin/image.jpg', 'category': 'Mariage'},
    ]);

    // 4. Lance l'application
    await tester.pumpWidget(
      const ProviderScope(
        child: ElitePrestationsApp(),
      ),
    );

    // 5. Laisse le temps à l'app de charger les données mockées
    await tester.pump(const Duration(seconds: 1));

    // 6. Vérifie que l'application ne crashe pas
    expect(find.byType(MaterialApp), findsOneWidget);

    // Nettoyage
    mockHttpClient.close();
  });
}
