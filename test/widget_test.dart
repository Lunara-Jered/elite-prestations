import 'package:elite_prestations/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('L\'app Élite Prestations démarre correctement',
      (WidgetTester tester) async {
    // Lancer l'app avec le ProviderScope obligatoire pour Riverpod
    await tester.pumpWidget(
      const ProviderScope(
        child: ElitePrestationsApp(),
      ),
    );

    // Laisser le temps au router de charger
    await tester.pumpAndSettle();

    // Vérifier que le titre apparaît
    expect(find.text('ÉLITE PRESTATIONS'), findsOneWidget);

    // Vérifier le slogan
    expect(find.text('Le Meilleur Pour Vous'), findsOneWidget);
  });
}