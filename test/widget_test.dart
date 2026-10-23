import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_test/supabase_test.dart'; // <-- IMPORTANT
import 'package:elite_prestations/app.dart';

void main() {
  testWidgets('L\'application s\'initialise avec des données simulées', (WidgetTester tester) async {
    // 1. On crée un faux client Supabase avec des données mockées
    final httpClient = MockSupabaseHttpClient()
      ..stubTable('services', rows: [
        {'id': 1, 'name': 'Salle', 'base_price': 250000, 'unit': 'jour'},
      ])
      ..stubTable('gallery', rows: [
        {'id': 1, 'image_url': 'chemin/image.jpg', 'category': 'Mariage'},
      ]);

    // 2. On initialise un faux Supabase pour le test
    final supabase = testSupabaseClient(httpClient: httpClient);
    addTearDown(supabase.dispose);

    // 3. On lance l'app
    await tester.pumpWidget(
      const ProviderScope(
        child: ElitePrestationsApp(),
      ),
    );

    // 4. On laisse le temps au premier écran de s'afficher
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // 5. On vérifie que l'application ne crashe pas
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
