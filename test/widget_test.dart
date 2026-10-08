import 'package:elite_prestations/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('affiche le titre Elite Prestations', (WidgetTester tester) async {
    await tester.pumpWidget(const ElitePrestationsApp());

    expect(find.text('Elite Prestations'), findsOneWidget);
    expect(find.text('Votre application prend forme ici.'), findsOneWidget);
  });
}
