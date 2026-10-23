import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Un widget de base s\'affiche correctement', (WidgetTester tester) async {
    // On teste un widget simple qui ne dépend pas de Supabase
    // Cela vérifie que l'environnement de test est fonctionnel.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Test de l\'application'),
            ),
          ),
        ),
      ),
    );

    // On vérifie que le texte est bien affiché
    expect(find.text('Test de l\'application'), findsOneWidget);
  });
}
