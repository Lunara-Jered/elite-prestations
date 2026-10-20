import 'package:elite_prestations/app.dart';
import 'package:elite_prestations/core/services/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('L\'app Élite Prestations démarre correctement',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStorageServiceProvider.overrideWithValue(
            LocalStorageService(preferences),
          ),
        ],
        child: const ElitePrestationsApp(),
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