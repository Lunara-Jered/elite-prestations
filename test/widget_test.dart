import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_prestations/app.dart';

void main() {
  testWidgets('L\'application s\'initialise sans erreur', (WidgetTester tester) async {
    // 1. On lance l'application enveloppée dans le ProviderScope (pour Riverpod)
    await tester.pumpWidget(
      const ProviderScope(
        child: ElitePrestationsApp(),
      ),
    );

    // 2. On laisse le temps à l'écran de chargement de s'afficher
    await tester.pump();

    // 3. On vérifie que l'écran de chargement ou l'appbar est présent
    // (Ici on vérifie juste que l'application ne crashe pas au démarrage)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
